import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/data/models/wallet_model.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/premium_back_button.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text(
          'All Transactions',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: Obx(() {
        final txs = session.transactions;
        if (txs.isEmpty) {
          return _buildEmptyState(context, isDark);
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          itemCount: txs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => RepaintBoundary(
            child: _PremiumTxRow(tx: txs[i]),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? PremiumColors.darkSurface3 : PremiumColors.lightSurface3,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No transactions yet',
            style: PremiumTypography.h5.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumTxRow extends StatelessWidget {
  final TransactionModel tx;
  
  const _PremiumTxRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool credit = tx.isCredit;
    final Color color = credit ? PremiumColors.winning : PremiumColors.danger;
    
    return PremiumCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              credit ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description.isEmpty ? tx.type.name : tx.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PremiumTypography.bodyMedium.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${tx.method} • ${shortDateTime(tx.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${credit ? '+' : '-'}${taka(tx.amount)}',
            style: PremiumTypography.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
