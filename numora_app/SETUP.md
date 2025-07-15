# 🚀 Hướng dẫn Setup Numora App

## 📋 Yêu cầu hệ thống

### 1. Cài đặt Flutter SDK
```bash
# Windows
# Tải Flutter SDK từ: https://docs.flutter.dev/get-started/install/windows
# Giải nén và thêm vào PATH

# Kiểm tra cài đặt
flutter doctor
```

### 2. Cài đặt Android Studio
- Tải từ: https://developer.android.com/studio
- Cài đặt Android SDK và Android SDK Command-line Tools
- Tạo Android Virtual Device (AVD)

### 3. Cài đặt VS Code Extensions
- Flutter
- Dart
- Firebase

## 🔧 Setup Project

### Bước 1: Cài đặt dependencies
```bash
cd numora_app
flutter pub get
```

### Bước 2: Generate code files
```bash
dart run build_runner build
```

### Bước 3: Setup Firebase

#### 3.1. Tạo Firebase Project
1. Truy cập https://console.firebase.google.com/
2. Click "Create a project"
3. Đặt tên project: "Numora App"
4. Bật Google Analytics (tuỳ chọn)

#### 3.2. Cấu hình Authentication
1. Vào Authentication > Sign-in method
2. Bật Anonymous và Google
3. Thêm domain authorize (localhost cho development)

#### 3.3. Cấu hình Firestore
1. Vào Firestore Database > Create database
2. Chọn "Start in test mode"
3. Chọn location gần nhất

#### 3.4. Cấu hình Android App
1. Vào Project settings > Your apps
2. Click "Add app" > Android
3. Package name: `com.numora.numora_app`
4. Tải file `google-services.json`
5. Thay thế file `android/app/google-services.json`

### Bước 4: Cấu hình OpenAI API
1. Truy cập https://platform.openai.com/
2. Tạo API key
3. Mở file `lib/services/ai_service.dart`
4. Thay `YOUR_OPENAI_API_KEY` bằng API key thực

### Bước 5: Cập nhật Android build config
Mở file `android/app/build.gradle` và thêm:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-bom:32.2.2'
}
```

## ▶️ Chạy ứng dụng

### Development mode
```bash
flutter run
```

### Debug trên device thật
```bash
flutter run --debug
```

### Build APK
```bash
flutter build apk --release
```

## 🐛 Troubleshooting

### Lỗi "Flutter command not found"
```bash
# Windows: Thêm Flutter bin vào PATH
# Ví dụ: C:\flutter\bin

# Kiểm tra
flutter --version
```

### Lỗi "No connected devices"
```bash
# Kiểm tra devices
flutter devices

# Khởi động emulator
flutter emulators --launch <emulator_id>
```

### Lỗi Firebase
```bash
# Xóa cache và pub get lại
flutter clean
flutter pub get
```

### Lỗi build_runner
```bash
# Clean và rebuild generated files
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## 📱 Testing

### Run unit tests
```bash
flutter test
```

### Run integration tests
```bash
flutter drive --target=test_driver/app.dart
```

## 🚀 Deployment

### Android (Play Store)
```bash
# Build App Bundle
flutter build appbundle --release

# File output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (App Store) - cần macOS
```bash
# Build iOS
flutter build ios --release

# Archive trong Xcode và upload
```

## 📊 Performance Tips

1. **Optimize images**: Sử dụng WebP format
2. **Minimize app size**: `flutter build apk --split-per-abi`
3. **Profile performance**: `flutter run --profile`
4. **Analyze bundle**: `flutter build apk --analyze-size`

## 🔐 Security Checklist

- [ ] Thay đổi Firebase project ID
- [ ] Thay đổi OpenAI API key  
- [ ] Cập nhật package name
- [ ] Setup Firebase Security Rules
- [ ] Enable App Check (Production)
- [ ] Setup Crashlytics
- [ ] Code obfuscation: `flutter build apk --obfuscate --split-debug-info=<directory>`

## 📞 Support

Nếu gặp vấn đề, hãy:
1. Check Flutter doctor: `flutter doctor`
2. Check GitHub Issues
3. Liên hệ support: support@numora.app

---

🎉 **Chúc bạn setup thành công!**
