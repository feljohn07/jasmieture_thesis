# Quiz Data Structure & Storage Analysis

This document provides a comprehensive analysis of how the quiz data is structured, loaded into the game, and stored in the database. It also explains the difference between the global lesson repository and the new player-specific storage system.

## 1. JSON Structure (`questions_eng.json` / `questions_ceb.json`)

The quiz data is structured as a hierarchical JSON array representing a list of **Levels**.

### Hierarchy Breakdown:
- **`Level`**: The root object. Contains metadata for a specific level.
  - `level` (int): The level identifier (e.g., 1, 2).
  - `title` (String): The name of the level (e.g., "Living Things").
  - `lock` (bool): The default locked/unlocked state.
  - `difficulty` (String): "Easy", "Medium", "Hard", etc.
  - `chapters` (List): A list of chapters belonging to this level.
    - **`Chapter`**: A sub-section of a level.
      - `chapter` (int): The chapter identifier.
      - `title` (String): The topic of the chapter.
      - `lock` (bool): The default locked/unlocked state.
      - `questions` (List): The list of questions inside the chapter.
        - **`Question`**: An individual quiz question.
          - `questionNumber` (int): The order of the question.
          - `question` (String): The actual question text.
          - `correctChoice` (String): The `choiceId` that is correct (e.g., "a", "b").
          - `audio` (String): The relative path to the voice-over audio file.
          - `choices` (List): The 4 options available to the user.
            - **`Choice`**: An individual option.
              - `choiceId` (String): "a", "b", "c", or "d".
              - `choice` (String): The text of the choice.
              - `imagePath` (String): An optional image to display alongside the text.
              - `audio` (String): Voice-over audio for the specific choice.

---

## 2. Loading into the Game

The game ingests these JSON files entirely offline using local assets.

1. **Initialization (`main.dart`)**:
   - During startup, `initializeQuestions()` is called.
   - It reads both `assets/questions/questions_eng.json` and `assets/questions/questions_ceb.json` using `rootBundle.loadString`.
2. **Parsing (`LevelParser.dart`)**:
   - The JSON arrays are passed into `LevelParser.fromJson()`.
   - This utility iterates through the raw JSON and maps it tightly to the local Dart models (`Level`, `Chapter`, `Question`, `Choice`).
3. **Database Seeding (`LessonRepositoryImpl`)**:
   - The parsed models are sent to `lessonRepository.saveLevels(language, levels)`.
   - The repository checks the Hive database (`_languageBox`). If the `english` or `cebuano` language data already exists, it aborts. If it is empty, it saves the entire structure to the local Hive database wrapped in a `Language` model.
   - **Result**: The quiz data is seeded into the local database **only once** upon the very first launch of the application.

---

## 3. How Data is Stored and Tracked (Global vs. Per-Player)

With the recent architectural updates, there are two layers of data storage: the **Global Static Data** and the **Per-Player Progress Data**.

### A. Global Static Data (`LessonRepository`)
The `Language`, `Level`, `Chapter`, and `Question` models stored in the `lessonRepository` are treated as **Global Static Data**.
- **Historical Note**: Initially, the `lock` boolean inside the `Level` and `Chapter` JSON structures was used to track progress. When a user beat a level, `lessonRepository.unlockLevel()` was called, modifying the `lock` boolean and saving it to the database.
- **The Problem**: Because this database is global, if Player A unlocked Level 2, it would permanently change the `lock` boolean to `false` for *everyone*, including Player B.

### B. Per-Player Progress Data (`AuthProvider` & `Player` Model)
To support multiple accounts/users, the progress tracking has been decoupled from the static JSON data and moved directly into the `Player` model.

- **`Player` Storage**:
  - `unlockedLevels`: A list of integers (e.g., `[1, 2]`) representing which levels the specific player has access to. Defaults to `[1]`.
  - `unlockedChapters`: A list of strings (e.g., `['1:1', '1:2', '2:1']`) formatted as `level:chapter` representing specific chapters the player has unlocked. Defaults to `['1:1']`.
- **How it Works**:
  - When the UI needs to know if a level is locked (e.g., in `levels.dart`), it **ignores** the global JSON `lock` field. Instead, it queries the `AuthProvider`: `auth.isLevelUnlocked(levelNumber)`.
  - When a user finishes a level, `QuizData.unlockNextChapter` calculates the ID of the next level/chapter, and saves it directly to the active `Player` object via `authProvider.unlockLevel(nextLevelId)`.
  - **Result**: Player A can have `unlockedLevels: [1, 2]` while Player B can log in and have `unlockedLevels: [1]`. Their progress is entirely isolated.

> [!TIP]
> If you need to update the questions in the future, simply update the JSON files and then clear the app data or bump the Hive box version. The app will re-seed the new questions automatically. The player's progress will remain untouched as long as the Level/Chapter IDs remain consistent.
