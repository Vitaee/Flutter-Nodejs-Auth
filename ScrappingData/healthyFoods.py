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
        
        total_data_count = len(soup.find('div', class_='slide-container').find_all('div', class_='slideshow-slide'))
        loaded_source = soup.find_all('div', class_='slideshow-slide-dek')
        all_resources = []
        if len(loaded_source) != total_data_count:
            req = requests.get(self.baseurl.replace(self.baseurl[-1], str(total_data_count - 4)), headers=self.user_agent, timeout=5 )
            soup = BeautifulSoup(req.content, 'html.parser')
            start_from = len(loaded_source) + 1
            remaining_source = soup.find_all('div', class_='slideshow-slide-dek')[start_from:]
            
            all_resources = loaded_source + remaining_source    
        
        print(len(all_resources), "<--- current length of all source list")
        for item in all_resources:
            try:
                source_link = item.find_all('a')[-1]['href']
                if source_link[5:13] == '://patty' or source_link[5:13] == '://spicy':
                    pass
                else:
                    if 'delish.com' not in source_link:
                        if 'https://' not in source_link: 
                            source_link = "https://www.delish.com" + source_link
                    source_links.append(source_link)
            except:
                pass
        
        print(source_links, "\n\n\n")
        self.analyse(source_links)

    def analyse(self, hrefs: list) -> None:
        temp_data_list = []
        for i in range(0, len(hrefs)):
            print("\n\n", hrefs[i], "\n\n")

            
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
                    #self.save_to_db(parsed_json)
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
                    #self.save_to_db(to_js)
            time.sleep(6)
            
        self.save_to_file(temp_data_list)

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

        return to_dict

    def save_to_db(self, to_js):
        # 172.17.0.4
        client = pymongo.MongoClient("mongodb://localhost:27017")
        db = client['node-flutter']
        our_collection = db.healthyFoods

        result = our_collection.insert_one(to_js)
        print(f"Data inserted : {result.inserted_id}")

        if self.ingredients or self.directions:
            self.ingredients.clear()
            self.directions.clear()

    def save_to_file(self, js_data):
        with open('sample_data.json', 'w+', encoding='UTF-8') as f:
            json.dump(js_data, f)

        if self.ingredients or self.directions:
            self.ingredients.clear()
            self.directions.clear()
        
        exit()