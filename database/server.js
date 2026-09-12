import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import postApi from "./api/post.js";
import categoryApi from "./api/category.js";
import authApi from "./api/auth.js";

dotenv.config();

console.log(process.env.jwt_secret);

const app = express();

const port = 8000;

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  console.log(req.method, req.url);

  next();
});

app.use("/api/auth", authApi);
app.use("/api/posts", postApi);
app.use("/api/categories", categoryApi);

app.listen(port, "0.0.0.0", () => {
  console.log(`Server berjalan di port ${port}`);
});
