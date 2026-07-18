import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/core/app_constants.dart';
import '../../app/core/validators.dart';
import '../../app/core/app_toast.dart';
import '../../app/data/mock/mock_data.dart';
import '../../app/data/models/misc_models.dart';
import '../../app/data/services/bd_location_api.dart';
import '../../app/data/services/session_service.dart';
import '../../design_system/tokens/premium_colors.dart';
import '../../design_system/tokens/premium_typography.dart';
import '../../design_system/tokens/premium_spacing.dart';
import '../../design_system/tokens/premium_radius.dart';
import '../../design_system/components/cards/premium_card.dart';
import '../../design_system/components/buttons/premium_button.dart';
import '../../app/widgets/premium_back_button.dart';
import '../../design_system/tokens/premium_shadows.dart';
import '../../app/widgets/responsive.dart';

class ProductBuyScreen extends StatefulWidget {
  const ProductBuyScreen({super.key});

  @override
  State<ProductBuyScreen> createState() => _ProductBuyScreenState();
}

class _ProductBuyScreenState extends State<ProductBuyScreen> {
  final Product product = Get.arguments as Product;
  late String _color = product.colors.first;
  int _qty = 1;

  List<BdDivision> _divisions = [];
  BdDivision? _division;
  List<BdDistrict> _districts = [];
  BdDistrict? _district;
  bool _loadingDiv = true;
  bool _loadingDist = false;
  bool _divError = false;

  final _address = TextEditingController();
  final _phone = TextEditingController();
  bool _placing = false;

  double get _subtotal => product.price * _qty;
  double get _delivery => _division == null ? 0 : (_division!.name == 'Dhaka' ? MockData.deliveryInsideDhaka : MockData.deliveryOutsideDhaka);
  double get _total => _subtotal + _delivery;

  @override
  void initState() {
    super.initState();
    _loadDivisions();
  }

  @override
  void dispose() {
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _loadDivisions() async {
    setState(() { _loadingDiv = true; _divError = false; });
    try {
      final list = await BdLocationApi.divisions();
      if (!mounted) return;
      setState(() { _divisions = list; _loadingDiv = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _loadingDiv = false; _divError = true; });
      AppToast.error('Could not load divisions — tap retry');
    }
  }

  Future<void> _loadDistricts(String divisionId) async {
    setState(() { _loadingDist = true; _districts = []; _district = null; });
    try {
      final list = await BdLocationApi.districts(divisionId);
      if (!mounted) return;
      setState(() { _districts = list; _loadingDist = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingDist = false);
      AppToast.error('Could not load districts');
    }
  }

  Future<void> _placeOrder() async {
    if (_division == null) { AppToast.warning('Select your delivery division'); return; }
    if (_district == null) { AppToast.warning('Select your district'); return; }
    if (_address.text.trim().length < 6) { AppToast.warning('Enter your full delivery address'); return; }
    final phone = _phone.text.trim();
    final phoneErr = Validators.phone(phone);
    if (phoneErr != null) { AppToast.error(phoneErr); return; }
    setState(() => _placing = true);
    final ok = await SessionService.to.submitProductOrder({
      'productName': product.name, 'qty': _qty, 'color': _color,
      'unitPrice': product.price, 'subtotal': _subtotal,
      'deliveryCharge': _delivery, 'total': _total,
      'divisionId': _division!.id, 'divisionName': _division!.name,
      'districtId': _district!.id, 'districtName': _district!.name,
      'address': _address.text.trim(), 'phone': phone, 'paymentMethod': 'cod',
    });
    if (!mounted) return;
    setState(() => _placing = false);
    if (!ok) return;
    final orderId = SessionService.to.orders.first.id;
    Get.back();
    AppToast.success('Order #$orderId placed! $_qty× ${product.name} • ${taka(_total)}');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? PremiumColors.darkBg : PremiumColors.lightBg,
      appBar: AppBar(
        leading: const PremiumBackButton(),
        title: Text('Checkout', style: PremiumTypography.h3.copyWith(
          color: isDark ? PremiumColors.darkText : PremiumColors.lightText,
        )),
      ),
      bottomNavigationBar: _buildBottomBar(context, isDark),
      body: ResponsiveCenter(
        child: ListView(
          padding: EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            _buildProductSummary(context, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(isDark, 'QUANTITY'),
            const SizedBox(height: 16),
            _buildQuantityRow(isDark),
            if (product.colors.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(isDark, 'SELECT COLOR'),
              const SizedBox(height: 16),
              _buildColorPicker(isDark),
            ],
            const SizedBox(height: 24),
            _buildSectionHeader(isDark, 'DELIVERY AREA'),
            const SizedBox(height: 16),
            _buildDivisionDropdown(context, isDark),
            const SizedBox(height: 12),
            _buildDistrictDropdown(context, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(isDark, 'FULL ADDRESS'),
            const SizedBox(height: 16),
            _buildField(context, isDark, _address, 'House / road / area, city, post code…', Icons.location_on_outlined, maxLines: 3),
            const SizedBox(height: 24),
            _buildSectionHeader(isDark, 'PHONE NUMBER'),
            const SizedBox(height: 16),
            _buildField(context, isDark, _phone, '01XXXXXXXXX', Icons.phone_outlined, inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11),
            ]),
            const SizedBox(height: 24),
            _buildOrderSummary(isDark),
          ],
        ),
      ),
    );
  }
  Widget _buildProductSummary(BuildContext context, bool isDark) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Row(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: PremiumColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(PremiumRadius.md),
            ),
            child: product.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(PremiumRadius.md),
                    child: Image.asset(product.image!, fit: BoxFit.cover, cacheWidth: 200))
                : Icon(product.icon, size: 32, color: PremiumColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: PremiumTypography.h5.copyWith(color: context.text)),
                const SizedBox(height: 6),
                Text(taka(product.price), style: PremiumTypography.currencySmall.copyWith(color: PremiumColors.winning)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark, String title) {
    return Text(title, style: PremiumTypography.labelLarge.copyWith(
      color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary,
      letterSpacing: 1.2, fontWeight: FontWeight.w700,
    ));
  }

  Widget _buildQuantityRow(bool isDark) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quantity', style: PremiumTypography.bodyMedium.copyWith(color: context.text)),
          Row(
            children: [
              PremiumIconButton(icon: Icons.remove_rounded, onPressed: () => setState(() => _qty = (_qty - 1).clamp(1, 99)), size: 44),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$_qty', style: PremiumTypography.h4.copyWith(color: context.text)),
              ),
              PremiumIconButton(icon: Icons.add_rounded, onPressed: () => setState(() => _qty = (_qty + 1).clamp(1, 99)), size: 44),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(bool isDark) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Wrap(
        spacing: 12, runSpacing: 12,
        children: product.colors.map((c) {
          final active = _color == c;
          return GestureDetector(
            onTap: () => setState(() => _color = c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: _parseColor(c),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: active ? PremiumColors.primary : Colors.transparent, width: 3),
                boxShadow: active ? PremiumShadows.primaryGlow : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _parseColor(String hex) {
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); }
    catch (_) { return PremiumColors.primary; }
  }

  Widget _buildDivisionDropdown(BuildContext context, bool isDark) {
    return _buildDropdown(
      context, isDark, 'Select Division', _division?.name,
      Icons.location_on_rounded, _loadingDiv, _divError,
      _loadDivisions, _divisions.map((d) => d.name).toList(),
      (i) => setState(() {
        _division = _divisions[i];
        if (_division != null) _loadDistricts(_division!.id);
      }),
    );
  }

  Widget _buildDistrictDropdown(BuildContext context, bool isDark) {
    return _buildDropdown(
      context, isDark, 'Select District', _district?.name,
      Icons.map_rounded, _loadingDist, false,
      () {}, _districts.map((d) => d.name).toList(),
      (i) => setState(() => _district = _districts[i]),
      enabled: _division != null,
    );
  }

  Widget _buildDropdown(
    BuildContext context, bool isDark, String label, String? selected,
    IconData icon, bool loading, bool error, VoidCallback onRetry,
    List<String> items, ValueChanged<int> onChanged, {bool enabled = true},
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? (isDark ? PremiumColors.darkCard : PremiumColors.lightCard) : context.surface2,
        borderRadius: BorderRadius.circular(PremiumRadius.input),
        border: Border.all(color: context.border),
      ),
      child: loading
          ? const Padding(padding: EdgeInsets.all(12), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
          : error
              ? GestureDetector(
                  onTap: onRetry,
                  child: Padding(padding: const EdgeInsets.all(12), child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: PremiumColors.danger, size: 20),
                      const SizedBox(width: 8),
                      Text('Tap to retry', style: PremiumTypography.body.copyWith(color: PremiumColors.danger)),
                    ],
                  )),
                )
              : DropdownButtonFormField<int>(
                  value: items.isNotEmpty ? 0 : null,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(14),
                  dropdownColor: isDark ? PremiumColors.darkCardElevated : PremiumColors.lightCard,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.textTertiary),
                  decoration: const InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
                  hint: Row(children: [
                    Icon(icon, size: 20, color: context.textSecondary),
                    const SizedBox(width: 8),
                    Text(label, style: PremiumTypography.body.copyWith(color: context.textSecondary)),
                  ]),
                  items: List.generate(items.length, (i) => DropdownMenuItem<int>(value: i, child: Text(items[i]))),
                  onChanged: enabled ? (v) { if (v != null) onChanged(v); } : null,
                ),
    );
  }

  Widget _buildField(BuildContext context, bool isDark, TextEditingController controller, String hint, IconData icon, {int maxLines = 1, List<TextInputFormatter>? inputFormatters}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? PremiumColors.darkCard : PremiumColors.lightCard,
        borderRadius: BorderRadius.circular(PremiumRadius.input),
        border: Border.all(color: context.border),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        style: PremiumTypography.body.copyWith(color: context.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: PremiumTypography.body.copyWith(color: context.textTertiary),
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          prefixIcon: Padding(padding: const EdgeInsets.only(left: 16), child: Icon(icon)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(bool isDark) {
    return PremiumCard(
      padding: PremiumSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ORDER SUMMARY', style: PremiumTypography.labelLarge.copyWith(
            color: isDark ? PremiumColors.darkTextSecondary : PremiumColors.lightTextSecondary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal ($_qty items)', taka(_subtotal)),
          const SizedBox(height: 8),
          _buildSummaryRow('Delivery', _delivery == 0 ? 'Calculated after selection' : taka(_delivery)),
          Divider(height: 24, color: context.divider),
          _buildSummaryRow('Total', taka(_total), isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(child: Text(label, style: isBold ? PremiumTypography.bodyMedium.copyWith(color: context.text) : PremiumTypography.body.copyWith(color: context.textSecondary))),
        Text(value, style: (isBold ? PremiumTypography.bodyMedium : PremiumTypography.body).copyWith(
          color: isBold ? PremiumColors.winning : context.text, fontWeight: isBold ? FontWeight.w800 : FontWeight.w500)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDark) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? PremiumColors.darkSurface1 : PremiumColors.lightCard,
          border: Border(top: BorderSide(color: context.divider)),
        ),
        child: SafeArea(
          child: PremiumButton.primary(
            text: 'Place Order — ${taka(_total)}',
            icon: const Icon(Icons.shopping_bag_rounded),
            onPressed: _placing ? null : _placeOrder,
            isLoading: _placing,
            isFullWidth: true,
            customColor: PremiumColors.winning,
          ),
        ),
      ),
    );
  }
}
