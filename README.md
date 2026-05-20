# StudyFlow AI

StudyFlow AI is a modern AI-powered study assistant mobile application built with Flutter and Dart.

The goal is to help students organize study materials, track progress, plan study tasks, and eventually generate AI-powered quizzes directly from uploaded PDFs.

This project is intended to become a real production-ready mobile app that can eventually be published on the App Store and Google Play.

## Product Vision

StudyFlow AI should feel:

- Minimal
- Modern
- Student-friendly
- Productivity-focused
- Calm and clean
- Easy to use
- Professional and startup-quality

The UI should avoid clutter and excessive animation while still feeling polished, responsive, and visually attractive.

## Developer Context

The project is being built by a Flutter mobile application developer focused on modern, production-quality apps with clean UI/UX and scalable architecture.

Current strengths:

- Strong Flutter and Dart foundation
- Comfortable building responsive modern UIs
- Familiar with Clean Architecture, MVVM, and state management concepts
- Experience with Firebase integration
- Good understanding of app structure and reusable components

Current learning focus:

- Backend development
- AI integration
- Python API development
- Connecting AI features to real mobile product flows

## Tech Stack

- Flutter
- Dart
- Provider
- Shared Preferences
- Flutter ScreenUtil
- Google Fonts
- Flutter SVG
- Flutter Staggered Grid View
- Percent Indicator
- Local storage first
- Firebase planned for future versions
- AI integration planned for future versions
- Python/backend APIs may be added later for PDF processing and quiz generation

## Current Repository Snapshot

The current codebase contains:

- Splash screen
- Onboarding flow
- Main app layout with animated tab switching and bottom navigation
- Home dashboard
- Tasks screen UI
- Subject Details screen
- Profile placeholder
- Light/dark theme infrastructure
- Shared widgets for buttons, app bars, PDF rows, note cards, view-all rows, and floating action buttons
- Subject model, subject sample data, and custom painted subject icons
- Generated asset references in `Assets`
- Image and SVG assets for onboarding, icons, analytics, completion cards, PDFs, notes, tasks, and progress

Main directories:

- `lib/main.dart`: app entry point, Provider setup, ScreenUtil setup, MaterialApp, routes, and theme registration
- `lib/config/theme`: light and dark `ThemeData` definitions
- `lib/Core`: shared routes, resources, models, helpers, providers, generated assets, and reusable widgets
- `lib/features/Splash`: splash screen and delayed navigation into onboarding
- `lib/features/Onboarding`: onboarding PageView, dots indicator, and CTA button flow
- `lib/features/main`: main app shell with Home, Tasks, and Profile tabs
- `lib/features/main/Home`: Home dashboard widgets
- `lib/features/main/Tasks`: task planner UI widgets
- `lib/features/Subject_Detalis`: Subject Details screen and widgets
- `assets/Images`: bitmap image assets
- `assets/Svgs`: SVG icons
- `test/widget_test.dart`: default Flutter test that still needs updating

## Current Implementation Progress

### App Entry, Theme, and Routing

- `main.dart` wraps the app in `ChangeNotifierProvider<ThemeProvider>`.
- `ScreenUtilInit` is configured with a `443 x 881` design size.
- `ThemeManager.light` and `ThemeManager.dark` define app-wide Material 3 themes.
- `ThemeProvider` stores dark mode preference using Shared Preferences.
- Routes currently include splash, onboarding, main layout, home, and subject details.
- Current app theme mode is hardcoded to `ThemeMode.dark` in `main.dart`; the provider exists but is not yet connected to `MaterialApp.themeMode`.

### Splash and Onboarding

- Splash screen shows the StudyFlow logo and tagline.
- Splash uses a delay helper and safely checks `mounted` before navigating.
- Onboarding uses a `PageView`, `DotsIndicator`, and reusable `CustomElevatedButton`.
- Onboarding screens introduce:
  - Study organization
  - Progress tracking
  - AI-powered quiz generation

### Main Layout

- Main layout uses a `Stack`.
- Tabs are switched with `AnimatedSwitcher`, `SlideTransition`, and `FadeTransition`.
- Bottom navigation is custom-built with SVG icons.
- Bottom nav adapts its background color based on the current theme brightness.

### Home Dashboard

Current Home progress:

- Greeting section
- Study readiness subtitle
- Daily streak and task stats through `InformationList` and `InformationItem`
- Reusable `ViewAllRow`
- Subject bento/staggered grid through `MySubjectsSection`
- Subject cards rendered from `SubjectModel` sample data
- Subject card tap navigation into `SubjectDetailsScreen`
- Recent activity now uses the reusable `pdfitem` widget
- Floating action button is attached to the Home screen
- Home scrolling was improved by replacing a nested shrink-wrapped grid with an equivalent `SliverGrid`
- Bottom scroll padding is added so the custom bottom nav does not block the final content

### Subject Details

The Subject Details feature has been started and currently includes:

- Custom app bar using `customAppBar`
- Subject title and icon
- Subject metadata text
- Course completion card
- Animated progress bar
- Quick action section:
  - Add PDF
  - Add Note
  - Progress
- Study Materials section using `pdfitem`
- Recent Notes section using `NoteItem`
- Analytics card
- Day streak and total study time cards
- Bottom scroll padding for the bottom navigation area

### Tasks / Study Planner

The Tasks screen has an initial UI implementation:

- Title and subtitle
- Floating action button
- Daily task progress container
- Circular percent indicator
- Today section
- Tomorrow section
- Completed section
- Task cards with checkbox state
- Completed task cards with strikethrough styling
- Static placeholder task data for now

### Profile and Theme Toggle

- Profile screen is currently a placeholder.
- A reusable `ThemeToggle` widget exists inside the Profile file.
- Theme toggle supports compact icon mode and labeled mode.
- Toggle updates `ThemeProvider`, but the app currently does not use the provider's `themeMode` in `MaterialApp`.

### Shared Core Widgets

Reusable widgets currently include:

- `CustomElevatedButton`
- `CustomFloatingactoinbutton`
- `customAppBar`
- `ViewAllRow`
- `pdfitem`
- `NoteItem`
- `InformationItem`
- `ActionButton`
- `ActionSection`

## Recent Development Progress

### README Documentation

Progress completed:

- Replaced the default Flutter README with a real project README.
- Added the product vision, developer context, tech stack, planned features, UI direction, and current focus.
- Added this full repository snapshot.
- Added a professional AI handoff prompt for future AI tools.

### Home Dashboard Scroll Fix

The Home screen had a scrolling issue caused by nesting a shrink-wrapped `GridView` inside a `CustomScrollView`.

Progress completed:

- Preserved the Home UI and visual structure.
- Replaced the nested `GridView.custom` in `MySubjectsSection` with an equivalent `SliverGrid`.
- Kept the same quilted/staggered subject layout, spacing, pattern, padding, and card UI.
- Added bottom scroll padding in `Home_Screen_body.dart` so the custom bottom navigation does not block the final content.
- Added smoother scroll behavior.
- Removed a few no-UI-impact warnings in `subject_item.dart`, including unused imports and a deprecated opacity call.

### New Subject Details Work

Progress completed:

- Added `SubjectDetailsScreen`.
- Added `SubjectScreenBody`.
- Added course completion, analytics, action buttons, PDF rows, and note cards.
- Added assets for analytics, course completion, add PDF, add note, progress, biology, notes, and success feedback.
- Added route support for subject details.
- Connected Home subject cards to the subject details route.

### Tasks UI Work

Progress completed:

- Added `TaskScreenBody`.
- Added progress, task, and completed task containers.
- Added task-related SVG assets.
- Added static UI for today, tomorrow, and completed task sections.

### Theme Work

Progress completed:

- Added `ThemeManager` with light and dark themes.
- Added `ThemeProvider` using Shared Preferences.
- Updated several widgets to read from `Theme.of(context)` and `colorScheme`.
- Added theme-aware Home, Subject Details, Tasks, and shared widgets.

## Planned Product Features

### 1. Home Dashboard

- Subject folders/cards
- Uploaded PDFs inside each subject
- Progress tracking per subject
- Modern staggered/bento grid layout
- Recent activity section
- Study streaks and stats
- Dark and light mode support

### 2. PDF Organization

- Upload and organize PDFs by subject
- Store PDFs locally at first
- Navigate easily between saved study materials
- Open PDFs directly from subject folders or attached tasks

### 3. Tasks / Study Planner

- Todo and study task management
- Attach PDFs to tasks
- Open attached PDFs directly from task details
- Priorities and deadlines
- Minimal productivity-focused UI

### 4. AI Quiz Generator

The main long-term feature is an AI-powered quiz system.

Planned flow:

- User uploads a PDF or selects one from saved files.
- User chooses quiz settings:
  - Number of questions
  - Difficulty level
  - Progressive difficulty option
  - Timed or untimed quiz
- The system generates MCQ questions from the PDF content.
- User solves the quiz.
- Results page shows:
  - Score
  - Correct answers
  - Wrong answers
  - Weak points
  - Motivational feedback
  - Related PDF references

## UI/UX Direction

The design is inspired by:

- Notion
- Todoist
- Duolingo
- Modern productivity apps
- Minimal AI startup apps

Design principles:

- Rounded modern cards
- Soft shadows
- Clean typography
- Spacious layouts
- Calm gradients
- Minimal animations
- Modern bottom navigation
- Reusable components
- Elegant dark mode
- Responsive layouts
- Smooth scrolling and interactions

## Current Focus

The current development focus is:

- Translating generated UI ideas into real Flutter widgets
- Building reusable design system components
- Creating scalable project architecture
- Improving UX quality
- Making the app feel production-ready
- Keeping UI responsive and smooth on mobile devices
- Preparing the codebase for real data, storage, and AI features

## Professional AI Handoff Prompt

Copy and paste this prompt into another AI tool when asking for help with the project:

```text
You are helping me build StudyFlow AI, a modern Flutter/Dart mobile application for students.

Project identity:
StudyFlow AI is an AI-powered study assistant. The app helps students organize PDFs by subject, track study progress, manage study tasks, and eventually generate AI-powered quizzes from uploaded PDFs. The long-term goal is a polished, production-ready mobile app suitable for App Store and Google Play release.

Developer context:
I am a Flutter mobile application developer. I have a strong Flutter and Dart foundation, can build responsive modern UIs, understand Clean Architecture, MVVM, state management concepts, reusable components, and Firebase integration. I am still learning backend development, AI integration, and Python API development. I want guidance that teaches me while also helping me build a real product.

Desired product feeling:
The app should feel minimal, modern, calm, clean, student-friendly, productivity-focused, easy to use, and startup-quality. Avoid clutter and excessive animations. Use polished UI, clean typography, soft shadows, rounded modern cards, responsive layouts, smooth scrolling, dark/light mode support, and reusable components.

Current tech stack:
- Flutter
- Dart
- Provider
- Shared Preferences
- Flutter ScreenUtil
- Google Fonts
- Flutter SVG
- Flutter Staggered Grid View
- Percent Indicator
- Local storage planned first
- Firebase may be added later
- AI integration and Python/backend APIs are planned for future versions

Current codebase structure:
- `lib/main.dart` sets up Provider, ScreenUtil, MaterialApp, themes, and routes.
- `lib/config/theme/Theme_Manager.dart` contains light and dark ThemeData.
- `lib/Core/Provider/Theme_provider.dart` contains ThemeProvider with Shared Preferences persistence.
- `lib/Core/Routes_Manager` contains routes and route generation.
- `lib/Core/resources` contains colors and navigation icon constants.
- `lib/Core/Utils/app_assets.dart` contains generated asset paths.
- `lib/Core/Widgets` contains shared UI widgets like app bar, buttons, PDF item, note item, view-all row, and floating action button.
- `lib/Core/Models/Subject_Model.dart` and `lib/Core/const/subject_list.dart` contain subject sample data.
- `lib/features/Splash` contains splash screen.
- `lib/features/Onboarding` contains onboarding screens and PageView flow.
- `lib/features/main/main_layout.dart` contains the custom bottom navigation and animated tab switching.
- `lib/features/main/Home` contains the Home dashboard.
- `lib/features/main/Tasks` contains the task planner UI.
- `lib/features/main/Profile` contains a placeholder profile screen and ThemeToggle widgets.
- `lib/features/Subject_Detalis` contains the Subject Details screen.

Current implemented screens:
1. Splash screen
2. Onboarding screens
3. Main layout with bottom navigation
4. Home dashboard
5. Tasks screen UI
6. Subject Details screen
7. Profile placeholder

Current Home dashboard:
- Greeting text
- Daily streak and task stats
- Subject bento/staggered grid
- Subject cards with progress bars and custom painted subject icons
- Subject cards navigate to Subject Details
- Recent activity uses a reusable PDF row widget
- Floating action button
- Scroll issue was fixed by replacing nested shrink-wrapped GridView with SliverGrid and adding bottom scroll padding

Current Subject Details screen:
- Custom app bar
- Biology subject header
- Course completion card with progress animation
- Action buttons for Add PDF, Add Note, and Progress
- Study Materials section using PDF rows
- Recent Notes section using note cards
- Analytics card
- Day streak and total study time stat cards

Current Tasks screen:
- Header and subtitle
- Daily task progress card
- Circular percent indicator
- Today, Tomorrow, and Completed sections
- Static task cards with local checkbox state
- Completed cards with strikethrough styling

Main future features:
1. PDF organization by subject
2. Local PDF storage
3. Task planner with PDF attachments, priorities, and deadlines
4. AI quiz generation from PDFs
5. Quiz solving screen
6. Results screen with score, correct/wrong answers, weak points, motivational feedback, and PDF references
7. Dark/light mode polishing
8. Firebase/backend/AI integration later

Important constraints:
- Keep UI modern, minimal, calm, and polished.
- Prefer small, focused code changes.
- Preserve existing visual style unless asked to redesign.
- Use existing local patterns and widgets before creating new abstractions.
- Keep widgets reusable and scalable.
- Avoid excessive animation.
- Avoid cluttered layouts.
- Keep scrolling smooth and avoid nested scrollables that can cause jank.
- Be careful with current user edits and do not revert unrelated changes.

Known technical cleanup:
- `main.dart` currently hardcodes `themeMode: ThemeMode.dark`; connect it to `ThemeProvider.themeMode`.
- `test/widget_test.dart` still references the old default `MyApp` class and needs updating.
- Several file/class names have typos or nonstandard casing, such as `Subject_Detalis`, `Continar`, `custom_floatingactoinbutton`, `pdfitem`, and `Constanstmanager`.
- Some strings/comments show encoding artifacts such as `â€¢`.
- Replace deprecated `withOpacity` usages with `withValues` over time.
- Remove unused imports as features stabilize.
- Convert static placeholder UI data into real models and state.
- Decide on state management/data architecture before adding persistence and AI features.

When helping me:
- First understand the current files and product direction.
- Explain changes clearly.
- Prefer production-quality Flutter patterns.
- Help me improve architecture, UI/UX, and scalability.
- Teach me backend and AI integration step by step when those features begin.
```

## Known Cleanup Items

- Connect `ThemeProvider.themeMode` to `MaterialApp.themeMode`.
- Update `test/widget_test.dart`, which still references the default Flutter `MyApp` class.
- Consider renaming files to lower snake case later to satisfy Flutter analyzer style suggestions.
- Fix naming typos such as `Subject_Detalis`, `Continar`, `CustomFloatingactoinbutton`, `pdfitem`, and `Constanstmanager`.
- Clean encoding artifacts in visible strings/comments.
- Continue replacing placeholder screens and placeholder data with real models.
- Decide on state management and persistence approach before adding real data flows.
- Build PDF upload/storage before implementing AI quiz generation.
- Plan backend/API boundaries before adding Python AI processing.

## Project Goal

The goal is not only to build a practice project. The goal is to create a real, polished study assistant with high-quality user experience and meaningful AI-powered study tools.
