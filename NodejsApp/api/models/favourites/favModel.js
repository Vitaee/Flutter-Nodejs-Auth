import mongoose from 'mongoose';

const favSchema = mongoose.Schema({
    name: {
        type: String
    },

    description: {
        type: String
    },
    image: {
        type: String
    },
    owner: {
        type: mongoose.Types.ObjectId, ref: "User"
    }
}, { timestamps: true });

const Fav = mongoose.model('Fav', favSchema)

export const favModel = Fav
export const schemaFav = favSchema