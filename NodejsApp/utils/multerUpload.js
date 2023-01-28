import multer, { diskStorage } from "multer";
import { existsSync, mkdirSync } from "fs";

var dir = "./public/images";
if (!existsSync(dir)) {
  mkdirSync(dir, { recursive: true });
}

const fileStorageEngine = diskStorage({
  destination: (req, file, cb) => {
    cb(null, dir);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const upload = multer({ storage: fileStorageEngine });

export{ upload }