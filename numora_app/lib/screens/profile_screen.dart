import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../providers/app_providers.dart';
import '../services/firebase_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
      ),
      body: currentUser == null
          ? _buildNotSignedIn(context, ref)
          : _buildProfile(context, ref, currentUser),
    );
  }

  Widget _buildNotSignedIn(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa đăng nhập',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 8),
          Text(
            'Đăng nhập để lưu và đồng bộ dữ liệu của bạn',
            style: AppTextStyles.body2.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _signInAnonymously(ref),
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Đăng nhập ẩn danh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _signInWithGoogle(ref),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Đăng nhập với Google'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, WidgetRef ref, user) {
    final profileAsync = ref.watch(userProfileProvider(user.uid));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? user.email ?? 'Người dùng ẩn danh',
                    style: AppTextStyles.heading3,
                  ),
                  if (user.email != null)
                    Text(
                      user.email!,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildUserStats(profileAsync),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Settings Section
          _buildSettingsSection(context, ref),
          
          const SizedBox(height: 20),
          
          // Sign Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _signOut(ref, context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Đăng xuất'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats(AsyncValue profileAsync) {
    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              'Phân tích',
              '${profile.savedResults.length}',
              Icons.psychology_rounded,
            ),
            _buildStatItem(
              'Tham gia',
              '${DateTime.now().difference(profile.createdAt).inDays} ngày',
              Icons.calendar_today_rounded,
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              isDarkTheme ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.primary,
            ),
            title: const Text('Giao diện tối'),
            trailing: Switch(
              value: isDarkTheme,
              onChanged: (value) => ref.read(themeProvider.notifier).toggleTheme(),
              activeColor: AppColors.primary,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.history_rounded,
              color: AppColors.primary,
            ),
            title: const Text('Lịch sử phân tích'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.push('/history'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.share_rounded,
              color: AppColors.primary,
            ),
            title: const Text('Chia sẻ ứng dụng'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => _shareApp(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.info_rounded,
              color: AppColors.primary,
            ),
            title: const Text('Về ứng dụng'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _signInAnonymously(WidgetRef ref) async {
    try {
      await FirebaseService.signInAnonymously();
      // Create user profile
      final user = FirebaseService.currentUser;
      if (user != null) {
        await FirebaseService.createUserProfile(userId: user.uid);
      }
    } catch (e) {
      // Handle error
      print('Error signing in anonymously: $e');
    }
  }

  void _signInWithGoogle(WidgetRef ref) async {
    try {
      // This would implement Google Sign In
      // await FirebaseService.signInWithGoogle();
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập Google sẽ được triển khai sau'),
        ),
      );
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  void _signOut(WidgetRef ref, BuildContext context) async {
    try {
      await FirebaseService.signOut();
      context.go('/');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _shareApp() {
    // Implement share app functionality
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Numora',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.primary,
        size: 32,
      ),
      children: [
        Text(
          'Ứng dụng thần số học với AI - Khám phá bản thân qua ngày sinh',
          style: AppTextStyles.body2,
        ),
        const SizedBox(height: 16),
        Text(
          'Được phát triển với Flutter & Firebase',
          style: AppTextStyles.body2.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
