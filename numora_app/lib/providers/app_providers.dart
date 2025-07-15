import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/numerology_result.dart';
import '../services/firebase_service.dart';
import '../services/numerology_calculator.dart';
import '../services/ai_service.dart';

// Auth Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Numerology Calculation Provider
final numerologyCalculationProvider = StateNotifierProvider<NumerologyCalculationNotifier, NumerologyCalculationState>((ref) {
  return NumerologyCalculationNotifier();
});

class NumerologyCalculationState {
  final bool isLoading;
  final NumerologyResult? result;
  final String? error;

  const NumerologyCalculationState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  NumerologyCalculationState copyWith({
    bool? isLoading,
    NumerologyResult? result,
    String? error,
  }) {
    return NumerologyCalculationState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}

class NumerologyCalculationNotifier extends StateNotifier<NumerologyCalculationState> {
  NumerologyCalculationNotifier() : super(const NumerologyCalculationState());

  Future<void> calculateNumerology({
    required DateTime birthDate,
    String? fullName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Tính các số thần số học
      final lifePathNumber = NumerologyCalculator.calculateLifePath(birthDate);
      final soulNumber = fullName != null 
          ? NumerologyCalculator.calculateSoulNumber(fullName)
          : 0;
      final destinyNumber = fullName != null
          ? NumerologyCalculator.calculateDestinyNumber(fullName)
          : 0;
      final personalityNumber = fullName != null
          ? NumerologyCalculator.calculatePersonalityNumber(fullName)
          : 0;

      // Tạo diễn giải AI
      final aiInterpretation = await AIService.generateInterpretation(
        lifePathNumber: lifePathNumber,
        soulNumber: soulNumber,
        destinyNumber: destinyNumber,
        personalityNumber: personalityNumber,
        birthDate: birthDate,
      );

      // Tạo kết quả
      final result = NumerologyResult(
        lifePathNumber: lifePathNumber,
        soulNumber: soulNumber,
        destinyNumber: destinyNumber,
        personalityNumber: personalityNumber,
        aiInterpretation: aiInterpretation,
        birthDate: birthDate,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(isLoading: false, result: result);

      // Lưu vào Firebase nếu user đã đăng nhập
      if (FirebaseService.currentUser != null) {
        await FirebaseService.saveNumerologyResult(result);
      }

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Có lỗi xảy ra: ${e.toString()}',
      );
    }
  }

  void clearResult() {
    state = const NumerologyCalculationState();
  }
}

// User Results Provider
final userResultsProvider = StreamProvider.family<List<NumerologyResult>, String>((ref, userId) {
  return FirebaseService.getUserResults(userId);
});

// User Profile Provider
final userProfileProvider = FutureProvider.family<UserProfile?, String>((ref, userId) {
  return FirebaseService.getUserProfile(userId);
});

// Personal Day Provider
final personalDayProvider = Provider.family<int, (DateTime, DateTime)>((ref, dates) {
  final (birthDate, targetDate) = dates;
  return NumerologyCalculator.calculatePersonalDay(birthDate, targetDate);
});

// Today's Personal Day Provider
final todayPersonalDayProvider = Provider.family<int, DateTime>((ref, birthDate) {
  final today = DateTime.now();
  return NumerologyCalculator.calculatePersonalDay(birthDate, today);
});

// App Statistics Provider
final appStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return FirebaseService.getAppStatistics();
});

// Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false = light theme, true = dark theme

  void toggleTheme() {
    state = !state;
  }

  void setTheme(bool isDark) {
    state = isDark;
  }
}
