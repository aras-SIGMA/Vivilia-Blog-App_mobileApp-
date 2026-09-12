import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import pool from "../config/database.js";

const router = express.Router();

router.post("/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const [checkUser] = await pool.query("select * from users where email=?", [
      email,
    ]);

    if (checkUser.length > 0) {
      return res.status(400).json({
        message: "Email already registered",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 6);

    await pool.query("insert into users(name,email,password) values(?,?,?)", [
      name,
      email,
      hashedPassword,
    ]);

    res.status(201).json({
      message: "Register success",
    });
  } catch (error) {
    res.status(500).json({
      message: "Register failed",
      error: error.message,
    });
  }
});

router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const [rows] = await pool.query("select * from users where email=?", [
      email,
    ]);

    if (rows.length === 0) {
      return res.status(404).json({
        message: "User not found",
      });
    }

    const user = rows[0];

    const matchPassword = await bcrypt.compare(password, user.password);

    if (!matchPassword) {
      return res.status(401).json({
        message: "Wrong password",
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
      },
      process.env.jwt_secret,
      {
        expiresIn: "7d",
      },
    );

    console.log("USER:", user);
    console.log("TOKEN:", token);

    res.status(200).json({
      message: "Login success",
      token: token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    res.status(500).json({
      message: "Login failed",
      error: error.message,
    });
  }
});

export default router;
