# 🌟 Numora - Ứng dụng Thần Số Học với AI

Khám phá bản thân qua những con số thần bí trong ngày sinh của bạn với sự hỗ trợ từ trí tuệ nhân tạo.

## ✨ Tính năng chính

- 🔢 **Tính toán thần số học**: Số đường đời, linh hồn, sứ mệnh, nhân cách
- 🤖 **Phân tích AI**: Diễn giải chi tiết và cá nhân hóa từ OpenAI GPT
- 📱 **Giao diện hiện đại**: UI/UX đẹp mắt với animations mượt mà
- 🔥 **Firebase tích hợp**: Authentication, Firestore, Cloud Functions
- 📊 **Số cá nhân hàng ngày**: Lời khuyên cho từng ngày
- 📜 **Lịch sử phân tích**: Lưu và xem lại các kết quả
- 🎨 **Dark/Light Theme**: Chuyển đổi giao diện linh hoạt
- 🔔 **Push Notifications**: Thông báo hàng ngày
- 📤 **Chia sẻ kết quả**: Chia sẻ với bạn bè trên mạng xã hội

## 🛠️ Tech Stack

### Frontend (Mobile App)
- **Flutter 3.x** với Dart 3
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Google Fonts** - Typography
- **Flutter Animate** - Animations
- **Shimmer** - Loading effects

### Backend & Services
- **Firebase Authentication** - Đăng nhập Google/Anonymous
- **Cloud Firestore** - Database NoSQL
- **Firebase Cloud Functions** - Server logic
- **Firebase Cloud Messaging** - Push notifications
- **Firebase Analytics** - Thống kê sử dụng

### AI Integration
- **OpenAI GPT-4** - Tạo diễn giải thần số học
- **HTTP/Dio** - API calls

## 🚀 Cài đặt và Chạy

### Yêu cầu
- Flutter SDK 3.16+
- Dart 3.2+
- Android Studio / VS Code
- Firebase CLI
- Node.js (cho Cloud Functions)

### 1. Clone và setup project
\`\`\`bash
git clone <repository-url>
cd numora_app
flutter pub get
\`\`\`

### 2. Cấu hình Firebase

#### Tạo Firebase Project
1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Tạo project mới với tên "Numora App"
3. Bật các services:
   - Authentication (Google, Anonymous)
   - Firestore Database
   - Cloud Functions
   - Cloud Messaging
   - Analytics

#### Cấu hình Android
1. Thêm Android app với package name: \`com.numora.numora_app\`
2. Tải file \`google-services.json\`
3. Thay thế file \`android/app/google-services.json\`

#### Cấu hình iOS (Nếu cần)
1. Thêm iOS app với bundle ID: \`com.numora.numoraApp\`
2. Tải file \`GoogleService-Info.plist\`
3. Thêm vào \`ios/Runner/\`

### 3. Cấu hình OpenAI API
1. Lấy API key từ [OpenAI Platform](https://platform.openai.com/)
2. Thay thế \`YOUR_OPENAI_API_KEY\` trong \`lib/services/ai_service.dart\`

### 4. Build và chạy
\`\`\`bash
# Development
flutter run

# Build APK
flutter build apk --release

# Build iOS (trên macOS)
flutter build ios --release
\`\`\`

## 📁 Cấu trúc Project

\`\`\`
lib/
├── main.dart                 # Entry point & theme config
├── models/                   # Data models
│   └── numerology_result.dart
├── services/                 # Business logic
│   ├── numerology_calculator.dart
│   ├── ai_service.dart
│   └── firebase_service.dart
├── providers/                # Riverpod state management
│   └── app_providers.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── calculation_screen.dart
│   ├── result_screen.dart
│   ├── history_screen.dart
│   └── profile_screen.dart
└── widgets/                  # Reusable components
    ├── gradient_button.dart
    ├── feature_card.dart
    ├── stats_card.dart
    ├── number_card.dart
    └── loading_overlay.dart
\`\`\`

## 🎯 Roadmap

### Version 1.0 (MVP)
- [x] Tính toán số đường đời
- [x] Diễn giải AI cơ bản
- [x] Firebase integration
- [x] UI/UX hiện đại
- [x] Dark/Light theme

### Version 1.1
- [ ] Google Sign In
- [ ] Push notifications hàng ngày
- [ ] Tính toán số cá nhân chi tiết
- [ ] Export PDF
- [ ] Onboarding flow

### Version 1.2
- [ ] Tương thích năm/tháng
- [ ] Lịch thần số học
- [ ] Charts & visualizations
- [ ] Social sharing
- [ ] Multi-language (English)

### Version 2.0
- [ ] Premium features
- [ ] Detailed compatibility analysis
- [ ] Horoscope integration
- [ ] Community features
- [ ] Web version

## 🔧 Môi trường Development

### VS Code Extensions khuyến nghị
- Flutter
- Dart
- Firebase
- GitLens
- Bracket Pair Colorizer

### Debug Tools
- Flutter Inspector
- Firebase Local Emulator Suite
- Dart DevTools

## 📊 Performance & Optimization

- **Bundle size**: < 50MB
- **Cold start**: < 3s
- **Hot reload**: < 1s
- **API response**: < 2s
- **Offline support**: Cached results

## 🔒 Bảo mật

- Firebase Security Rules
- API key encryption
- User data privacy
- GDPR compliance
- No sensitive data stored locally

## 🤝 Đóng góp

1. Fork project
2. Tạo feature branch: \`git checkout -b feature/amazing-feature\`
3. Commit changes: \`git commit -m 'Add amazing feature'\`
4. Push to branch: \`git push origin feature/amazing-feature\`
5. Open Pull Request

## 📝 License

MIT License - xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 👥 Team

- **Developer**: Your Name
- **Designer**: Your Name
- **AI Consultant**: GPT-4

## 📞 Liên hệ

- Email: contact@numora.app
- Website: https://numora.app
- Facebook: @NumoraApp

---

⭐ **Nếu bạn thích project này, hãy cho chúng tôi một star!**
