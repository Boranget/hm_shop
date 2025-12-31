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
