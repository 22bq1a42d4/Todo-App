# <div align="center">🚀 Task Master</div>

<div align="center">

<img src="https://readme-typing-svg.herokuapp.com?font=Poppins&size=28&duration=3000&color=00BFFF&center=true&vCenter=true&width=700&lines=Premium+Flutter+Task+Manager;Multi+User+Secure+ToDo+App;Local+JSON+Database+Architecture;Built+with+Flutter+%26+Dart" />

</div>

---

# 📌 Project Overview

**Task Master** is a **premium multi-user task management application built using Flutter**.

This project demonstrates:

- Secure authentication
- Local JSON database
- Modern Flutter UI
- Multi-user architecture
- Task filtering system

It is designed as a **production-style Flutter application for portfolio demonstration.**

---

# 📦 Release

| Platform | Download |
|--------|--------|
| Android | [Download APK](https://github.com/22bq1a42d4/Todo-App/raw/main/apk/taskmaster.apk) |

---

# 🛠 Tech Stack

<div align="center">

<img src="https://skillicons.dev/icons?i=flutter,dart,git,github,vscode"/>

</div>

| Technology | Usage |
|-----------|------|
Flutter | UI Framework |
Dart | Programming Language |
crypto | Password Hashing |
path_provider | File Storage |
dart:io | Local File System |

---

# ✨ Features

## 🔐 Multi User Authentication

- Signup/Login system
- Passwords hashed with **SHA-256**
- Secure login validation

---

## 💾 Local Database

Instead of simple shared preferences, this app uses a **JSON based local database**.

Example structure:

```json
{
 "users": {
   "abhinav": {
     "passwordHash": "encrypted_hash",
     "tasks": []
   }
 }
}
```

---

## 🎨 Premium UI

- Animated splash screen  
- Smooth page transitions  
- Material 3 design  
- Elevated task cards  

---

## 🚦 Smart Task Status

| Status | Color |
|------|------|
Completed on Time | 🟢 Green |
Completed Late | 🔴 Red |
Pending | 🟡 Yellow |

---

## 🔎 Advanced Filtering

Users can filter tasks by:

- Status
- Priority
- Labels

---

# 📸 Application Screenshots

## 🔐 Login Screen

<img src="screenshots/login.png" width="250">

---

## 📋 Dashboard

<img src="screenshots/dashboard.png" width="250">

---

## 🔍 Task Filters

<img src="screenshots/filter.png" width="250">

---

# 📂 Project Structure

```
flutter-premium-todo-app
│
├── lib
│   ├── main.dart
│   ├── models
│   │    └── task.dart
│   │
│   ├── services
│   │    └── storage_service.dart
│   │
│   ├── screens
│   │    ├── splash_screen.dart
│   │    ├── login_screen.dart
│   │    ├── signup_screen.dart
│   │    └── home_screen.dart
│   │
│   └── widgets
│        ├── task_card.dart
│        └── filter_bottom_sheet.dart
│
├── assets
├── screenshots
└── README.md
```

---

# ⚙️ Installation

### Clone the repository

```
git clone https://github.com/YOUR_USERNAME/flutter-premium-todo-app.git
```

---

### Navigate to project

```
cd flutter-premium-todo-app
```

---

### Install dependencies

```
flutter pub get
```

---

### Run the application

```
flutter run
```

---

# 🔐 Password Hashing Example

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}
```

---

# 📊 GitHub Stats

<div align="center">

<img src="https://github-readme-stats.vercel.app/api?username=YOUR_GITHUB_USERNAME&show_icons=true&theme=tokyonight"/>

<img src="https://github-readme-streak-stats.herokuapp.com/?user=YOUR_GITHUB_USERNAME&theme=tokyonight"/>

</div>

---

# 👨‍💻 Author

**Seelam Abhinav**

Frontend Developer | Flutter Developer | AI Enthusiast

---

# ⭐ Support

If you like this project:

⭐ Star this repository  
🍴 Fork the project  
📢 Share with others  

---

<div align="center">

Built with ❤️ using **Flutter**

</div>