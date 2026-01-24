import 'package:flutter/material.dart';
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/components/Home/HmCategory.dart';
import 'package:hm_shop/components/Home/HmHot.dart';
import 'package:hm_shop/components/Home/HmMoreList.dart';
import 'package:hm_shop/components/Home/HmSlider.dart';
import 'package:hm_shop/components/Home/HmSuggestion.dart';
import 'package:hm_shop/utils/ToastUtils.dart';
import 'package:hm_shop/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BannerItem> _bannerList = [];
  List<CategoryItem> _categoryList = [];
  List<Widget> _getScrollChildren() {
    return [
      SliverToBoxAdapter(child: HmSlider(bannerList: _bannerList)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(child: HmCategory(categoryList: _categoryList)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: HmSuggestion(specialRecommendResult: _specialRecommendResult),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: HmHot(result: _inVogueResult, type: "hot"),
              ),
              SizedBox(width: 10),
              Expanded(
                child: HmHot(result: _oneStopResult, type: "step"),
              ),
            ],
          ),
        ),
      ),
      HmMoreList(recommendList: _recommendList),
    ];
  }

  // 初始化获取数据
  // 热榜推荐
  SpecialRecommendResult _inVogueResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );
  // 一站式推荐
  SpecialRecommendResult _oneStopResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );

  // 推荐列表数据
  List<GoodDetailItem> _recommendList = [];
  // 分页相关状态
  int _page = 1;
  bool _isLoading = false; // 当前正在加载状态
  bool _hasMore = true; // 是否还有下一页

  // 监听滚动到底部的事件
  void _registerEvent() {
    _scrollController.addListener(() {
      // 滚动到距离底部50像素内时触发
      if (_scrollController.position.pixels >=
          (_scrollController.position.maxScrollExtent - 50)) {
        // 加载下一页数据
        _getRecommendList();
      }
    });
  }

  // 获取推荐列表（分页加载）
  Future<void> _getRecommendList() async {
    // 正在加载 或 没有下一页时，终止请求
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true; // 标记为加载中（防止重复请求）
    int requestLimit = _page * 8; // 计算当前页的请求数量
    // 调用API获取数据
    _recommendList = await getRecommendListAPI({"limit": requestLimit});
    _isLoading = false; // 解除加载中标记

    // 判断是否还有下一页：返回数据量小于请求量 → 没有更多数据
    if (_recommendList.length < requestLimit) {
      _hasMore = false;
      setState(() {});
      return;
    }

    _page++; // 页码自增（准备下一页请求）
    setState(() {}); // 刷新UI
  }

  // 获取热榜推荐列表
  Future<void> _getInVogueList() async {
    _inVogueResult = await getInVogueListAPI();
    setState(() {});
  }

  // 获取一站式推荐列表
  Future<void> _getOneStopList() async {
    _oneStopResult = await getOneStopListAPI();
    setState(() {});
  }

  Future<void> _getProductList() async {
    _specialRecommendResult = await getProductListAPI();
    setState(() {});
  }

  Future<void> _getBannerList() async {
    _bannerList = await getBannerListAPI();
    setState(() {});
  }

  Future<void> _getCategoryList() async {
    _categoryList = await getCategoryListAPI();
    setState(() {});
  }

  SpecialRecommendResult _specialRecommendResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );
  @override
  void initState() {
    super.initState();
    _registerEvent();
    Future.microtask(() {
      _paddingTop = 100;
      setState(() {});
      _key.currentState?.show();
    });
  }

  final ScrollController _scrollController = ScrollController();
  double _paddingTop = 0;
  Future<void> _onRefresh() async {
    _page = 1;
    _isLoading = false; // 当前正在加载状态
    _hasMore = true; // 是否还有下一页
    await _getBannerList();
    await _getCategoryList();
    await _getProductList();
    await _getInVogueList();
    await _getOneStopList();
    await _getRecommendList();
    ToastUtils.showToast(context, "msg");
    _paddingTop = 0;
    setState(() {});
  }

  // 下拉刷新组件的全局Key（用于主动触发刷新）
  final GlobalKey<RefreshIndicatorState> _key =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _key,
      onRefresh: _onRefresh,
      child: AnimatedContainer(
        padding: EdgeInsets.only(top: _paddingTop),
        duration: Duration(milliseconds: 300),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: _getScrollChildren(),
        ),
      ),
    );
  }
}
