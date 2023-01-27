const moongoose = require('mongoose');

/*
sourceUrl
image
videoUrl
videoDuration
foodName
foodDescription
prepTime
cookTime
totalTime
recipeNutrition
recipeIngredient
recipeInstructions
recipeCuisine
recipeCategory
recipeYield
authorName

*/
const foodSchema = moongoose.Schema({
    sourceUrl: {
        type: String
    },
    image: {
        type: String
    },
    videoUrl: {
        type: String
    },
    videoDuration: {
        type: String
    },
    foodName: {
        type: String
    },
    foodDescription: {
        type: String
    },
    prepTime: {
        type: String
    },
    cookTime: {
        type: String
    },
    totalTime: {
        type: String
    },
    recipeNutrition: [String],

    recipeIngredient: [String],
    
    recipeInstructions: [String],

    recipeCuisine: [String],
    
    recipeCategory: [String],
    recipeYield:  { 
        type: String
    },
    authorName: {
        type: String
    }
    
}, {timestamps:true});

const Food = moongoose.model('Food', foodSchema);

module.exports = {
    Food:Food,
    foodSchema:foodSchema
}

