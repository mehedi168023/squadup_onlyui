import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_toast.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../app/widgets/responsive.dart';

class UploadEvidenceScreen extends StatefulWidget {
  const UploadEvidenceScreen({super.key});

  @override
  State<UploadEvidenceScreen> createState() => _UploadEvidenceScreenState();
}

class _UploadEvidenceScreenState extends State<UploadEvidenceScreen> {
  final _roomId = TextEditingController();
  bool _attached = false;

  @override
  void dispose() {
    _roomId.dispose();
    super.dispose();
  }

  void _pickImage() {
    setState(() => _attached = true);
    AppToast.success('Screenshot attached');
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      AppToast.warning('Clipboard is empty');
      return;
    }
    _roomId.text = text;
    AppToast.info('Pasted Room ID: $text');
  }

  void _submit() {
    if (!_attached) {
      AppToast.warning('আগে স্ক্রিনশট আপলোড করুন');
      return;
    }
    if (_roomId.text.trim().isEmpty) {
      AppToast.warning('Room ID দিন');
      return;
    }
    Get.back();
    AppToast.success('Evidence submitted — under review');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'Upload Evidence',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            24,
          ),
          children: [
            _PremiumUploadBox(attached: _attached, onTap: _pickImage),
            const SizedBox(height: 24),
            PremiumCard(
              padding: const EdgeInsets.all(4),
              color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
              child: TextField(
                controller: _roomId,
                style: PremiumTypography.body.copyWith(
                  color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                ),
                decoration: InputDecoration(
                  hintText: 'Room ID',
                  hintStyle: PremiumTypography.body.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: IconButton(
                    tooltip: 'Paste',
                    onPressed: _paste,
                    icon: const Icon(Icons.content_paste_rounded, color: PremiumColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton.primary(
              text: 'SUBMIT',
              icon: const Icon(Icons.check_rounded),
              onPressed: _submit,
              isFullWidth: true,
              customColor: PremiumColors.winning,
            ),
            const SizedBox(height: 24),
            _buildNote(isDark, 'স্ক্রিনশট আপলোড না করলে আপনি প্রাইজ পাবেন না।'),
            const SizedBox(height: 12),
            _buildNote(isDark, 'উলটা পালটা ছবি/স্ক্রিনশট আপলোড করলে আপনাকে এপ থেকে চিরকালের জন্য ব্যান করে দেওয়া হবে।'),
            const SizedBox(height: 12),
            _buildNote(isDark, 'স্ক্রিনশট আপলোড করেও বিজয়ী পুরস্কার না পেলে সাপোর্টে যোগাযোগ করুন।'),
          ],
        ),
      ),
    );
  }

  Widget _buildNote(bool isDark, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: PremiumColors.winning,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumUploadBox extends StatelessWidget {
  final bool attached;
  final VoidCallback onTap;
  const _PremiumUploadBox({required this.attached, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = attached ? PremiumColors.winning : PremiumColors.primary;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(PremiumRadius.card),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              attached ? Icons.check_circle_rounded : Icons.add_photo_alternate_outlined,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              attached ? 'Screenshot attached — tap to change' : 'Click here to upload image',
              style: PremiumTypography.bodyMedium.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
