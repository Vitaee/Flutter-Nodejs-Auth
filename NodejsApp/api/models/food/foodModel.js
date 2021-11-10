const moongoose = require('mongoose');


const foodSchema = moongoose.Schema({
    sourceLink: {
        type: String
    },
    imageSource: {
        type: String
    },
    foodTitle: {
        type: String
    },
    MadeBy: {
        type: String
    },
    prepTime: {
        type: String
    },
    cookTime: {
        type: String
    },
    madeLevel: {
        type: String
    },
    servers: {
        type: String
    },
    shortInfo: {
        type: String
    },
    
    nutritions: [String],

    ingredients: [String],
    
    methods: [String],

}, {timestamps:true});

const Food = moongoose.model('Food', foodSchema);

module.exports = {
    Food:Food,
    foodSchema:foodSchema
}

