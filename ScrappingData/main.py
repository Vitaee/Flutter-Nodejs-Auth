from healthyFoods import ScrapFood
import time

base_links = [
"https://www.delish.com/cooking/recipe-ideas/g4203/gluten-free-dinner-ideas/?slide=2"
"https://www.delish.com/cooking/g3594/stuffed-zucchini/?slide=2",
"https://www.delish.com/cooking/recipe-ideas/g2992/weeknight-seafood-dinners/?slide=2",
"https://www.delish.com/cooking/g1703/ground-beef-dishes/?slide=2",
"https://www.delish.com/cooking/recipe-ideas/g3733/healthy-dinner-recipes/?slide=2",
"https://www.delish.com/cooking/g2933/satisfying-chicken-recipes/?slide=2",
"https://www.delish.com/cooking/g2144/ground-turkey-recipes/?slide=2",
"https://www.delish.com/cooking/g4011/stuffed-pepper-recipes/?slide=2"
]

for item in base_links:
    a = ScrapFood(baseurl=item)
    a.start()
    time.sleep(5)