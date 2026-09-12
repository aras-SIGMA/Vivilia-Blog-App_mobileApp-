import express from "express";
import { z } from "zod";
import pool from "../config/database.js";
import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

const postSchema = z.object({
  category_id: z.number(),
  title: z.string().min(1, "Judul Blog Tidak Boleh Kosong"),
  content: z.string().min(1, "Isi Blog Tidak Boleh Kosong"),
  status: z.enum(["draft", "published"]),
});

const validateData = (schema) => {
  return (req, res, next) => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      return res.status(400).json({
        message: "Data tidak valid atau kosong",
        error: result.error.flatten().fieldErrors,
      });
    }
    req.body = result.data;
    next();
  };
};

router.get("/", async (req, res) => {
  try {
    const { search, category_id, status } = req.query;

    let query =
      "select posts.*, categories.name as category_name, users.name as author from posts join categories on posts.category_id = categories.id join users on posts.user_id = users.id where 1=1 ";

    const params = [];

    if (search) {
      query += " and posts.title like ? ";
      params.push(`%${search}%`);
    }

    if (category_id) {
      query += " and posts.category_id = ? ";
      params.push(category_id);
    }

    if (status) {
      query += " and posts.status = ? ";
      params.push(status);
    }

    query += " order by posts.created_at desc";

    const [rows] = await pool.query(query, params);

    res.status(200).json({
      message: "Berhasil mengambil data artikel",
      data: rows,
    });
  } catch (error) {
    res.status(500).json({
      message: "Gagal mengambil data artikel",
      error: error.message,
    });
  }
});

router.post("/", authMiddleware, validateData(postSchema), async (req, res) => {
  try {
    console.log("USER LOGIN:", req.user);

    const { category_id, title, content, status } = req.body;

    console.log("DATA BODY:", req.body);

    const user_id = req.user.id;

    const [result] = await pool.query(
      "insert into posts(user_id,category_id,title,content,status) values(?,?,?,?,?)",
      [user_id, category_id, title, content, status],
    );

    console.log("INSERT BERHASIL:", result.insertId);

    res.status(201).json({
      message: "Artikel Berhasil Ditambahkan",
    });
  } catch (error) {
    console.log("ERROR POST:", error);

    res.status(500).json({
      message: "Gagal menambahkan artikel",
      error: error.message,
    });
  }
});

router.put(
  "/:id",
  authMiddleware,
  validateData(postSchema),
  async (req, res) => {
    try {
      const { id } = req.params;

      const { category_id, title, content, status } = req.body;

      const user_id = req.user.id;

      const [checkPost] = await pool.query(
        "select id from posts where id=? and user_id=?",
        [id, user_id],
      );

      if (checkPost.length === 0) {
        return res.status(403).json({
          message: "Anda tidak memiliki akses untuk mengubah artikel ini",
        });
      }

      await pool.query(
        `
        update posts
        set category_id=?,
            title=?,
            content=?,
            status=?
        where id=? and user_id=?
        `,

        [category_id, title, content, status, id, user_id],
      );

      res.status(200).json({
        message: "Artikel Berhasil Diperbarui",

        data: {
          id: Number(id),
          category_id,
          title,
          content,
          status,
        },
      });
    } catch (error) {
      res.status(500).json({
        message: "Gagal memperbarui artikel",

        error: error.message,
      });
    }
  },
);

router.delete("/:id", authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;

    const user_id = req.user.id;

    const [result] = await pool.query(
      "delete from posts where id=? and user_id=?",

      [id, user_id],
    );

    if (result.affectedRows === 0) {
      return res.status(403).json({
        message: "Anda tidak memiliki akses menghapus artikel ini",
      });
    }

    res.status(200).json({
      message: "Artikel Berhasil Dihapus",

      data: {
        id: Number(id),
      },
    });
  } catch (error) {
    res.status(500).json({
      message: "Gagal menghapus artikel",

      error: error.message,
    });
  }
});
export default router;
