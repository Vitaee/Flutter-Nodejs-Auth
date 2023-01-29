import { foodModel } from '../../models/food/index.js';

export default async (req,res) => {
  try {
      let queryArr = [
        { 'foodName' :  { '$regex': `${req.body.search}`, '$options': 'i' } },
        { 'foodDescription' :  { '$regex': `${req.body.search}`, '$options': 'i' } },
        {'recipeCategory' : {'$regex' : `${req.body.search}` , '$options' : 'i'} },
        { 'recipeCuisine' : {'$regex' : `${req.body.search}` , '$options' : 'i'} }
      ]
      
      const results = await foodModel.find({ $or: queryArr })
        
      results.length >= 1 ? res.status(200).send(results) : res.status(200).send({"msg":"Not found."})
          
   } catch (err) {
    console.log(err)
    res.status(401);
    res.send("Unexpected Error");
  
  }

}