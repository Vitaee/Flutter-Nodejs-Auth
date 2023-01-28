import { foodModel } from '../../models/food/index.js';

export default async (req,res) => {
  try {
      let data = req.body;
      let queryArr = []

      let index_count = 0

      for (var key in data){
        let dynamic_key = Object.keys(data)[index_count]
        let json_object =   { [dynamic_key] : { '$regex': `${data[key]}`, '$options': 'i' } }  
        queryArr.push( json_object );
        index_count += 1
      }

      const results = await foodModel.find({ $or: queryArr })
        
      results.length >= 1 ? res.status(200).send(results) : res.status(200).send({"msg":"Not found."})
          
   } catch (err) {
    console.log(err)
    res.status(401);
    res.send("Unexpected Error");
  
  }

}