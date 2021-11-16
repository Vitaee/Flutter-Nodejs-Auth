const moongoose = require('mongoose');


const foodSchema = moongoose.Schema({
    source_link: {
        type: String
    },
    image_source: {
        type: String
    },
    food_title: {
        type: String
    },
    made_by: {
        type: String
    },
    prep_time: {
        type: String
    },
    cook_time: {
        type: String
    },
    made_level: {
        type: String
    },
    servers: {
        type: String
    },
    short_info: {
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

