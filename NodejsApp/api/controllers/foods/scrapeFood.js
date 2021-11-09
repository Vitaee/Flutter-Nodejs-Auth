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

    for (let index = 0; index < sourceLinks.length; index++) {

        let html = await axios.get( sourceLinks[index] );
        
        let $ = await cheerio.load(html.data);
        
        let img_source = $('.image__img').eq(2).attr('src')

        let food_title = $('.headline.post-header__title > h1').text()
        
        let author_name = "By " + $('.author-link > a').text()

        console.log(author_name)


        break;
    }

    return res.status(200).send( {"msg":"ok"} )
};

