import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../providers/app_providers.dart';
import '../services/numerology_calculator.dart';
import '../widgets/number_card.dart';
import '../widgets/gradient_button.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculationState = ref.watch(numerologyCalculationProvider);
    
    if (calculationState.result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kết quả phân tích'),
        ),
        body: const Center(
          child: Text('Không có kết quả để hiển thị'),
        ),
      );
    }

    final result = calculationState.result!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả phân tích'),
        actions: [
          IconButton(
            onPressed: () => _shareResult(result),
            icon: const Icon(Icons.share_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(result),
            const SizedBox(height: 24),
            
            // Numbers Grid
            _buildNumbersGrid(result),
            const SizedBox(height: 32),
            
            // AI Interpretation
            _buildAIInterpretation(result),
            const SizedBox(height: 32),
            
            // Personal Day
            _buildPersonalDay(result),
            const SizedBox(height: 32),
            
            // Action Buttons
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ Phân tích hoàn tất',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ngày sinh: ${DateFormat('dd/MM/yyyy').format(result.birthDate)}',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Text(
            'Phân tích lúc: ${DateFormat('HH:mm dd/MM/yyyy').format(result.createdAt)}',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY();
  }

  Widget _buildNumbersGrid(result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Các con số của bạn',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            NumberCard(
              title: 'Số đường đời',
              number: result.lifePathNumber,
              meaning: NumerologyCalculator.getNumberMeaning(result.lifePathNumber),
              color: AppColors.primary,
            ),
            if (result.soulNumber > 0)
              NumberCard(
                title: 'Số linh hồn',
                number: result.soulNumber,
                meaning: NumerologyCalculator.getNumberMeaning(result.soulNumber),
                color: AppColors.secondary,
              ),
            if (result.destinyNumber > 0)
              NumberCard(
                title: 'Số sứ mệnh',
                number: result.destinyNumber,
                meaning: NumerologyCalculator.getNumberMeaning(result.destinyNumber),
                color: AppColors.accent,
              ),
            if (result.personalityNumber > 0)
              NumberCard(
                title: 'Số nhân cách',
                number: result.personalityNumber,
                meaning: NumerologyCalculator.getNumberMeaning(result.personalityNumber),
                color: AppColors.success,
              ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms);
  }

  Widget _buildAIInterpretation(result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.smart_toy_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Phân tích từ AI',
              style: AppTextStyles.heading3,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: Text(
            result.aiInterpretation,
            style: AppTextStyles.body1.copyWith(
              height: 1.6,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms);
  }

  Widget _buildPersonalDay(result) {
    final today = DateTime.now();
    final personalDay = NumerologyCalculator.calculatePersonalDay(
      result.birthDate,
      today,
    );
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$personalDay',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NumerologyCalculator.getNumberMeaning(personalDay),
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Hôm nay là ngày để ${_getPersonalDayAdvice(personalDay)}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GradientButton(
          onPressed: () => _shareResult(ref.watch(numerologyCalculationProvider).result!),
          gradient: AppColors.accentGradient,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.share_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Chia sẻ kết quả',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(numerologyCalculationProvider.notifier).clearResult();
                  context.push('/calculation');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'Phân tích khác',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Về trang chủ',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms);
  }

  String _getPersonalDayAdvice(int personalDay) {
    switch (personalDay) {
      case 1:
        return 'bắt đầu những dự án mới và thể hiện khả năng lãnh đạo';
      case 2:
        return 'hợp tác, lắng nghe và tạo ra sự hòa hợp';
      case 3:
        return 'sáng tạo, giao tiếp và chia sẻ niềm vui';
      case 4:
        return 'làm việc chăm chỉ và xây dựng nền tảng vững chắc';
      case 5:
        return 'khám phá điều mới mẻ và thoát khỏi thói quen';
      case 6:
        return 'chăm sóc gia đình và thể hiện tình yêu thương';
      case 7:
        return 'suy ngẫm, học hỏi và tìm kiếm sự tĩnh lặng';
      case 8:
        return 'tập trung vào công việc và đạt được thành công';
      case 9:
        return 'giúp đỡ người khác và hoàn thiện bản thân';
      default:
        return 'theo đuổi những mục tiêu đặc biệt của riêng bạn';
    }
  }

  void _shareResult(result) {
    final shareText = '''
🌟 Kết quả phân tích thần số học của tôi:

📅 Ngày sinh: ${DateFormat('dd/MM/yyyy').format(result.birthDate)}

🔢 Các con số:
• Số đường đời: ${result.lifePathNumber} - ${NumerologyCalculator.getNumberMeaning(result.lifePathNumber)}
${result.soulNumber > 0 ? '• Số linh hồn: ${result.soulNumber} - ${NumerologyCalculator.getNumberMeaning(result.soulNumber)}\n' : ''}${result.destinyNumber > 0 ? '• Số sứ mệnh: ${result.destinyNumber} - ${NumerologyCalculator.getNumberMeaning(result.destinyNumber)}\n' : ''}${result.personalityNumber > 0 ? '• Số nhân cách: ${result.personalityNumber} - ${NumerologyCalculator.getNumberMeaning(result.personalityNumber)}\n' : ''}
✨ Được phân tích bởi Numora App với AI

#ThầnSốHọc #Numerology #Numora
''';

    Share.share(shareText);
  }
}
