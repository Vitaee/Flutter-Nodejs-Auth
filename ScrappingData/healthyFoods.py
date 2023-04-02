import requests, time, pymongo, json
from bs4 import BeautifulSoup


class ScrapFood:
    def __init__(self, baseurl: str) -> None:
        self.baseurl = baseurl
        self.user_agent ={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36'}


        self.ingredients = []
        self.directions = []

    def start(self) -> None:
        source_links = []
        req = requests.get(self.baseurl, headers=self.user_agent,timeout=5)
        soup = BeautifulSoup(req.content, 'html.parser')
        
        json_data = json.loads(soup.find('script', id='__NEXT_DATA__').text)
        for item in json_data["props"]["pageProps"]["slides"]:
            try:
                source_links.append(item["metadata"]["dekDom"]["children"][-1]["children"][-1]["children"][0]["attribs"]["href"])
            except:
                try:
                    source_links.append(item["metadata"]["dekDom"]["children"][-1]["children"][1]["children"][1]["attribs"]["href"])
                except:
                    try:
                        source_links.append(item["metadata"]["dekDom"]["children"][-1]["children"][1]["children"][0]["attribs"]["href"])
                    except:
                        pass
        self.analyse(source_links)

    def analyse(self, hrefs: list) -> None:
        temp_data_list = []
        for i in range(0, len(hrefs)):            
            req = requests.get(hrefs[i], headers=self.user_agent, timeout=10)
            soup = BeautifulSoup(req.content, 'html.parser')

            new_data = soup.find('script', id='json-ld')
            if new_data:
                json_data = json.loads(new_data.text)
                parsed_json = None
                try:
                    parsed_json = self.parse_json_data(json_data)
                except:
                    parsed_json = self.parse_other_json_data(json_data)
                
                if parsed_json:
                    temp_data_list.append(parsed_json) 
                    self.save_to_db(parsed_json)
            else:
                if soup.text in 'Service is currently unavailable. We apologize for the inconvenience. Please try again later.':
                    pass
                else:

                    shared_by = soup.find('span',class_='byline-name')
                    if shared_by:
                        shared_by = shared_by.text

                    else:
                        shared_by = "Unknown"

                    food_name = soup.find('h1',class_='content-hed recipe-hed')

                    servings = soup.find('span', class_='yields-amount')
                    if servings:
                        servings = servings.text.replace('\n', ' ').replace('\t', '')
                        if 'servings' not in servings:
                            servings = servings + " " + "servings"

                    

                    prep_time = soup.find('span', class_='prep-time-amount')
                    if prep_time:
                        prep_time = prep_time.text.replace('\n', ' ').replace('\t', '')
                        prep_time = prep_time.replace('   ', '')

                    
                    to_ingredients = soup.find_all('div', class_='ingredient-item')

                    for item in to_ingredients:
                        a = item.find_all('span')
                        try:
                            self.ingredients.append(
                                a[0].text.replace('\n', '').replace('\t', '') + a[1].text.replace('\n', '').replace('\t',
                                                                                                                    ''))
                        except:
                            self.ingredients.append(a[0].text.replace('\n', '').replace('\t', ''))

                    to_directions = soup.find('div', class_='direction-lists')
                    for item in to_directions.find_all('li'):
                        self.directions.append(item.text)

                    food_photo = soup.find('div', class_='content-lede-image-wrap')

                    if food_photo:
                        try:
                            food_photo = food_photo.find('img')['data-src'].split("?")[0]
                        except:
                            if food_photo:
                                food_photo = food_photo.find('picture').find('source')['srcset']
                    else:
                        food_photo = soup.find('div', class_='embed-image-wrap')
                        if food_photo:
                            food_photo = food_photo.find('img')['data-src']
                            if isinstance(food_photo, str) and food_photo[0] != "h":
                                food_photo = BeautifulSoup(food_photo, 'html.parser')
                                food_photo = food_photo.find('picture').find('source')['srcset']
                        
                    to_js = {
                        'shared_by':shared_by,
                        'food_name':food_name.text,
                        'source_link':hrefs[i],
                        'servings': servings,
                        'prep_time': prep_time,
                        'ingredients': self.ingredients,
                        'directions': self.directions,
                        'image': food_photo
                    }
                    

                    temp_data_list.append(to_js)
                    self.save_to_db(to_js)
            time.sleep(6)
            
            
        #self.save_to_file(temp_data_list)

    def parse_json_data(self, data) -> dict:
        to_dict = {}
        to_dict["sourceUrl"] = data["url"]
        to_dict["image"] = data["image"][0]["url"]
        to_dict["videoUrl"] = "" 
        to_dict["videoDuration"] = ""

        try:
            to_dict["videoDuration"] = data["video"]["duration"]
            to_dict["videoUrl"] = data["video"]["contentUrl"]
        except:
            pass
        
        to_dict["foodName"] = data["name"]
        to_dict["foodDescription"] = data["description"]

        to_dict["prepTime"] = data["prepTime"]
        to_dict["cookTime"] = data["cookTime"]
        to_dict["totalTime"] = data["totalTime"]

        to_dict["recipeIngredient"] = data["recipeIngredient"]
        
        try:
            to_dict["recipeInstructions"] = [ i["text"] for i in data["recipeInstructions"] ]
        except:
            try:
                to_dict["recipeInstructions"] = [ i["text"] for i in data["recipeInstructions"]['itemListElement'] ]
            except:
                to_dict["recipeInstructions"] = [ i["text"] for i in data["recipeInstructions"][0]['itemListElement'] ]
        to_dict["recipeCuisine"] = data["recipeCuisine"]
        to_dict["recipeCategory"] = data["recipeCategory"]
        
        to_dict["recipeYield"] = data["recipeYield"]
        try:
            to_dict["authorName"] = data["author"]["name"]
        except:
            to_dict["authorName"] = ""

        return to_dict
    
    def parse_other_json_data(self, data) -> dict:
        to_dict = {}

        try:
            to_dict["sourceUrl"] = data[0]["mainEntityOfPage"]["@id"]
        except KeyError:
            to_dict["sourceUrl"] = data["mainEntityOfPage"]["@id"]

        to_dict["image"] = data[0]["image"][0]["url"]
        to_dict["videoUrl"] = "" 
        to_dict["videoDuration"] = ""

        try:
            to_dict["videoDuration"] = data[0]["video"]["duration"]
            to_dict["videoUrl"] = data[0]["video"]["contentUrl"]
        except:
            pass
        
        to_dict["foodName"] = data[0]["name"]
        to_dict["foodDescription"] = data[0]["description"]

        to_dict["prepTime"] = data[0]["prepTime"]
        to_dict["cookTime"] = data[0]["cookTime"]
        to_dict["totalTime"] = data[0]["totalTime"]

        to_dict["recipeIngredient"] = data[0]["recipeIngredient"]
        to_dict["recipeInstructions"] = [ i["text"] for i in data[0]["recipeInstructions"] ]

        to_dict["recipeCuisine"] = data[0]["recipeCuisine"]
        to_dict["recipeCategory"] = data[0]["recipeCategory"]
        
        to_dict["recipeYield"] = data[0]["recipeYield"]
        try:
            to_dict["authorName"] = data[0]["author"]["name"]
        except:
            to_dict["authorName"] = ""

        return to_dict

    def save_to_db(self, to_js):
        # 172.17.0.3
        client = pymongo.MongoClient("mongodb://172.17.0.3:27017")
        db = client['healthyfood_development']
        our_collection = db.healthyfoods

        result = our_collection.insert_one(to_js)
        print(f"Data inserted : {result.inserted_id}")

        if self.ingredients or self.directions:
            self.ingredients.clear()
            self.directions.clear()

    def save_to_file(self, js_data):
        with open('sample_other_data.json', 'w+', encoding='UTF-8') as f:
            json.dump(js_data, f)

        if self.ingredients or self.directions:
            self.ingredients.clear()
            self.directions.clear()
        self.save_to_db()
        exit()