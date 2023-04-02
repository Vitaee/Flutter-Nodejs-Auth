from healthyFoods import ScrapFood
import time

base_links = [
"https://www.delish.com/cooking/g3594/stuffed-zucchini/?slide=1",
"https://www.delish.com/cooking/recipe-ideas/g2992/weeknight-seafood-dinners/?slide=35",
"https://www.delish.com/cooking/recipe-ideas/g4203/gluten-free-dinner-ideas/?slide=1",
"https://www.delish.com/cooking/g1703/ground-beef-dishes/?slide=1",
"https://www.delish.com/cooking/recipe-ideas/g3733/healthy-dinner-recipes/?slide=1",
"https://www.delish.com/cooking/g2933/satisfying-chicken-recipes/?slide=2",
"https://www.delish.com/cooking/g2144/ground-turkey-recipes/?slide=2",
"https://www.delish.com/cooking/g4011/stuffed-pepper-recipes/?slide=2"
]
b=0
for item in base_links:
    a = ScrapFood(baseurl=item)
    a.start()
    time.sleep(5)
    b+=1
    if b == 2:
        break