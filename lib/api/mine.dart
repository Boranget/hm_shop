import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/home.dart';

/// 获取猜你喜欢列表API
/// [params] 请求参数，包含page、pageSize等
Future<GoodsDetailsItems> getGuessListAPI(Map<String, dynamic> params) async {
  return GoodsDetailsItems.fromJSON(
    await dioRequest.get(HttpConstants.GUESS_LIST, params: params),
  );
}
