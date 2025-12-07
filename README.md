# Spend Mate: Personal Finance Tracker 📊

![GitHub last commit](https://img.shields.io/github/last-commit/bayazidht/spend_mate)
![GitHub language count](https://img.shields.io/github/languages/count/bayazidht/spend_mate)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

## 🌟 Overview

**Spend Mate** is a mobile personal finance tracker developed as a **Software Engineering coursework project**. Its goal is to provide users with an efficient, modern, and reliable platform for managing daily income and expenses.

## 🖼️ App Screenshots: A Quick Tour

Take a look at the core functionalities and interface of Spend Mate:

| Welcome/Login | Dashboard Overview | Transactions List |
| :---: | :---: | :---: |
| <img width="200" src="https://github.com/user-attachments/assets/b366b800-1301-49a5-8705-97e8f4f80d6b"/> | <img width="200" src="https://github.com/user-attachments/assets/e03458c8-e7e4-4765-9bdf-e72edc5ce300"/> | <img width="200" src="https://github.com/user-attachments/assets/146c6743-ac10-434a-862e-1796b7e7d746"/> |
|User Authentication|Balance & Summary|Listing & Filtering|

| Financial Graphs | Add Transaction | Transaction Details |
| :---: | :---: | :---: |
| <img width="200" src="https://github.com/user-attachments/assets/6ff4ae31-8187-4250-be60-1d41fcc74620"/> | <img width="200" src="https://github.com/user-attachments/assets/02d33345-53ea-4862-856d-a86c8198896d"/> | <img width="200" src="https://github.com/user-attachments/assets/44d8aba2-4d1b-4f26-a304-ee49c1122505"/> |
| Data Visualization |Data Entry Form|Specific Information|

| Edit Transaction | Settings | Manage Categories |
| :---: | :---: | :---: |
| <img width="200" src="https://github.com/user-attachments/assets/d53393b7-a40e-49e3-8602-5a1331e9f5b8"/> | <img width="200" src="https://github.com/user-attachments/assets/54559ed2-3097-4a65-9b5f-109f0146127f"/> | <img width="200" src="https://github.com/user-attachments/assets/e7cd6380-fe83-45fa-9b4b-039682217beb"/> |
| Data Entry Form | App Configuration | Category Management |


## ✨ Key Features

* **Real-time Tracking:** Instantly record and monitor income and expenses.
* **Layered Architecture:** Built using clean, modern architecture principles for maintainability.
* **Cloud Integration:** Real-time data synchronization across devices (using Firebase/Firestore).
* **Offline Caching:** Seamless operation even without an internet connection.
* **Graphical Summary:** Visual representation (Bar Charts, Pie Charts) of monthly and category-wise spending.


## 🛠️ Technology Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Provider
* **Database/Backend:** Firebase Authentication & Firestore
* **Charting:** `fl_chart` package

## 🎓 Project Credits

### Supervised By

Professor **Ibrahim Musa Ishag Musa, PhD.**   [![GitHub Profile](https://img.shields.io/badge/GitHub-Profile-100000?style=flat&logo=github&logoColor=white)](https://github.com/ibrahimishag)  
Full Stack AI/ML R&D Scientist  
IEEE Senior Member  
Assistant Professor, Dongshin University  



### Developed By

**Spend Mate Project Team**  
Dongshin University  
Department of Software Convergence

* Shofiqul Islam (Requirements Analysis)
* Syed Bayazid Hossain (Design & Development)
* Zahid Hasan (Testing & Review)
* Md Refat Islam Abir (Documentation)

## 🚀 Getting Started

Follow these steps to set up and run the Spend Mate application on your machine.

### 📋 Prerequisites

* **Flutter SDK** (Stable Channel)
* **Dart SDK** (Bundled with Flutter)
* **Android Studio** or **VS Code** with Flutter and Dart plugins.
* **Firebase Project:** A configured Firebase project is required for authentication and Firestore database access.

---

### ⚙️ Installation and Setup

1.  **Clone the Repository:**

    Use Git to clone the project to your local machine:

    ```bash
    git clone https://github.com/bayazidht/spend_mate.git
    cd spend_mate
    ```

2.  **Install Dependencies:**

    Fetch all required Dart packages and dependencies:

    ```bash
    flutter pub get
    ```

3.  **Configure Firebase:**

    The app uses Firebase for authentication and database. You must configure your own Firebase project:

    * **Android:** Place your `google-services.json` file inside the `android/app/` directory.
    * **iOS:** Follow the standard Firebase documentation to add your `GoogleService-Info.plist` file.

4.  **Run the Application:**

    Ensure you have an active emulator or a physical device connected, then run the app:

    ```bash
    flutter run
    ```
