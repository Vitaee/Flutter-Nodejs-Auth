/*class Foods {
  String id;
  String sharedBy;
  String foodName;
  String sourceLink;
  String servings;
  String prepTime;
  List<String> ingredients;
  List<String> directions;
  String image;

  Foods(
      {this.id,
      this.sharedBy,
      this.foodName,
      this.sourceLink,
      this.servings,
      this.prepTime,
      this.ingredients,
      this.directions,
      this.image});

  Foods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sharedBy = json['shared_by'];
    foodName = json['food_name'];
    sourceLink = json['source_link'];
    servings = json['servings'];
    prepTime = json['prep_time'];
    ingredients = json['ingredients'].cast<String>();
    directions = json['directions'].cast<String>();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shared_by'] = this.sharedBy;
    data['food_name'] = this.foodName;
    data['source_link'] = this.sourceLink;
    data['servings'] = this.servings;
    data['prep_time'] = this.prepTime;
    data['ingredients'] = this.ingredients;
    data['directions'] = this.directions;
    data['image'] = this.image;
    return data;
  }
}*/

class Foods {
  List<String> nutritions;
  List<String> ingredients;
  List<String> methods;
  String sId;
  String sourceLink;
  String imageSource;
  String foodTitle;
  String madeBy;
  String prepTime;
  String cookTime;
  String madeLevel;
  String servers;
  String shortInfo;

  Foods(
      {this.nutritions,
      this.ingredients,
      this.methods,
      this.sId,
      this.sourceLink,
      this.imageSource,
      this.foodTitle,
      this.madeBy,
      this.prepTime,
      this.cookTime,
      this.madeLevel,
      this.servers,
      this.shortInfo});

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
