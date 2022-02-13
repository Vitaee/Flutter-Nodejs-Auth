# Healthy Food App
- There is  a mobile application to show hundreds of various healthy food recipes.
- Showing recipes isn't the only feature of the app. In app you'll do;
  - Follow each other.
  - Save your favourite recipe.
  - Comment or like food recipe.
  - Customize your profile.
  - Share your own recipe on timeline.


# Screenshots of App

### Login and Register Page

<div>
<img src= "https://serving.photos.photobox.com/50106597e91fc73082a8dce55717206cf5e7ddcba929d7d2405aaaafacedb58ddf677b04.jpg" width=340; height=700; >
&nbsp;&nbsp;
<img src= "https://serving.photos.photobox.com/852144434b8957714357c262c2d5bc048e3d93f3125a94b9b71896055850fa46b1719ee9.jpg" width=340; height=700;>

</div>

### Home and Detail Page

<div>
<img src= "https://serving.photos.photobox.com/680512869bea24ebdf73bb2312aca5f4c1620bb4d6fe835824425f4062b46276ae36a386.jpg" width=340; height=700; >
&nbsp;&nbsp;
<img src= "https://serving.photos.photobox.com/76117914ff304ee8c8b3731f7e10a800cc7de106cf1e2fbf3016c139f523b8389f2c9819.jpg" width=340; height=700;>

</div>


### Navigation Drawer Menu

<img src="https://serving.photos.photobox.com/31804752e95a1be0adbc920476b05d66a45190f0144e0e0273c4be984a27ee900160c994.jpg" width=340; height=700;>

# Used Technologies

- Flutter Dart Framework for mobile application.
- Nodejs ( express.js ) for rest api.
- MongoDB as a database.

# Setup MongoDB via Docker
- If you don't have docker you can install it from [here](https://docs.docker.com/get-docker/).
- Firstly, run this command to create and start your db  ```docker run --name some-mongo -p 27017:27017 -d mongo ```.
- Check your container via ```docker ps``` this will return a container ID (the first 12 characters from the hash), the image name (in this case, mongo), command, created, status, ports and the name of the container (some-mongo).
- If you want you can also install [MongoDB Compass](https://www.mongodb.com/products/compass)
- If you using <b>MongoDB Compass</b> you can connect your virtual db with this url. ``` mongodb://0.0.0.0:27017/?readPreference=primary&appname=MongoDB%20Compass&ssl=false ```.
- If you can't connect check your ip adress via this command. ``` docker inspect some-mongo```
- It will return a dict. Then you should find key which name is ```IPAddress``` just copy and paste the value into connection url. In this case replace with ``` 0.0.0.0 ```.


### Contributors
<a href="https://github.com/Vitaee/Flutter-Nodejs-Auth/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Vitaee/Flutter-Nodejs-Auth" />
</a>
