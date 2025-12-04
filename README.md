# AI Routine

AI Routine is a comprehensive productivity and life management application built with Flutter. It combines task management, habit tracking, journaling, and AI-powered insights to help you stay organized and achieve your goals.

## 🚀 Features

*   **🤖 AI Integration**: Smart insights and assistance for your daily routine.
*   **📅 Calendar & Scheduling**: Manage your events and schedule effectively.
*   **✅ Task Management**: Create, organize, and track your tasks.
*   **🎯 Goal Tracking**: Set and monitor your long-term and short-term goals.
*   **🔄 Habit Tracker**: Build and maintain positive habits.
*   **📝 Diary & Notes**: Record your thoughts, ideas, and daily experiences.
*   **📊 Progress & Summary**: Visualize your productivity and view daily summaries.
*   **🔔 Notifications**: Stay on track with timely reminders.
*   **🔐 Authentication**: Secure user accounts powered by Supabase.
*   **🌗 Dark/Light Theme**: Customizable appearance.

## 🛠️ Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Language**: Dart
*   **State Management**: [Provider](https://pub.dev/packages/provider)
*   **Backend & Auth**: [Supabase](https://supabase.com/)
*   **Local Storage**: [Hive](https://pub.dev/packages/hive)
*   **Notifications**: [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
*   **Charts**: [FL Chart](https://pub.dev/packages/fl_chart)
*   **Animations**: [Flutter Staggered Animations](https://pub.dev/packages/flutter_staggered_animations)

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10.1 or higher)
- Dart SDK

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Bablusinghnirwan/AI-Routine-.git
    cd AI-Routine-
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configuration:**
    *   This project uses Supabase for backend services. You may need to configure your Supabase credentials in the project (typically in a `.env` file or a constants file).
    *   Ensure you have the necessary platform-specific configurations for Android and iOS (e.g., for notifications).

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 📂 Project Structure

```
lib/
├── features/       # Feature-based modules (Auth, Diary, Goals, etc.)
├── core/           # Core utilities, theme, and shared components
├── services/       # Service layer (API, Notifications, etc.)
├── main.dart       # Application entry point
└── ...
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
