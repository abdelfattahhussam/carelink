import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/medicine/medicine_bloc.dart';
import '../../blocs/pharmacy/pharmacy_bloc.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});
  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final _searchCtrl = TextEditingController();
  String? _filterGovernorate;
  String? _filterCity;
  String? _filterCategory;
  bool _filterAvailableNow = false;
  bool _filterExpiringSoon = false;
  bool _filterLowStock = false;
  bool _filterExpired = false;
  bool _filterOutOfStock = false;

  bool get _isPatient {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticated && authState.user.role == UserRole.patient;
  }

  @override
  void initState() {
    super.initState();
    context.read<MedicineBloc>().add(MedicinesFetchRequested());
    context.read<PharmacyBloc>().add(PharmaciesLoadRequested());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.isEmpty) {
      context.read<MedicineBloc>().add(MedicinesFetchRequested());
    } else {
      context.read<MedicineBloc>().add(MedicinesSearchRequested(query: query));
    }
  }

  void _showMedicineDetails(BuildContext context, dynamic medicine) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(left: 28, right: 28, top: 12, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.medication_rounded, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        medicine.category,
                        style: TextStyle(fontSize: 14, color: AppColors.textLight, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              medicine.description,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (!_isPatient)
                  _detailChip(
                    Icons.inventory_2_rounded,
                    "${medicine.quantity} ${medicine.unit.localizedName(context)}",
                    AppColors.success,
                  )
                else
                  _detailChip(
                    Icons.inventory_2_rounded,
                    medicine.inStock ? l10n.available : l10n.outOfStock,
                    medicine.inStock ? AppColors.success : AppColors.error,
                  ),
                _detailChip(
                  Icons.event_rounded,
                  l10n.expDate(DateFormatters.formatDate(medicine.expiryDate)),
                  AppColors.info,
                ),
                _detailChip(
                  Icons.category_rounded,
                  medicine.category,
                  AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_isPatient) ...[
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)),
                      ),
                      child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      onPressed: medicine.inStock && !medicine.isExpired
                          ? () {
                              Navigator.pop(context);
                              this.context.push('/request/${medicine.id}', extra: medicine);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.textLight.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.requestMedicine, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(l10n.close, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ],
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _detailChip(IconData icon, String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.15)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    ),
  );

  Widget _buildFilterBar() {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_isPatient) {
      final hasFilter = _filterExpiringSoon || _filterLowStock || _filterExpired || _filterOutOfStock;

      return Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 4),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _filterChip(
              label: l10n.filterExpiringSoon,
              isActive: _filterExpiringSoon,
              icon: Icons.timer_outlined,
              onTap: () => setState(() => _filterExpiringSoon = !_filterExpiringSoon),
              hideArrow: true,
            ),
            const SizedBox(width: 8),
            _filterChip(
              label: l10n.filterLowStock,
              isActive: _filterLowStock,
              icon: Icons.inventory_2_outlined,
              onTap: () => setState(() => _filterLowStock = !_filterLowStock),
              hideArrow: true,
            ),
            const SizedBox(width: 8),
            _filterChip(
              label: l10n.filterExpired,
              isActive: _filterExpired,
              icon: Icons.event_busy_rounded,
              onTap: () => setState(() => _filterExpired = !_filterExpired),
              hideArrow: true,
            ),
            const SizedBox(width: 8),
            _filterChip(
              label: l10n.filterOutOfStock,
              isActive: _filterOutOfStock,
              icon: Icons.highlight_off_rounded,
              onTap: () => setState(() => _filterOutOfStock = !_filterOutOfStock),
              hideArrow: true,
            ),
            const SizedBox(width: 8),
            if (hasFilter)
              GestureDetector(
                onTap: () => setState(() {
                  _filterExpiringSoon = false;
                  _filterLowStock = false;
                  _filterExpired = false;
                  _filterOutOfStock = false;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.clear_rounded, size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      Text(
                        l10n.clearFilter,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return BlocBuilder<PharmacyBloc, PharmacyState>(
      builder: (context, pharmacyState) {
        if (pharmacyState is! PharmaciesLoaded) return const SizedBox.shrink();
        final hasFilter = _filterGovernorate != null || 
                          _filterCity != null || 
                          _filterCategory != null || 
                          _filterAvailableNow;

        return Container(
          height: 44,
          margin: const EdgeInsets.only(bottom: 4),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Governorate chip
              _filterChip(
                label: _filterGovernorate ?? l10n.allGovernorates,
                isActive: _filterGovernorate != null,
                icon: Icons.map_outlined,
                onTap: () => _showPickerSheet(
                  context,
                  title: l10n.filterByGovernorate,
                  items: pharmacyState.governorates,
                  onSelected: (val) {
                    setState(() {
                      _filterGovernorate = val;
                      _filterCity = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // City chip — only when governorate selected
              if (_filterGovernorate != null) ...[
                _filterChip(
                  label: _filterCity ?? l10n.allCities,
                  isActive: _filterCity != null,
                  icon: Icons.location_city_outlined,
                  onTap: () {
                    final cities = pharmacyState.pharmacies
                        .where((p) => p.governorate == _filterGovernorate)
                        .map((p) => p.city)
                        .toSet()
                        .toList()..sort();
                    _showPickerSheet(
                      context,
                      title: l10n.filterByCity,
                      items: cities,
                      onSelected: (val) => setState(() => _filterCity = val),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],

              // Available filter
              _filterChip(
                label: l10n.filterAvailableNow,
                isActive: _filterAvailableNow,
                icon: Icons.check_circle_outline,
                onTap: () => setState(() => _filterAvailableNow = !_filterAvailableNow),
                hideArrow: true,
              ),
              const SizedBox(width: 8),

              // Category filter
              _filterChip(
                label: _filterCategory ?? l10n.filterCategory,
                isActive: _filterCategory != null,
                icon: Icons.category_outlined,
                onTap: () {
                  final medicineState = context.read<MedicineBloc>().state;
                  if (medicineState is MedicinesLoaded) {
                     final categories = medicineState.medicines.map((m) => m.category).toSet().toList()..sort();
                     _showPickerSheet(
                       context,
                       title: l10n.allCategories,
                       items: categories,
                       onSelected: (val) => setState(() => _filterCategory = val),
                     );
                  }
                },
              ),
              const SizedBox(width: 8),

              // Clear button — only when any filter active
              if (hasFilter)
                GestureDetector(
                  onTap: () => setState(() {
                    _filterGovernorate = null;
                    _filterCity = null;
                    _filterCategory = null;
                    _filterAvailableNow = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.clear_rounded, size: 14, color: AppColors.error),
                        const SizedBox(width: 4),
                        Text(
                          l10n.clearFilter,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip({
    required String label,
    required bool isActive,
    required IconData icon,
    required VoidCallback onTap,
    bool hideArrow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : Theme.of(context).dividerColor.withValues(alpha: 0.3),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? AppColors.primary : AppColors.textLight),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            if (!hideArrow)
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: isActive ? AppColors.primary : AppColors.textLight,
              ),
          ],
        ),
      ),
    );
  }

  void _showPickerSheet(
    BuildContext context, {
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            ...items.map((item) => ListTile(
              title: Text(item, style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                onSelected(item);
              },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.medicines, style: const TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              height: 46,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _searchCtrl,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (query) {
                  setState(() {});
                  _search(query);
                },
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchMedicines,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500, 
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _searchCtrl.clear();
                            _search('');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          _buildFilterBar(),
          Expanded(
            child: BlocBuilder<MedicineBloc, MedicineState>(
              builder: (context, state) {
                if (state is MedicineLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MedicineError) {
                  return Center(child: Text(state.message));
                }
                if (state is MedicinesLoaded) {
                  final pharmacyState = context.watch<PharmacyBloc>().state;
                  
                  // Get pharmacy IDs that match location filter
                  Set<String>? allowedPharmacyIds;
                  if (_isPatient && pharmacyState is PharmaciesLoaded &&
                      (_filterGovernorate != null || _filterCity != null)) {
                    allowedPharmacyIds = pharmacyState.pharmacies.where((p) {
                      if (_filterGovernorate != null && p.governorate != _filterGovernorate) return false;
                      if (_filterCity != null && p.city != _filterCity) return false;
                      return true;
                    }).map((p) => p.id).toSet();
                  }

                  // Apply filter to medicines
                  var medicines = state.medicines;

                  if (_isPatient) {
                    if (allowedPharmacyIds != null) {
                      medicines = medicines.where((m) => m.pharmacyId == null || allowedPharmacyIds!.contains(m.pharmacyId)).toList();
                    }
                    if (_filterCategory != null) {
                      medicines = medicines.where((m) => m.category == _filterCategory).toList();
                    }
                    if (_filterAvailableNow) {
                      medicines = medicines.where((m) => m.inStock && !m.isExpired).toList();
                    }
                  } else {
                    if (_filterExpiringSoon) {
                      medicines = medicines.where((m) => m.daysUntilExpiry <= 30 && !m.isExpired).toList();
                    }
                    if (_filterLowStock) {
                      medicines = medicines.where((m) => m.quantity <= 10 && m.inStock).toList();
                    }
                    if (_filterExpired) {
                      medicines = medicines.where((m) => m.isExpired).toList();
                    }
                    if (_filterOutOfStock) {
                      medicines = medicines.where((m) => !m.inStock).toList();
                    }
                  }

                  if (medicines.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.medication_outlined,
                      title: AppLocalizations.of(context)!.noMedicinesFound,
                      subtitle: AppLocalizations.of(context)!.tryDifferentSearch,
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: medicines.length,
                    itemBuilder: (context, i) {
                      final m = medicines[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => _showMedicineDetails(context, m),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: m.inStock
                                          ? AppColors.primary.withValues(alpha: 0.1)
                                          : AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.medication_rounded,
                                      color: m.inStock ? AppColors.primary : AppColors.textLight,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.name,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          m.category,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        if (m.pharmacyName != null && m.pharmacyName!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.local_pharmacy_outlined, size: 12, color: AppColors.textLight),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  '${AppLocalizations.of(context)!.availableAtPharmacy} ${m.pharmacyName}',
                                                  style: TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            if (!m.inStock)
                                              _tag(AppLocalizations.of(context)!.outOfStock, AppColors.error)
                                            else if (!_isPatient)
                                              _tag("${m.quantity} ${m.unit.localizedName(context)}", AppColors.success)
                                            else
                                              _tag(AppLocalizations.of(context)!.available, AppColors.success),
                                            if (m.isExpired)
                                              _tag(AppLocalizations.of(context)!.expired, AppColors.expired)
                                            else
                                              _tag(AppLocalizations.of(context)!.expDate(DateFormatters.formatDate(m.expiryDate)), AppColors.info),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(Icons.chevron_right_rounded, color: Theme.of(context).dividerColor, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
    ),
  );
}
