# 📘 Word Card App

This is a Flutter-based mobile application designed to help users learn English vocabulary more efficiently. Users can add new words, associate images, write example sentences, and filter words based on their learning status or type.

## ✨ Features

- ✅ Add English-Turkish word pairs  
- 🧠 Write short stories or example sentences for each word  
- 📷 Attach an image to make words more memorable  
- 📂 Filter by word type (noun, verb, adjective, etc.)  
- 🧩 Show only learned/unlearned words  
- 💾 All data is stored locally using the Isar database  

## 📱 Screenshots

| Home Screen | Add Word |
|-------------|----------|
| ![Words](screenshots/Screenshot_1.png) | ![Add](screenshots/Screenshot_2.png) |

## 🛠️ Technologies Used

- Flutter  
- Dart  
- Isar (local NoSQL database)  
- Provider (state management)  
- SharedPreferences (for local settings)  

## 🚀 Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/word-card-app.git
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  path_provider: ^2.1.1
  image_picker: ^1.0.4
  provider: ^6.1.2
  shared_preferences: ^2.2.2
```

## 📁 Folder Structure

```
lib/
├── main.dart
├── models/
├── screens/
├── widgets/
├── services/
├── database/
```

## 📌 Notes

- Currently optimized for Android only.
- You can mark a word as "learned" using a toggle switch.
- Images are saved locally to the device.

## 🧑‍💻 Developer

- **Ali Yıldırım**  
