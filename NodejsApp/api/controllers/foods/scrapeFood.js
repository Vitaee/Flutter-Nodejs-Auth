import { foodModel } from '../../models/food/index.js';
import errorJson from '../../../utils/error.js';
import axios from 'axios';
import * as cheerio from 'cheerio';
import * as dotenv from 'dotenv'
dotenv.config()

/**
 * These function scrape links from a response
 * that contains source links of data.
 * @param {int} limit scrape source links
 * @returns - Array of source links 
 */
const getSourceLinks =  async () =>{
    let response = await axios.get(process.env.API_URL)
    let data = response.data
    let arr = []
    for (let x in data["items"]) {
        const check_url_if_in_db = await foodModel.find({'sourceUrl':  "https://www.bbcgoodfood.com" + data["items"][x]['url'] });

        if (check_url_if_in_db.length >= 1) {
            console.log("This food recipe already in database.")
        } else {
            arr.push("https://www.bbcgoodfood.com" + data["items"][x]['url'])
        }
    }

    return arr
}

/**
 * These function scrape details from each source links.
 * @param {Array} source of links 
 * @returns - Array of json object that contains data.
 */
const readDetails = async(sourceLinks = []) => {
    let temp_array = []

    for (let index = 0; index < sourceLinks.length; index++) {
        let json_object = {}
        let response = await axios.get(sourceLinks[index])
        let $ = await cheerio.load(response.data);

        let data = JSON.parse( $('#__NEXT_DATA__')[0].children[0].data )


        json_object["sourceUrl"] = data["props"]["pageProps"]["pageUrl"]
        json_object["image"] = data["props"]["pageProps"]["image"]["url"]
        json_object["videoUrl"] = ""
        json_object["videoDuration"] = ""

        json_object["foodName"] = data["props"]["pageProps"]["seoMetadata"]["title"]

        json_object["foodDescription"] = data["props"]["pageProps"]["seoMetadata"]["description"]

        json_object["prepTime"] = (data["props"]["pageProps"]["cookAndPrepTime"]["preparationMax"] / 60).toString() + " mins"
        json_object["cookTime"] = (data["props"]["pageProps"]["cookAndPrepTime"]["cookingMax"] / 60).toString() + " mins"
        json_object["totalTime"] = (data["props"]["pageProps"]["cookAndPrepTime"]["total"] / 60).toString() + " mins"


        json_object["recipeNutrition"] = data["props"]["pageProps"]["permutiveModel"]["recipe"]["nutrition_info"]
        json_object["recipeIngredient"] = data["props"]["pageProps"]["permutiveModel"]["recipe"]["ingredients"]
        
        let instructions = []
        for(var i in data["props"]["pageProps"]["methodSteps"]) 
            if (data["props"]["pageProps"]["methodSteps"][i]["content"][0]["data"]["value"].includes('<p>')){
                instructions.splice(0)
                break
            }
            instructions.push(data["props"]["pageProps"]["methodSteps"][i]["content"][0]["data"]["value"])
        
        for(var x in data["props"]["pageProps"]["schema"]["recipeInstructions"]){
            instructions.push(data["props"]["pageProps"]["schema"]["recipeInstructions"][x]["text"])
        }
        instructions[0].includes('<p>') ? instructions.shift() : instructions

        json_object["recipeInstructions"] = instructions
        json_object["recipeCuisine"] = data["props"]["pageProps"]["permutiveModel"]["recipe"]["diet_types"]
        json_object["recipeCategory"] = data["props"]["pageProps"]["permutiveModel"]["category"]    

        let recipeYield = data["props"]["pageProps"]["permutiveModel"]["recipe"]["serves"] 
        json_object["recipeYield"] = recipeYield ? recipeYield.toString() : data["props"]["pageProps"]["servings"]

        json_object["authorName"] = data["props"]["pageProps"]["authors"][0]["name"]

        temp_array.push(json_object) 
        
    }

    return temp_array

}

export default async (req, res) => {    
    let sourceLinks = await getSourceLinks()
    let foodDetails = await readDetails(sourceLinks)

    if (foodDetails.length >= 1){
        const result = await foodModel.insertMany(foodDetails, { ordered:true } )

        return res.status(200).send( {'msg': result.insertedCount + " documents were inserted."} )
    }

    return res.status(409).send( {'msg': 'Data is already exist in database!'})

};

