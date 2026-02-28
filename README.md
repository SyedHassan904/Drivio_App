# Drivio

A secure cloud-based file management app built with Flutter and powered
by a Node.js + Cloudinary backend.\
Users can upload, store, download, and manage files just like a mini
Google Drive.

------------------------------------------------------------------------

## 🚀 Features

-   🔐 User Authentication (Login / Register)
-   ☁️ Upload files to cloud storage
-   📂 Create and manage folders
-   📥 Download saved files
-   🗑 Delete files and folders
-   🔄 Persistent login using stored token
-   📡 REST API integration with Node.js backend

------------------------------------------------------------------------

## 🛠 Tech Stack

### Frontend

-   Flutter
-   Provider (State Management)
-   HTTP package
-   SharedPreferences

### Backend

-   Node.js
-   Express.js
-   Cloudinary (Cloud file storage)
-   JWT Authentication

------------------------------------------------------------------------

## ⚙️ Installation

### 1️⃣ Clone the repository

``` bash
git clone https://github.com/SyedHassan904/Drivio_App.git
cd Drivio_App
```

### 2️⃣ Install dependencies

``` bash
flutter pub get
```

### 3️⃣ Run the app

``` bash
flutter run
```

------------------------------------------------------------------------

## 🔧 Backend Setup

The backend for this project is available in the separate repository:
👉 drivio_backend (Node.js + Express + Cloudinary)
You can clone it from GitHub:

git clone https://github.com/SyedHassan904/Drivio_backend.git
cd Drivio_backend
npm install
npm start

Make sure your backend server is running.
Update your server URI inside your Flutter project:

``` dart
static const String serverUri = "http://localhost:5000";
```

------------------------------------------------------------------------

## 🔐 Environment Variables (Backend)

Create a `.env` file in your backend:

    PORT=5000
    MongoDB_URL=your_url
    JWT_SECRET=your_secret_key
    Cloudinary_Name=your_cloud_name
    Cloudinary_API_Key=your_api_key
    Cloudinary_Secret_Key=your_api_secret

------------------------------------------------------------------------

## 📂 Project Structure

    lib/
     ├── Providers/
     ├── Screens/
     ├── Models/
     ├── Services/
     └── main.dart

------------------------------------------------------------------------

## 🧠 How It Works

1.  User logs in.
2.  Backend verifies credentials.
3.  JWT token is returned and stored locally.
4.  Files are uploaded to Cloudinary.
5.  App fetches and displays user files.

------------------------------------------------------------------------

## 🔒 Security

-   JWT-based authentication
-   Token stored locally
-   Secure API communication
-   Cloudinary-managed storage

------------------------------------------------------------------------

## 📌 Future Improvements

-   File sharing between users
-   File preview (PDF/Image viewer)
-   Drag and drop upload
-   Dark mode
-   Search functionality

------------------------------------------------------------------------

## 👨‍💻 Author

Syed Hassan\
Flutter Developer
