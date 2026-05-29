# taskcart
ShopEase E-Commerce App using GETX

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you # ShopEase E-Commerce App

A Clean Architecture Flutter mobile application built using GetX for a machine test submission. The app connects to the open-source DummyJSON API.

## 🚀 Features Implemented

* **Splash Screen**: Shows an animation, checks for a stored token, and routes the user automatically.
* **Login Screen**: Features form validation, text inputs, error handling, and a loading indicator.
* **Home Screen**: Features a horizontal categories list, pull-to-refresh, and a grid view of products showing images, ratings, prices, and discounts.
* **Product Details Screen**: Displays description, pricing, stock alerts, and a multi-image slider layout.
* **Search & Filter**: Real-time product searching and filtering based on user-selected categories.
* **Cart Management**: Users can add, remove, and change item quantities. Total values are calculated automatically and saved to local memory.
* **Profile Screen**: Shows logged-in user data and features a logout switch that clears local session tokens.

---

## 🛠️ Architecture & Tech Stack

This project follows **Clean Architecture** to separate user interfaces from api operations:

* **State Management**: GetX
* **Network Request Tool**: Http
* **Local Caching**: SharedPreferences (via `LocalStorageService`)

### Project Structure
* `lib/core/`: Application constants, networking clients, and global storage setups.
* `lib/data/`: Data models for parsing JSON and repositories handling data operations.
* `lib/presentation/`: GetX controllers managing states and Flutter views defining the UI layouts.

---

## ⚙️ Setup Instructions

1. Install project packages:
   ```bash
   flutter pub getstarted if this is your first Flutter project:
login username :emilys
password: emilyspass

