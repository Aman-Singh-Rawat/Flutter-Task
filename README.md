# Flutter Task App

A simple Flutter app that shows posts from an API and lets you mark them as read.

## What this app does

- Shows a list of posts
- Lets you tap on posts to read them
- Remembers which posts you've read
- Works offline (shows cached posts when no internet)
- Has a timer feature for each post

## How the app is built

### Main parts:
- **Screens**: The pages you see (post list, post details)
- **Data**: Gets posts from internet and saves them locally
- **Database**: Stores posts on your phone using SQLite
- **State Management**: Uses Provider to manage data

### Architecture:
```
Screens (UI) → ViewModel (Logic) → Repository (Data) → API/Database
```

## Libraries used

- **flutter_screenutil**: Makes the app look good on different screen sizes
- **provider**: Manages app state and data
- **get**: Handles navigation between screens
- **dio**: Makes API calls to get posts
- **sqflite**: Local database to store posts
- **fluttertoast**: Shows small messages to user
- **connectivity_plus**: Checks if internet is available

## How to run the app

### Step 1: Get Flutter
Make sure you have Flutter installed on your computer.

### Step 2: Get the code
```bash
git clone <your-repo-url>
cd flutter_task
```

### Step 3: Install packages
```bash
flutter pub get
```

### Step 4: Run the app
```bash
flutter run
```

## Building the app

### For Android:
```bash
flutter build apk
```

### For iOS:
```bash
flutter build ios
```

## Project structure

```
lib/
├── main.dart              # App starts here
├── app.dart               # App configuration
├── data/
│   ├── local/            # Database stuff
│   ├── remote/           # API calls
│   └── repositories/     # Data management
├── models/               # Data structures
├── presentation/
│   ├── screens/          # App pages
│   └── widgets/          # Reusable UI pieces
├── viewModel/            # Business logic
├── routes/               # Navigation
└── utils/                # Helper functions
```

## How it works

1. App opens and shows a splash screen
2. Loads posts from API (JSONPlaceholder)
3. Saves posts to local database
4. Shows post list with read/unread status
5. When you tap a post, it opens details and marks as read
6. If no internet, shows cached posts from database

## Database

The app uses SQLite to store:
- Post ID, title, body
- Whether you've read it
- Timer countdown

## Features

- ✅ Offline support
- ✅ Read status tracking  
- ✅ Timer functionality
- ✅ Responsive design
- ✅ Error handling
- ✅ Loading states

## What you need to know

- Uses JSONPlaceholder API for demo data
- Works on Android and iOS
- Needs internet for first load, then works offline
- Simple and clean code structure

## Contact

If you have questions or find bugs, please let me know!