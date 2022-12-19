const {Food} = require('../../models/food');
const errorJson = require('../../../utils/error');
const axios = require('axios');
const cheerio = require('cheerio');

/** 
 * Scrape food source links from home page end return them in the list.
 * 
 * @param {int} startPage - the start page number
 * @param {int} endPage - the last page number
*/
const scrapePages = async (startPage = 1 , endPage = 2) => {

    var sourceLinks = [];
    var url;

    for (startPage; startPage <= endPage; startPage++) {

        startPage > 1 ? 
            url = `https://www.bbcgoodfood.com/search/recipes/page/${startPage}?q=Quick+and+healthy+recipes&sort=-date`
        :
            url = "https://www.bbcgoodfood.com/search/recipes?q=Quick+and+healthy+recipes&sort=-date"
        

        let html = await axios.get(url);

        let $ = await cheerio.load(html.data);

        

        $('.standard-card-new__article-title').each(( i, elem ) => {
            sourceLinks.push( "https://www.bbcgoodfood.com" + $(elem).attr('href') )
        });
        
    }

    return sourceLinks;

};

/**
 * Scrape food details from source link and append to dict. 
 * 
 * @param {Array} sourceLinks - Contains source links
 */
const scrapeDetails = async (sourceLinks) => {

    var loop_datas = { "datas" : [] }

    for (let index = 0; index < sourceLinks.length; index++) {

        let html = await axios.get( sourceLinks[index] );
        
        let $ = await cheerio.load(html.data);
        
        let img_source = $('.image__img').eq(2).attr('src')

        let food_title = $('.headline.post-header__title > h1').text()


        let author_name = $('.author-link__list').text()
        
        let prep_time = $('.icon-with-text__children').eq(0).find('.list').eq(0).find('li').eq(0).text()

        let cook_time = $('.icon-with-text__children').eq(0).find('.list').eq(0).find('li').eq(1).text()

        let made_level = $('.icon-with-text__children').eq(1).text()

        let servers = $('.icon-with-text__children').eq(2).text()

        let short_info = $('.editor-content').eq(0).text()
        
        let nutrition_1 = $('.key-value-blocks__batch.body-copy-extra-small').eq(0).find('tr');

        let nutrition_2 = $('.key-value-blocks__batch.body-copy-extra-small').eq(1).find('tr');

        let nutritions = []

        for (let i = 0; i < nutrition_1.length; i++) {
            let info_1 = nutrition_1.eq(i).find('td').eq(1).text() + " " + nutrition_1.find('td').eq(2).text();
            let info_2 = nutrition_2.eq(i).find('td').eq(1).text() + " " + nutrition_2.find('td').eq(2).text();

            nutritions.push(info_1)
            nutritions.push(info_2)
        }


        let ingredients_element = $('.recipe__ingredients > section').find('ul > li')

        let ingredients = []

        for (let index = 0; index < ingredients_element.length; index++) {
           ingredients.push( ingredients_element.eq(index).text() )
            
        }

        let to_method = $('.grouped-list__list.list').find('li')
        
        let methods = []

        for (let index = 0; index < to_method.length; index++) {
            methods.push( to_method.eq(index).find('.editor-content').text() )
            
        }

        js_data = {
            "source_link": sourceLinks[index],
            "image_source": img_source,
            "food_title": food_title,
            "made_by": author_name,
            "prep_time" : prep_time,
            "cook_time":cook_time,
            "made_level": made_level,
            "servers":servers,
            "short_info":short_info,
            "nutritions": nutritions,
            "ingredients":ingredients,
            "methods":methods
        }

        const check_title = await Food.find( {'food_title': food_title} );
        if (check_title.length >= 1) {
            return loop_datas["datas"]
        }

        loop_datas['datas'].push( js_data )

        
    
    }

    return loop_datas["datas"];

}

module.exports = async (req, res) => {
    let sourceLinks;
    req.query.startPage ? sourceLinks = await scrapePages(req.query.startPage, req.query.endPage) : sourceLinks = await scrapePages(1,1);

    let foodDetails = await scrapeDetails(sourceLinks);

    if (foodDetails.length >= 1){
        const result = await Food.collection.insertMany(foodDetails, { ordered:true } )

        return res.status(200).send( {'msg': result.insertedCount + " documents were inserted."} )
    }

    return res.status(200).send( {'msg': "Data alraedy exist in db please try again later."} )
    
    

};

