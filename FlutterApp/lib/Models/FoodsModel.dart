class Foods {
  List<String>? recipeNutrition;
  List<String>? recipeIngredient;
  List<String>? recipeInstructions;
  List<String>? recipeCuisine;
  List<String>? recipeCategory;
  String? sId;
  String? sourceUrl;
  String? image;
  String? videoUrl;
  String? videoDuration;
  String? foodName;
  String? foodDescription;
  String? prepTime;
  String? cookTime;
  String? totalTime;
  String? recipeYield;
  String? authorName;

  Foods(
      {this.recipeNutrition,
      this.recipeIngredient,
      this.recipeInstructions,
      this.recipeCuisine,
      this.recipeCategory,
      this.sId,
      this.sourceUrl,
      this.image,
      this.videoUrl,
      this.videoDuration,
      this.foodName,
      this.foodDescription,
      this.prepTime,
      this.cookTime,
      this.totalTime,
      this.recipeYield,
      this.authorName});

  Foods.fromJson(Map<String, dynamic> json) {
    recipeNutrition = json['recipeNutrition'].cast<String>();
    recipeIngredient = json['recipeIngredient'].cast<String>();
    recipeInstructions = json['recipeInstructions'].cast<String>();
    recipeCuisine = json['recipeCuisine'].cast<String>();
    recipeCategory = json['recipeCategory'].cast<String>();
    sId = json['_id'];
    sourceUrl = json['sourceUrl'];
    image = json['image'];
    videoUrl = json['videoUrl'];
    videoDuration = json['videoDuration'];
    foodName = json['foodName'];
    foodDescription = json['foodDescription'];
    prepTime = json['prepTime'];
    cookTime = json['cookTime'];
    totalTime = json['totalTime'];
    recipeYield = json['recipeYield'];
    authorName = json['authorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipeNutrition'] = this.recipeNutrition;
    data['recipeIngredient'] = this.recipeIngredient;
    data['recipeInstructions'] = this.recipeInstructions;
    data['recipeCuisine'] = this.recipeCuisine;
    data['recipeCategory'] = this.recipeCategory;
    data['_id'] = this.sId;
    data['sourceUrl'] = this.sourceUrl;
    data['image'] = this.image;
    data['videoUrl'] = this.videoUrl;
    data['videoDuration'] = this.videoDuration;
    data['foodName'] = this.foodName;
    data['foodDescription'] = this.foodDescription;
    data['prepTime'] = this.prepTime;
    data['cookTime'] = this.cookTime;
    data['totalTime'] = this.totalTime;
    data['recipeYield'] = this.recipeYield;
    data['authorName'] = this.authorName;
    return data;
  }
}
