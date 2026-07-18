import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/app_sheets.dart';
import '../../app/data/models/order_model.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../design_system/tokens/premium_shadows.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderKind? _filter;

  @override
  Widget build(BuildContext context) {
    final session = SessionService.to;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        centerTitle: true,
        title: Text(
          'My Orders',
          style: PremiumTypography.h3.copyWith(
            color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
          ),
        ),
      ),
      body: Obx(() {
        final all = session.orders;
        if (all.isEmpty) {
          return _buildEmptyState(context, isDark);
        }
        final list = _filter == null
            ? all.toList()
            : all.where((o) => o.kind == _filter).toList();
        return ListView(
          padding: EdgeInsets.fromLTRB(
            PremiumSpacing.screenHorizontal,
            PremiumSpacing.md,
            PremiumSpacing.screenHorizontal,
            MediaQuery.of(context).padding.bottom + 28,
          ),
          children: [
            _PremiumStatsHeader(orders: all),
            const SizedBox(height: 20),
            _PremiumFilters(
              current: _filter,
              onChanged: (k) => setState(() => _filter = k),
            ),
            const SizedBox(height: 20),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'No ${_filter == OrderKind.topup ? 'top-ups' : 'products'} yet',
                  textAlign: TextAlign.center,
                  style: PremiumTypography.body.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              )
            else
              ...list.map((o) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _PremiumOrderCard(
                        order: o, onTap: () => _showReceipt(context, o)),
                  )),
            const SizedBox(height: 8),
            const _PremiumTrustFooter(),
          ],
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
            'No orders yet',
            style: PremiumTypography.h5.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your top-ups & purchases will appear here',
            style: PremiumTypography.body.copyWith(
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showReceipt(BuildContext context, OrderModel o) {
    AppSheet.show(
      title: 'Order Receipt',
      subtitle: o.id,
      child: _PremiumReceipt(order: o),
    );
  }
}

class _PremiumStatsHeader extends StatelessWidget {
  final List<OrderModel> orders;
  const _PremiumStatsHeader({required this.orders});

  @override
  Widget build(BuildContext context) {
    final total = orders.fold<double>(0, (s, o) => s + o.amount);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: PremiumColors.primaryGradient,
        borderRadius: BorderRadius.circular(PremiumRadius.card),
        boxShadow: PremiumShadows.primaryGlow,
      ),
      child: Row(
        children: [
          _buildStat('${orders.length}', 'Total orders', Icons.receipt_long_rounded),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.25),
          ),
          _buildStat(taka(total), 'Total spent', Icons.payments_rounded),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: PremiumTypography.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: PremiumTypography.labelSmall.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumFilters extends StatelessWidget {
  final OrderKind? current;
  final ValueChanged<OrderKind?> onChanged;
  const _PremiumFilters({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        _buildChip(context, isDark, 'All', null),
        const SizedBox(width: 10),
        _buildChip(context, isDark, 'Top-ups', OrderKind.topup),
        const SizedBox(width: 10),
        _buildChip(context, isDark, 'Products', OrderKind.product),
      ],
    );
  }

  Widget _buildChip(BuildContext context, bool isDark, String label, OrderKind? kind) {
    final active = current == kind;
    
    return GestureDetector(
      onTap: () => onChanged(kind),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? PremiumColors.primary
              : (isDark ? PremiumColors.darkCard : PremiumColors.lightCard),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? PremiumColors.primary
                : (isDark ? PremiumColors.darkBorder : PremiumColors.lightBorder),
          ),
          boxShadow: active ? PremiumShadows.primaryGlow : null,
        ),
        child: Text(
          label,
          style: PremiumTypography.labelSmall.copyWith(
            color: active
                ? Colors.white
                : (isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
class _PremiumOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  const _PremiumOrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = order.accent;
    
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.35)),
            ),
            child: Icon(order.icon, color: accent, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  style: PremiumTypography.bodyMedium.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.kindLabel} • ${order.subtitle}',
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(order),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderModel order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: order.statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: order.statusColor.withOpacity(0.3)),
      ),
      child: Text(
        order.statusLabel,
        style: PremiumTypography.labelSmall.copyWith(
          color: order.statusColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PremiumReceipt extends StatelessWidget {
  final OrderModel order;
  const _PremiumReceipt({required this.order});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = order.accent;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.title,
            style: PremiumTypography.h4.copyWith(
              color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.kindLabel} • ${order.subtitle}',
            style: PremiumTypography.caption.copyWith(
              color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent.withOpacity(0.35)),
              ),
              child: Icon(order.icon, color: accent, size: 28),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  'Amount',
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  taka(order.amount),
                  style: PremiumTypography.currencyMedium.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...order.details.entries.map((e) => _buildRow(context, isDark, e.key, e.value)),
          _buildRow(context, isDark, 'Order ID', order.id),
          _buildRow(context, isDark, 'Date', fullDateWeekday(order.date)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PremiumColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(PremiumRadius.md),
              border: Border.all(color: PremiumColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: PremiumColors.success, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Verified & recorded by SquadUp. Keep this receipt for your reference.',
                    style: PremiumTypography.bodySmall.copyWith(
                      color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: PremiumTypography.caption.copyWith(
                color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: PremiumTypography.bodyMedium.copyWith(
                color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumTrustFooter extends StatelessWidget {
  const _PremiumTrustFooter();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PremiumColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield_rounded, color: PremiumColors.success, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Every order is safe & traceable',
                  style: PremiumTypography.bodyMedium.copyWith(
                    color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Secure payments • Instant top-ups • Real support',
                  style: PremiumTypography.caption.copyWith(
                    color: isDark ? PremiumColors.darkTextTertiary : PremiumColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
