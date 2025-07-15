import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/numerology_result.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static const String _usersCollection = 'users';
  static const String _resultsCollection = 'numerology_results';

  /// Lấy user hiện tại
  static User? get currentUser => _auth.currentUser;

  /// Đăng nhập ẩn danh
  static Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// Đăng nhập với Google
  static Future<UserCredential?> signInWithGoogle() async {
    // Implement Google Sign In
    // Cần thêm google_sign_in package
    throw UnimplementedError('Google Sign In chưa được implement');
  }

  /// Đăng xuất
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Lưu kết quả thần số học
  static Future<String> saveNumerologyResult(NumerologyResult result) async {
    try {
      final docRef = await _firestore
          .collection(_resultsCollection)
          .add(result.toJson());
      
      // Cập nhật danh sách kết quả đã lưu của user
      if (currentUser != null) {
        await _updateUserSavedResults(currentUser!.uid, docRef.id);
      }
      
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi lưu kết quả: $e');
    }
  }

  /// Lấy lịch sử kết quả của user
  static Stream<List<NumerologyResult>> getUserResults(String userId) {
    return _firestore
        .collection(_resultsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NumerologyResult.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  /// Cập nhật profile user
  static Future<void> updateUserProfile(UserProfile profile) async {
    if (currentUser == null) return;
    
    await _firestore
        .collection(_usersCollection)
        .doc(currentUser!.uid)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  /// Lấy profile user
  static Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy profile: $e');
      return null;
    }
  }

  /// Tạo user profile mới
  static Future<void> createUserProfile({
    required String userId,
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    final profile = UserProfile(
      id: userId,
      name: name,
      email: email,
      photoUrl: photoUrl,
      savedResults: [],
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .set(profile.toJson());
  }

  /// Cập nhật danh sách kết quả đã lưu của user
  static Future<void> _updateUserSavedResults(String userId, String resultId) async {
    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .update({
      'savedResults': FieldValue.arrayUnion([resultId]),
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  /// Xóa kết quả
  static Future<void> deleteResult(String resultId) async {
    await _firestore
        .collection(_resultsCollection)
        .doc(resultId)
        .delete();
  }

  /// Lấy thống kê sử dụng ứng dụng
  static Future<Map<String, dynamic>> getAppStatistics() async {
    try {
      // Đếm tổng số kết quả
      final resultsSnapshot = await _firestore
          .collection(_resultsCollection)
          .count()
          .get();

      // Đếm số user
      final usersSnapshot = await _firestore
          .collection(_usersCollection)
          .count()
          .get();

      return {
        'totalResults': resultsSnapshot.count,
        'totalUsers': usersSnapshot.count,
      };
    } catch (e) {
      return {
        'totalResults': 0,
        'totalUsers': 0,
      };
    }
  }

  /// Cập nhật thời gian hoạt động cuối của user
  static Future<void> updateLastActive() async {
    if (currentUser == null) return;
    
    await _firestore
        .collection(_usersCollection)
        .doc(currentUser!.uid)
        .update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}
