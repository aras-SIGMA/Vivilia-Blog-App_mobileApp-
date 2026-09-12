# ✨ Vivilia Blog App

Aplikasi blog modern sederhana yang dibangun menggunakan **Flutter** sebagai frontend dan **Node.js Express** sebagai backend.  
Project ini menerapkan autentikasi user, pengelolaan artikel, kategori, serta sistem ownership agar setiap pengguna hanya dapat mengelola artikel miliknya sendiri.

---

## 📌 Overview

Vivilia Blog App merupakan aplikasi CRUD artikel dengan konsep user-based access.

User dapat:
- Membuat akun
- Login menggunakan JWT Authentication
- Membaca artikel
- Mencari artikel
- Membuat artikel baru
- Mengedit artikel miliknya
- Menghapus artikel miliknya
- Mengatur tema aplikasi

Artikel yang dibuat memiliki hubungan dengan user pemiliknya melalui sistem ownership.

---

## 🚀 Teknologi yang Digunakan

### Frontend
- Flutter
- Dart
- Provider State Management
- Shared Preferences
- HTTP REST API

### Backend
- Node.js
- Express.js
- JWT Authentication
- Zod Validation
- bcrypt Password Hashing

### Database
- MySQL

---

## 🏗️ Struktur Aplikasi

```
vivilia_blog_app

├── frontend
│   └── Flutter Application
│       ├── screens
│       ├── models
│       ├── providers
│       ├── services
│       └── theme
│
└── database
    └── Backend API
        ├── api
        ├── middleware
        ├── config
        └── server.js
```

---

## 🔄 Alur Aplikasi

1. User melakukan register.
2. Password user disimpan dalam bentuk hash.
3. User melakukan login.
4. Backend memberikan JWT token.
5. Flutter menyimpan token menggunakan Shared Preferences.
6. Token digunakan untuk akses fitur yang membutuhkan autentikasi.
7. Saat membuat artikel, user_id otomatis diambil dari token.
8. Sistem melakukan pengecekan ownership sebelum edit atau delete.

---

## 🔐 Sistem Ownership Artikel

Setiap artikel memiliki pemilik:

```
users
 |
 | 1
 |
 | banyak
posts
```

User hanya dapat:

✅ Melihat seluruh artikel  
✅ Membuat artikel baru  
✅ Mengedit artikel miliknya  
✅ Menghapus artikel miliknya  

User tidak dapat:

❌ Mengubah artikel user lain  
❌ Menghapus artikel user lain  

---

## 📱 Fitur Aplikasi

- Authentication
  - Register
  - Login
  - Logout

- Article Management
  - Create article
  - Read article
  - Update article
  - Delete article

- Additional Features
  - Search artikel
  - Category artikel
  - Dark/light theme
  - Expand content
  - User profile

---

## ⚙️ Instalasi

### Backend

Masuk folder:

```
database
```

Install dependency:

```
npm install
```

Jalankan server:

```
npm run dev
```

---

### Flutter

Masuk folder:

```
frontend
```

Install dependency:

```
flutter pub get
```

Jalankan aplikasi:

```
flutter run
```

---

## 📝 Catatan

File `.env` berisi konfigurasi rahasia seperti database credential dan JWT secret.

Jangan memasukkan file tersebut ke repository publik.

---

## 👨‍💻 Development Notes

Project ini dibuat dengan struktur yang dipisahkan agar mudah dikembangkan:

- UI dipisahkan dari logic
- API communication berada di service
- State management menggunakan Provider
- Backend menggunakan REST API
- Database menggunakan relational model
