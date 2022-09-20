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
        req = requests.get(self.baseurl, headers=self.user_agent,timeout=10)
        soup = BeautifulSoup(req.content, 'html.parser')

        all_source = soup.find_all('div', class_='slideshow-slide-dek')

        for item in all_source:
            try:
                source_link = item.find('a')['href']
                if 'delish.com' not in source_link:
                    source_link = "https://www.delish.com" + source_link

                source_links.append(source_link)
            except:
                pass

        self.analyse(source_links)

    def analyse(self, hrefs: list) -> None:
        for i in range(0, len(hrefs)):
            req = requests.get(hrefs[i], headers=self.user_agent, timeout=10)
            soup = BeautifulSoup(req.content, 'html.parser')


            new_data = soup.find('script', id='json-ld')
            if new_data:
                json_data = json.loads(new_data.text)
                parsed_json = self.parse_json_data(json_data)
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


                    self.save_to_db(to_js)

    def parse_json_data(self, data) -> dict:
        to_dict = {}
        
        to_dict["sourceUrl"] = data["url"]
        to_dict["image"] = data["image"]["url"]
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
        to_dict["recipeInstructions"] = [ i["text"] for i in data["recipeInstructions"] ]

        to_dict["recipeCuisine"] = data["recipeCuisine"]
        to_dict["recipeCategory"] = data["recipeCategory"]
        
        to_dict["recipeYield"] = data["recipeYield"]

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



#a = ScrapFood(baseurl="https://www.delish.com/cooking/recipe-ideas/g3733/healthy-dinner-recipes/?slide=1")
# https://www.delish.com/cooking/g3594/stuffed-zucchini/?slide=1
# https://www.delish.com/cooking/recipe-ideas/g4203/gluten-free-dinner-ideas/?slide=1
# https://www.delish.com/cooking/g4011/stuffed-pepper-recipes/?slide=1
a = ScrapFood(baseurl="https://www.delish.com/cooking/g4011/stuffed-pepper-recipes/?slide=1")
a.start()
