const {Food} = require('../../models/food');
const errorJson = require('../../../utils/error');
const axios = require('axios');
const cheerio = require('cheerio');


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

module.exports = async (req, res) => {

    let sourceLinks = await scrapePages(1,1);

    var loop_datas = { "datas" : [] }

    for (let index = 0; index < sourceLinks.length; index++) {

        let html = await axios.get( sourceLinks[index] );
        
        let $ = await cheerio.load(html.data);
        
        let img_source = $('.image__img').eq(2).attr('src')

        let food_title = $('.headline.post-header__title > h1').text()
        
        let author_name = "By " + $('.author-link > a').text()

        let prep_time = $('.icon-with-text__children').eq(0).find('.list').eq(0).find('li').eq(0).text()

        let cook_time = $('.icon-with-text__children').eq(0).find('.list').eq(0).find('li').eq(1).text()

        let made_level = $('.icon-with-text__children').eq(1).text()

        let servers = $('.icon-with-text__children').eq(2).text()

        let short_info = $('.editor-content').eq(0).text()
        
        let nutrition_1 = $('.key-value-blocks__batch.body-copy-extra-small').eq(0).find('tr');

        let nutrition_2 = $('.key-value-blocks__batch.body-copy-extra-small').eq(1).find('tr');

        let nutritions = {}

        for (let i = 0; i < nutrition_1.length; i++) {
            nutritions[nutrition_1.eq(i).find('td').eq(1).text()] = nutrition_1.find('td').eq(2).text();
            
        }

        for (let j = 0; j < nutrition_2.length; j++) {
            nutritions[nutrition_2.eq(j).find('td').eq(1).text()] = nutrition_2.find('td').eq(2).text();
            
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
            "nutritions":[ nutritions ], // dart kısmında modellenmesi lazım.
            "ingredients":ingredients,
            "methods":methods
        }

        loop_datas['datas'].push( js_data )

        break;
        
    }





    return res.status(200).send( {"data": loop_datas['datas']} )
};

