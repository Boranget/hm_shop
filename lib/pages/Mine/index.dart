import 'package:flutter/material.dart';
// 导入你项目中的API、实体类、常量（按实际路径修改）
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/api/mine.dart';
import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/viewmodels/home.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 猜你喜欢列表数据
  List<GoodDetailItem> _list = [];
  // 分页请求参数
  final Map<String, dynamic> _params = {"page": 1, "pageSize": 10};
  // 滚动控制器
  final ScrollController _controller = ScrollController();
  // 阀门控制：是否正在加载、是否还有下一页
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    // 初始化加载第一页数据
    _getGuessList();
    // 注册滚动监听
    _registerEvent();
  }

  @override
  void dispose() {
    // 销毁滚动监听，防止内存泄漏
    _controller.dispose();
    super.dispose();
  }

  // 注册滚动到底部加载更多事件
  void _registerEvent() {
    _controller.addListener(() {
      // 滚动逻辑：距离底部50px时触发加载
      if (_controller.position.pixels >=
          (_controller.position.maxScrollExtent - 50)) {
        _getGuessList();
      }
    });
  }

  // 获取猜你喜欢列表（分页加载）
  Future<void> _getGuessList() async {
    // 阀门控制：正在加载或无更多数据，直接返回
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 发起API请求
      final res = await getGuessListAPI(_params);
      // 追加数据到列表（而非覆盖）
      _list.addAll(res.items);
      // 判断是否还有下一页（根据接口返回的总页数/当前页判断）
      if (_params["page"] >= res.pages) {
        _hasMore = false;
      } else {
        // 页码+1，准备加载下一页
        _params["page"]++;
      }
    } catch (e) {
      // 异常处理（可选：提示加载失败）
      debugPrint("加载猜你喜欢失败：$e");
    } finally {
      // 无论成功失败，重置加载状态
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 构建头部（示例，按实际UI修改）
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "个人中心头部",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 构建VIP卡片（示例，按实际UI修改）
  Widget _buildVipCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Padding(padding: EdgeInsets.all(16), child: Text("VIP卡片区域")),
    );
  }

  // 构建快捷操作（示例，按实际UI修改）
  Widget _buildQuickActions() {
    return const Padding(padding: EdgeInsets.all(16), child: Text("快捷操作区域"));
  }

  // 构建订单模块（示例，按实际UI修改）
  Widget _buildOrderModule() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Padding(padding: EdgeInsets.all(16), child: Text("我的订单模块")),
    );
  }

  // 构建猜你喜欢列表（支持加载更多）
  Widget _buildGuessList() {
    // 无数据时显示空状态
    if (_list.isEmpty && !_isLoading) {
      return const Center(child: Text("暂无猜你喜欢数据"));
    }
    // 有数据时构建列表
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _list.length + (_hasMore ? 1 : 0), // 多一个加载更多项
      itemBuilder: (context, index) {
        // 最后一项：加载更多提示/加载中
        if (index == _list.length) {
          return _buildLoadMoreWidget();
        }
        // 商品项（使用首页类似的网格布局）
        final item = _list[index];
        return _buildProductItem(item);
      },
    );
  }

  // 构建单个商品项（参考首页样式）
  Widget _buildProductItem(GoodDetailItem item) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品图片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.picture ?? "",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // 商品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "商品名称",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "¥${double.tryParse(item.price ?? '0')?.toStringAsFixed(2) ?? "0.00"}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建加载更多组件
  Widget _buildLoadMoreWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // 加载中
            : _hasMore
            ? const Text("上拉加载更多") // 可加载
            : const Text("没有更多数据了"), // 无更多数据
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // Add this line to support AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildVipCard()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildOrderModule()),
          SliverPersistentHeader(delegate: HmGuess(), pinned: true),
          SliverToBoxAdapter(child: _buildGuessList()),
        ],
      ),
    );
  }
}

// 示例：吸顶标题组件（HmGuess，按实际需求修改）
class HmGuess extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 50,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(
        "猜你喜欢",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
