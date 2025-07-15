import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../providers/app_providers.dart';
import '../widgets/gradient_button.dart';
import '../widgets/loading_overlay.dart';

class CalculationScreen extends ConsumerStatefulWidget {
  const CalculationScreen({super.key});

  @override
  ConsumerState<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends ConsumerState<CalculationScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _nameEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calculationState = ref.watch(numerologyCalculationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích thần số học'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: LoadingOverlay(
        isLoading: calculationState.isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              _buildProgressIndicator(),
              const SizedBox(height: 32),
              
              // Instructions
              _buildInstructions(),
              const SizedBox(height: 32),
              
              // Date Input
              _buildDateInput(),
              const SizedBox(height: 24),
              
              // Name Input Toggle
              _buildNameToggle(),
              
              if (_nameEnabled) ...[
                const SizedBox(height: 16),
                _buildNameInput(),
              ],
              
              const SizedBox(height: 32),
              
              // Calculate Button
              _buildCalculateButton(),
              
              if (calculationState.error != null) ...[
                const SizedBox(height: 16),
                _buildErrorMessage(calculationState.error!),
              ],
              
              const SizedBox(height: 32),
              
              // Example Section
              _buildExampleSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bước 1: Nhập thông tin',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Chuẩn bị cho phân tích AI',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX();
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin cần thiết',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: 8),
        Text(
          'Ngày sinh là thông tin bắt buộc để tính số đường đời. Họ tên sẽ giúp phân tích chi tiết hơn về số linh hồn và sứ mệnh.',
          style: AppTextStyles.body2.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms);
  }

  Widget _buildDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày sinh *',
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Chọn ngày sinh của bạn',
                    style: AppTextStyles.body1.copyWith(
                      color: _selectedDate != null 
                          ? Colors.black87 
                          : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms);
  }

  Widget _buildNameToggle() {
    return Row(
      children: [
        Switch(
          value: _nameEnabled,
          onChanged: (value) {
            setState(() {
              _nameEnabled = value;
              if (!value) {
                _nameController.clear();
              }
            });
          },
          activeColor: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phân tích chi tiết với họ tên',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Tùy chọn để có thêm số linh hồn, sứ mệnh',
                style: AppTextStyles.body2.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Họ và tên đầy đủ',
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Ví dụ: Nguyễn Văn Nam',
            prefixIcon: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY();
  }

  Widget _buildCalculateButton() {
    final isEnabled = _selectedDate != null;
    
    return GradientButton(
      onPressed: isEnabled ? _calculateNumerology : null,
      gradient: isEnabled 
          ? AppColors.primaryGradient 
          : LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[400]!],
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: isEnabled ? Colors.white : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            'Phân tích với AI',
            style: AppTextStyles.body1.copyWith(
              color: isEnabled ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms);
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    ).animate().shake();
  }

  Widget _buildExampleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                'Ví dụ phân tích',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Số đường đời 7: Người tìm kiếm tri thức, có khả năng phân tích sâu sắc\n'
            '• Số linh hồn 3: Khao khát sáng tạo và biểu đạt bản thân\n'
            '• Số sứ mệnh 5: Sinh ra để khám phá và mang lại đổi mới',
            style: AppTextStyles.body2.copyWith(
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms);
  }

  void _selectDate() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      currentTime: _selectedDate ?? DateTime(1990, 1, 1),
      locale: LocaleType.vi,
      onConfirm: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }

  void _calculateNumerology() async {
    if (_selectedDate == null) return;

    final name = _nameEnabled && _nameController.text.isNotEmpty 
        ? _nameController.text.trim() 
        : null;

    await ref.read(numerologyCalculationProvider.notifier).calculateNumerology(
      birthDate: _selectedDate!,
      fullName: name,
    );

    // Chuyển đến màn hình kết quả
    if (mounted) {
      context.push('/result');
    }
  }
}
