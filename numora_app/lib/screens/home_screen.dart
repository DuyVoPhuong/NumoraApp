import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';
import '../providers/app_providers.dart';
import '../widgets/gradient_button.dart';
import '../widgets/feature_card.dart';
import '../widgets/stats_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(appStatisticsProvider);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, ref),
              const SizedBox(height: 32),
              
              // Hero Section
              _buildHeroSection(context),
              const SizedBox(height: 32),
              
              // Quick Action Button
              _buildQuickActionButton(context),
              const SizedBox(height: 32),
              
              // Stats Section
              _buildStatsSection(statsAsync),
              const SizedBox(height: 32),
              
              // Features Section
              _buildFeaturesSection(context),
              const SizedBox(height: 32),
              
              // Daily Personal Number
              _buildDailyNumber(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào! 👋',
              style: AppTextStyles.body1.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Khám phá bản thân',
              style: AppTextStyles.heading2,
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              icon: Icon(
                ref.watch(themeProvider) 
                    ? Icons.light_mode_rounded 
                    : Icons.dark_mode_rounded,
              ),
            ),
            IconButton(
              onPressed: () => context.push('/profile'),
              icon: const Icon(Icons.person_rounded),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX();
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ Thần Số Học',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Khám phá những bí mật ẩn giấu trong ngày sinh của bạn. AI sẽ phân tích và đưa ra những lời khuyên cá nhân hóa.',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY();
  }

  Widget _buildQuickActionButton(BuildContext context) {
    return GradientButton(
      onPressed: () => context.push('/calculation'),
      gradient: AppColors.accentGradient,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Bắt đầu phân tích',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms).scale();
  }

  Widget _buildStatsSection(AsyncValue<Map<String, dynamic>> statsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cộng đồng Numora',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: 16),
        statsAsync.when(
          data: (stats) => Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Phân tích',
                  value: '${stats['totalResults'] ?? 0}',
                  icon: Icons.psychology_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatsCard(
                  title: 'Người dùng',
                  value: '${stats['totalUsers'] ?? 0}',
                  icon: Icons.people_rounded,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          loading: () => const Row(
            children: [
              Expanded(child: StatsCard.loading()),
              SizedBox(width: 16),
              Expanded(child: StatsCard.loading()),
            ],
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tính năng nổi bật',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            FeatureCard(
              title: 'Số đường đời',
              description: 'Khám phá mục đích cuộc sống',
              icon: Icons.route_rounded,
              color: AppColors.primary,
              onTap: () => context.push('/calculation'),
            ),
            FeatureCard(
              title: 'Phân tích AI',
              description: 'Diễn giải chi tiết từ AI',
              icon: Icons.smart_toy_rounded,
              color: AppColors.secondary,
              onTap: () => context.push('/calculation'),
            ),
            FeatureCard(
              title: 'Lịch sử',
              description: 'Xem lại các phân tích',
              icon: Icons.history_rounded,
              color: AppColors.accent,
              onTap: () => context.push('/history'),
            ),
            FeatureCard(
              title: 'Chia sẻ',
              description: 'Chia sẻ kết quả với bạn bè',
              icon: Icons.share_rounded,
              color: AppColors.success,
              onTap: () => context.push('/calculation'),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms);
  }

  Widget _buildDailyNumber(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.today_rounded,
                color: AppColors.success,
              ),
              const SizedBox(width: 8),
              Text(
                'Số cá nhân hôm nay',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Nhập ngày sinh để xem số cá nhân hôm nay và nhận lời khuyên cho ngày mới!',
            style: AppTextStyles.body2.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/calculation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tính ngay'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms);
  }
}
