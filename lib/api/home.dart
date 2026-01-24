import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/home.dart';

Future<List<BannerItem>> getBannerListAPI() async {
  final res = await dioRequest.get(HttpConstants.BANNER_LIST) as List;
  return res
      .map<BannerItem>(
        (item) => BannerItem.fromJson(item as Map<String, dynamic>),
      )
      .toList();
}

Future<List<CategoryItem>> getCategoryListAPI() async {
  final res = await dioRequest.get(HttpConstants.CATEGORY_LIST) as List;
  return res
      .map<CategoryItem>(
        (item) => CategoryItem.fromJson(item as Map<String, dynamic>),
      )
      .toList();
}

Future<SpecialRecommendResult> getProductListAPI() async {
  final res = await dioRequest.get(HttpConstants.PRODUCT_LIST);
  return SpecialRecommendResult.fromJson(res);
}

Future<SpecialRecommendResult> getInVogueListAPI() async {
  final res = await dioRequest.get(HttpConstants.IN_VOGUE_LIST);
  return SpecialRecommendResult.fromJson(res);
}

Future<SpecialRecommendResult> getOneStopListAPI() async {
  final res = await dioRequest.get(HttpConstants.ONE_STOP_LIST);
  return SpecialRecommendResult.fromJson(res);
}

// 推荐列表API
Future<List<GoodDetailItem>> getRecommendListAPI(
  Map<String, dynamic> params,
) async {
  // 发起请求
  final response = await dioRequest.get(
    HttpConstants.RECOMMEND_LIST, // 推荐列表接口地址
    params: params, // 请求参数
  );

  // 解析响应：将List类型的响应数据转为GoodDetailItem列表
  return (response as List)
      .map((item) => GoodDetailItem.fromJSON(item as Map<String, dynamic>))
      .toList();
}
