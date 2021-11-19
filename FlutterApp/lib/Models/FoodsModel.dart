class Foods {
  List<String>? nutritions;
  List<String>? ingredients;
  List<String>? methods;
  String? sId;
  String? sourceLink;
  String? imageSource;
  String? foodTitle;
  String? madeBy;
  String? prepTime;
  String? cookTime;
  String? madeLevel;
  String? servers;
  String? shortInfo;

  Foods(
      {required this.nutritions,
      required this.ingredients,
      required this.methods,
      required this.sId,
      required this.sourceLink,
      required this.imageSource,
      required this.foodTitle,
      required this.madeBy,
      required this.prepTime,
      required this.cookTime,
      required this.madeLevel,
      required this.servers,
      required this.shortInfo});

  Foods.fromJson(Map<String, dynamic> json) {
    nutritions = json['nutritions'].cast<String>();
    ingredients = json['ingredients'].cast<String>();
    methods = json['methods'].cast<String>();
    sId = json['_id'];
    sourceLink = json['source_link'];
    imageSource = json['image_source'];
    foodTitle = json['food_title'];
    madeBy = json['made_by'];
    prepTime = json['prep_time'];
    cookTime = json['cook_time'];
    madeLevel = json['made_level'];
    servers = json['servers'];
    shortInfo = json['short_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nutritions'] = this.nutritions;
    data['ingredients'] = this.ingredients;
    data['methods'] = this.methods;
    data['_id'] = this.sId;
    data['source_link'] = this.sourceLink;
    data['image_source'] = this.imageSource;
    data['food_title'] = this.foodTitle;
    data['made_by'] = this.madeBy;
    data['prep_time'] = this.prepTime;
    data['cook_time'] = this.cookTime;
    data['made_level'] = this.madeLevel;
    data['servers'] = this.servers;
    data['short_info'] = this.shortInfo;
    return data;
  }
}
