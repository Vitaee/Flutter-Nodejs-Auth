class Foods {
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
}
