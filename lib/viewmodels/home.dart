class BannerItem {
  String id;
  String imgUrl;
  BannerItem({required this.id, required this.imgUrl});
  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(id: json["id"] ?? "", imgUrl: json["imgUrl"] ?? "");
  }
}

class CategoryItem {
  String id;
  String name;
  String picture;
  List<CategoryItem>? children;
  CategoryItem({
    required this.id,
    required this.name,
    required this.picture,
    this.children,
  });
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      picture: json["picture"] ?? "",
      children: json["children"] != null
          ? List.generate(
              json["children"].length,
              (index) => CategoryItem.fromJson(json["children"][index]),
            )
          : null,
    );
  }
}

// 新增：对应 result 字段
class SpecialRecommendResult {
  String id;
  String title;
  List<SubType> subTypes;
  SpecialRecommendResult({
    required this.id,
    required this.title,
    required this.subTypes,
  });
  factory SpecialRecommendResult.fromJson(Map<String, dynamic> json) {
    return SpecialRecommendResult(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      subTypes: List.generate(
        json["subTypes"].length,
        (index) => SubType.fromJson(json["subTypes"][index]),
      ),
    );
  }
}

// 新增：对应 subTypes 中的每一项
class SubType {
  String id;
  String title;
  GoodsItems goodsItems;
  SubType({required this.id, required this.title, required this.goodsItems});
  factory SubType.fromJson(Map<String, dynamic> json) {
    return SubType(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      goodsItems: GoodsItems.fromJson(json["goodsItems"]),
    );
  }
}

// 新增：对应 goodsItems 字段
class GoodsItems {
  int counts;
  int pageSize;
  int pages;
  int page;
  List<GoodsItem> items;
  GoodsItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });
  factory GoodsItems.fromJson(Map<String, dynamic> json) {
    return GoodsItems(
      counts: json["counts"] as int? ?? 0,
      pageSize: json["pageSize"] as int? ?? 0,
      pages: json["pages"] as int? ?? 0,
      page: json["page"] as int? ?? 0,
      items: List.generate(
        json["items"].length,
        (index) => GoodsItem.fromJson(json["items"][index]),
      ),
    );
  }
}

// 新增：对应 items 中的每一个商品
class GoodsItem {
  String id;
  String name;
  String desc;
  String price;
  String picture;
  int orderNum;
  GoodsItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.picture,
    required this.orderNum,
  });
  factory GoodsItem.fromJson(Map<String, dynamic> json) {
    return GoodsItem(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      desc: json["desc"] ?? "",
      price: json["price"] ?? "",
      picture: json["picture"] ?? "",
      orderNum: json["orderNum"] as int? ?? 0,
    );
  }
}

// 列表类型：商品详情项（继承自GoodsItem）
class GoodDetailItem extends GoodsItem {
  int payCount = 0;

  /// 商品详情项构造方法
  GoodDetailItem({
    required super.id,
    required super.name,
    required super.price,
    required super.picture,
    required super.orderNum,
    required this.payCount,
  }) : super(desc: ""); // 调用父类构造，desc默认空字符串

  /// 转化方法：从JSON映射生成GoodDetailItem实例
  factory GoodDetailItem.fromJSON(Map<String, dynamic> json) {
    return GoodDetailItem(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      price: json["price"]?.toString() ?? "",
      picture: json["picture"]?.toString() ?? "",
      orderNum: int.tryParse(json["orderNum"]?.toString() ?? "0") ?? 0,
      payCount: int.tryParse(json["payCount"]?.toString() ?? "0") ?? 0,
    );
  }
}

class GoodsDetailsItems {
  int counts;
  int pageSize;
  int pages;
  int page;
  List<GoodDetailItem> items;
  GoodsDetailsItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });
  factory GoodsDetailsItems.fromJSON(Map<String, dynamic> json) {
    return GoodsDetailsItems(
      counts: json["counts"] as int? ?? 0,
      pageSize: json["pageSize"] as int? ?? 0,
      pages: json["pages"] as int? ?? 0,
      page: json["page"] as int? ?? 0,
      items: List.generate(
        json["items"].length,
        (index) => GoodDetailItem.fromJSON(json["items"][index]),
      ),
    );
  }
}
