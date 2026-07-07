# StudyFlow AI

**Your journey to mastery starts here.**

StudyFlow AI is a Flutter-based study assistant designed to help students organize academic materials, plan their work, stay consistent with timed study sessions, and understand their habits through visual analytics. The app is built as a local-first product — everything runs on device without requiring an account or internet connection for core features.

---

## Table of Contents

- [About the App](#about-the-app)
- [Key Features](#key-features)
- [How the App Works](#how-the-app-works)
- [Data & Persistence](#data--persistence)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Design Principles](#design-principles)
- [Roadmap](#roadmap)

---

## About the App

Modern students juggle PDFs, notes, deadlines, and study schedules across many subjects. StudyFlow AI brings those pieces into one calm, focused workspace.

Each **subject** is a folder for PDFs and notes. The **task planner** handles daily and upcoming work. **Study sessions** provide a dedicated timer with goals and motivational feedback. When a session ends, the app records it automatically — feeding into the **study calendar**, **streak tracking**, and **My Progress** analytics dashboard.

The long-term vision includes AI-powered quiz generation from uploaded PDFs. The current release delivers a complete, production-quality study workflow with real local persistence and polished UI.

---

## Key Features

### Splash & Onboarding
- Branded splash screen with animated logo and tagline
- Two-page onboarding introducing organization and progress tracking
- Profile setup screen: name, age, and grade level saved to SharedPreferences
- Returning users skip onboarding and land directly on the main app

### Home Dashboard
- Personalized greeting using stored user profile
- **Daily streak** and **tasks done** stats (live data from study records and TasksCubit)
- Bento-style staggered grid of subject cards with custom painted icons and progress bars
- Recent PDF activity section
- Floating action button to add new subjects via a modern bottom sheet
- Tap any subject card to open its detail screen

### Subject Details
The core workspace for each course:

- **Study Materials** — Upload PDFs via file picker (25 MB limit per file). Files are copied to app storage and can be opened in the device's native PDF viewer.
- **Notes** — Add notes through a validated bottom sheet. Notes display as expandable cards (2-line preview with smooth expand/collapse animation).
- **Course Completion** — Animated progress bar reflecting completed PDFs and notes.
- **Progress Mode** — Toggle checkboxes beside each PDF and note to mark items complete; progress recalculates and persists instantly.
- **Study Session** — Full-screen timer with goal presets (30m–3h), pause/resume, animated progress rings, motivational quotes, and finish dialog. Sessions save to the study calendar on completion.
- **Analytics** — Per-subject day streak, total study time, and weekly progress comparison (this week vs last week), all derived from real session data.

### Tasks / Study Planner
- Three sections: **Today**, **Tomorrow**, and **Completed**
- Circular daily progress indicator showing completion percentage
- Swipe-to-delete on task cards
- Add Task screen with subject picker, task details, optional PDF reference material, schedule (today / tomorrow / custom date), and time picker
- All task state managed through `TasksCubit` and persisted in Hive

### Study Calendar
Accessible from Profile:

- Monthly **heatmap calendar** color-coded by study intensity
- Stats grid: current streak, longest streak, study days, and completion rate
- Tap any day to view session details (subject, duration, notes)
- Pull-to-refresh to reload records

### My Progress
A full analytics dashboard accessible from Profile:

- **Time summaries** — Today, weekly, and monthly study hours
- **Stats grid** — Longest streak, total sessions, average session length, PDFs read
- **Weekly Focus** — Bar chart of study hours per day (Mon–Sun)
- **Time by Subject** — Donut chart with legend showing time distribution across subjects
- **Monthly Trend** — Line chart with area fill showing study hours across four weeks of the current month
- Pull-to-refresh support

### Profile & Settings
- Profile header card with user avatar
- **Appearance** — Light / dark theme toggle persisted via SharedPreferences
- Quick links to Study Calendar and My Progress
- About section with app version and legal placeholders

### Theme System
- Full Material 3 light and dark themes via `ThemeManager`
- `ThemeProvider` with ChangeNotifier; theme choice survives app restarts
- Theme-aware widgets throughout (cards, nav bar, charts, inputs)

---

## How the App Works

### User Flow

```
Splash
  └─ First launch? → Onboarding → Setup (profile) → Main App
  └─ Returning?    → Main App

Main App (bottom navigation)
  ├─ Home      → Subjects, streak, recent PDFs
  ├─ Tasks     → Planner with today / tomorrow / completed
  └─ Profile   → Theme, Study Calendar, My Progress

From Home or Subject Details:
  ├─ Subject Details  → PDFs, notes, progress tracker, analytics
  ├─ Study Session    → Timer → saves StudyRecord on finish
  ├─ Add Task         → New task with schedule and attachments
  └─ All Subjects     → Full subject list
```

### The Study Loop

1. **Organize** — Create subjects and upload PDFs or write notes inside each one.
2. **Plan** — Add tasks with subjects, schedules, and optional PDF references.
3. **Study** — Start a timed session from any subject. The timer persists if you navigate away and returns when you come back.
4. **Track** — Finished sessions write a `StudyRecordModel` to Hive. Streaks, the calendar heatmap, subject analytics, and My Progress charts all read from these records.

### Progress Calculation

- **Subject progress** — `(completed PDFs + completed notes) / total items`, updated via `SubjectsCubit` when checkboxes are toggled in Progress Mode.
- **Daily streak** — Consecutive calendar days with at least one study record (global on Home; per-subject on Subject Details).
- **Weekly progress** — Percentage change in study time for a subject comparing the current calendar week to the previous one.

---

## Data & Persistence

### Hive Boxes

| Box | Contents | Key |
|-----|----------|-----|
| `subjects_box` | Subjects with nested PDFs and notes | Subject name |
| `tasks_box` | Task items with schedule and completion state | Task ID |
| `study_calendar_box` | Study session records | Record ID |

Models use manual `toJson` / `fromJson` serialization. PDF files themselves are stored on the filesystem at `{appDocuments}/pdfs/`; only the file path is saved in Hive.

### SharedPreferences

| Key | Purpose |
|-----|---------|
| `onboarding_complete` | Skip onboarding on relaunch |
| `user_name`, `user_age`, `user_grade` | Profile from setup screen |
| `isDarkMode` | Theme preference |

### Core Models

| Model | Description |
|-------|-------------|
| `SubjectModel` | Name, colors, icon, progress, lists of PDFs and notes |
| `PdfModel` | Title, file path, completion flag, metadata |
| `NoteModel` | Title, content, creation date, completion flag |
| `TaskModel` | Title, subject, schedule category, time, optional PDF, completion |
| `StudyRecordModel` | Date, subject, duration, PDF/note counts, session notes |

---

## Architecture

The project follows a **feature-first** layout with **Clean Architecture** patterns applied to core domains (subjects and tasks).

```
┌─────────────────────────────────────────────┐
│              Presentation Layer             │
│   Screens · Widgets · Cubits · Providers    │
├─────────────────────────────────────────────┤
│               Domain Layer                  │
│   Repository interfaces · Domain models     │
├─────────────────────────────────────────────┤
│                Data Layer                   │
│   Repository implementations · Hive access  │
└─────────────────────────────────────────────┘
```

### State Management

| Concern | Approach |
|---------|----------|
| Subjects & tasks | `SubjectsCubit`, `TasksCubit` (flutter_bloc) |
| Theme | `ThemeProvider` (provider) |
| Study timer | `StudyTimerService` singleton (ChangeNotifier) |
| Progress analytics | `ProgressAnalyticsService` (computed from Hive records) |
| Local UI state | `StatefulWidget` (e.g. progress mode toggle, note expand) |

### Dependency Flow

```
UI → Cubit → Repository (abstract) → RepositoryImpl → HiveService / Hive.box
Study Session finish → StudyCalendarRepository.saveRecord()
Analytics screens   → ProgressAnalyticsService.calculate()
```

Study Calendar and My Progress read repositories/services directly from widgets rather than through Cubits — a pragmatic choice for read-heavy analytics screens.

---

## Tech Stack

| Category | Package / Tool |
|----------|----------------|
| Framework | Flutter, Dart (SDK ^3.10.8) |
| State management | flutter_bloc, provider |
| Local database | hive, hive_flutter |
| Preferences | shared_preferences |
| Charts | fl_chart |
| File handling | file_picker, path_provider, open_filex |
| Responsive UI | flutter_screenutil |
| Typography | google_fonts (Inter) |
| Icons & assets | flutter_svg, Lottie |
| Layout | flutter_staggered_grid_view, percent_indicator |
| Onboarding | dots_indicator |
| Linting | flutter_lints |

---

## Project Structure

```
lib/
├── main.dart                         # App entry, Hive init, BlocProvider setup
├── config/theme/
│   └── Theme_Manager.dart            # Light & dark Material 3 themes
├── Core/
│   ├── Models/                       # Shared data models
│   ├── Services/                     # HiveService, StudyTimerService, UserPrefsService
│   ├── Provider/                     # ThemeProvider
│   ├── Routes_Manager/               # Named routes and route generator
│   ├── Widgets/                      # Reusable UI (app bar, buttons, PDF item, sheets)
│   ├── resources/                    # Colors, constants
│   └── Utils/                        # Generated asset references
└── features/
    ├── Splash/                       # Splash screen
    ├── Onboarding/                   # Onboarding PageView
    ├── setup/                        # Profile setup (name, age, grade)
    ├── main/
    │   ├── main_layout.dart          # Bottom nav shell
    │   ├── Home/                     # Dashboard, subjects Cubit, all subjects
    │   ├── Tasks/                    # Task planner, tasks Cubit
    │   └── Profile/                  # Settings, theme toggle
    ├── subject_details/              # Subject screen, study session, notes, analytics
    ├── add_task/                     # Add task form
    ├── Study_calendar/               # Heatmap, streak stats, day details
    └── My_Progress/                  # Analytics dashboard and charts
```

---

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.8
- Dart SDK (included with Flutter)
- Android Studio / Xcode / VS Code with Flutter extensions

### Run the App

```bash
git clone <your-repo-url>
cd study_flow
flutter pub get
flutter run
```

Hive boxes are opened automatically in `main.dart` before the app starts. No additional setup or API keys are required.

### Supported Platforms

Android · iOS · Windows · Linux (standard Flutter multi-platform scaffold)

---

## Design Principles

StudyFlow AI is designed to feel **minimal, calm, and student-friendly** — inspired by productivity apps like Notion and Todoist without visual clutter.

- Rounded cards with soft borders and subtle shadows
- Inter typography via Google Fonts
- Responsive sizing with ScreenUtil (design size 443 × 881)
- Smooth tab transitions and animated study session rings
- Lottie animations for empty states (no subjects, no tasks)
- Light and dark mode with consistent color system (`Colors_Manager`)
- Bottom sheets for add-subject and add-note flows
- Pull-to-refresh on analytics and calendar screens

---

## Roadmap

| Feature | Status |
|---------|--------|
| Subject & PDF organization | ✅ Done |
| Notes with expand/collapse | ✅ Done |
| Task planner with attachments | ✅ Done |
| Timed study sessions | ✅ Done |
| Study calendar & streaks | ✅ Done |
| My Progress analytics dashboard | ✅ Done |
| Per-subject live analytics | ✅ Done |
| Light / dark theme | ✅ Done |
| AI quiz generation from PDFs | 🔜 Planned |
| Firebase sync & cloud backup | 🔜 Planned |
| Backend API for PDF processing | 🔜 Planned |

---

## License

This project is built for portfolio and educational purposes. Add a `LICENSE` file if you plan to open-source or distribute it.

---

<p align="center">
  Built with Flutter · Study smarter, not harder.
</p>
