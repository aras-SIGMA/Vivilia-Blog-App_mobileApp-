import mysql from "mysql2";

const pool = mysql
  .createPool({
    host: "localhost",
    user: "root",
    password: "LoveSQL1*",
    database: "db_blog_app",
  })
  .promise();

export default pool;
