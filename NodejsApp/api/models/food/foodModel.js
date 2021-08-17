const moongoose = require('mongoose');


const foodSchema = moongoose.Schema({
    sharedBy: {
        type: String
    },
    foodName: {
        type: String
    },
    sourceLink: {
        type: String
    },
    servings: {
        type: String
    },
    prepTime: {
        type: String
    },
    ingredients: [String],
    
    directions: [String],
    image: {
        type: String
    },

}, {timestamps:true});

const Food = moongoose.model('Food', foodSchema);

module.exports = {
    Food:Food,
    foodSchema:foodSchema
}

