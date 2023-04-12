import mongoose from 'mongoose';

const foodSchema =  mongoose.Schema({
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

const Food = mongoose.model('foods', foodSchema);

export const foodModel = Food
export const schemaFood = foodSchema 
