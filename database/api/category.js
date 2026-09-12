import express from "express";
import pool from "../config/database.js";

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query("select * from categories");
    res.status(200).json({
      message: "Berhasil mengambil data kategori",
      data: rows,
    });
  } catch (error) {
    res.status(500).json({
      message: "Gagal mengambil data kategori",
      error: error.message,
    });
  }
});

export default router;
