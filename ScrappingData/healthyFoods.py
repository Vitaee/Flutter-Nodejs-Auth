import requests, time, pymongo
from bs4 import BeautifulSoup


class ScrapFood:
    def __init__(self, baseurl: str) -> None:
        self.baseurl = baseurl
        self.user_agent = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36'}

        self.ingredients = []
        self.directions = []

    def start(self) -> None:
        source_links = []
        req = requests.get(self.baseurl, headers=self.user_agent)
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
            req = requests.get(hrefs[i], headers=self.user_agent)
            soup = BeautifulSoup(req.content, 'html.parser')
            if soup.text in 'Service is currently unavailable. We apologize for the inconvenience. Please try again later.':
                pass
            else:

                shared_by = soup.find('span',class_='byline-name')
                if shared_by:
                    shared_by = shared_by.text

                else:
                    shared_by = "Unknown"

                food_name = soup.find('h1',class_='content-hed recipe-hed')

                servings = soup.find('span', class_='yields-amount').text.replace('\n', ' ').replace('\t', '')
                if 'servings' not in servings:
                    servings = servings + " " + "servings"

                prep_time = soup.find('span', class_='prep-time-amount').text.replace('\n', ' ').replace('\t', '')

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
                    food_photo = food_photo.find('img')['data-src'].split("?")[0]
                else:
                    food_photo = soup.find('div', class_='embed-image-wrap')
                    food_photo = food_photo.find('img')['data-src']
                    food_photo = food_photo.split("?")[0]

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


    def save_to_db(self, to_js):
        client = pymongo.MongoClient("mongodb://localhost:27017")
        db = client['node-flutter']
        our_collection = db.healthyFoods

        result = our_collection.insert_one(to_js)
        print(f"One data: {result.inserted_id}")


        self.ingredients.clear()
        self.directions.clear()



a = ScrapFood(baseurl="https://www.delish.com/cooking/recipe-ideas/g3733/healthy-dinner-recipes/?slide=1")
a.start()
