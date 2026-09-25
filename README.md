# 🧠 Quizzical — Flutter Quiz Application

A modern, responsive quiz application built with Flutter and Dart, featuring category-based trivia, configurable quiz settings, timed gameplay, real-time score tracking, and a dedicated results experience.

---

## 📱 Screenshots

<p align="center">
  <img src="WhatsApp Image 2026-09-25 at 8.10.06 PM.jpeg" width="210" alt="Welcome Screen"/>
  <img src="WhatsApp Image 2026-09-25 at 8.10.06 PM (1).jpeg" width="210" alt="Category Screen"/>
  <img src="WhatsApp Image 2026-09-25 at 8.10.06 PM (2).jpeg" width="210" alt="Config Screen"/>
  <img src="WhatsApp Image 2026-09-25 at 8.10.06 PM (3).jpeg" width="210" alt="Results Screen"/>
</p>
<p align="center">
  <sub><b>Welcome Screen</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Category Selection</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Quiz Configuration</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Quiz Results</b></sub>
</p>

---

## ✨ Features

- 🎯 **Category Selection:** 6 curated quiz categories to choose from.
- ⚙️ **Customizable Gameplay:** Configurable question count, difficulty level, and question types.
- ⏱️ **Timer Challenge:** Dynamic per-question countdown timer for engaging gameplay.
- 🔀 **Smart Randomization:** Shuffled questions and options for a unique experience every time.
- 📊 **Real-time Tracking:** Live score and progress indicators.
- 🏆 **Detailed Results:** Performance statistics, accuracy breakdown, and feedback icons.
- 🔄 **Seamless Replay:** Replay current settings or start fresh instantly.
- 💾 **Persistent Settings:** Saves user choices locally using `SharedPreferences`.
- 🌐 **Dynamic Trivia Data:** Powered by the Open Trivia Database (OpenTDB) REST API.
- 📱 **Responsive UI:** Clean, modern interface designed for all screen sizes.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Core programming language |
| **Provider** | State management architecture |
| **REST API** | Dynamic trivia fetching |
| **OpenTDB** | Open Trivia Database source |
| **SharedPreferences** | Local persistent storage |
| **Flutter SVG** | Scalable vector illustrations |

---

## 🏗️ Project Architecture

```text
lib/
├── controllers/
│   └── quiz_controller.dart
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
│
├── models/
│   ├── quiz_category.dart
│   └── quiz_question.dart
│
├── services/
│   ├── trivia_service.dart
│   └── preferences_service.dart
│
├── screens/
│   ├── welcome_screen.dart
│   ├── category_screen.dart
│   ├── config_screen.dart
│   ├── quiz_screen.dart
│   └── results_screen.dart
│
├── widgets/
│   ├── phone_page.dart
│   ├── simple_top_bar.dart
│   └── error_retry.dart
│
└── main.dart