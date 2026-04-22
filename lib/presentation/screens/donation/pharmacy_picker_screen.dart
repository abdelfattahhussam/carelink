import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../blocs/pharmacy/pharmacy_bloc.dart';

/// Screen for donors to pick a pharmacy — filtered by governorate → city → district
class PharmacyPickerScreen extends StatefulWidget {
  const PharmacyPickerScreen({super.key});
  @override
  State<PharmacyPickerScreen> createState() => _PharmacyPickerScreenState();
}

class _PharmacyPickerScreenState extends State<PharmacyPickerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PharmacyBloc>().add(PharmaciesLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectPharmacy, style: const TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<PharmacyBloc, PharmacyState>(
        builder: (context, state) {
          if (state is PharmacyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PharmacyError) {
            return Center(child: Text(state.message));
          }
          if (state is PharmaciesLoaded) {
            return Column(
              children: [
                _buildFilters(context, l10n, state),
                const SizedBox(height: 8),
                Expanded(child: _buildList(context, l10n, state)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context, AppLocalizations l10n, PharmaciesLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location icon + title
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.pharmacyLocation,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Governorate dropdown
          _buildDropdown<String>(
            value: state.filterGovernorate,
            hint: l10n.allGovernorates,
            items: state.governorates,
            onChanged: (v) {
              if (v != null) {
                context.read<PharmacyBloc>().add(PharmacyFilterChanged(governorate: v));
              }
            },
            icon: Icons.map_outlined,
          ),
          const SizedBox(height: 8),

          // City dropdown — enabled only when governorate selected
          _buildDropdown<String>(
            value: state.filterCity,
            hint: l10n.allCities,
            items: state.cities,
            onChanged: state.filterGovernorate != null
                ? (v) {
                    if (v != null) {
                      context.read<PharmacyBloc>().add(PharmacyFilterChanged(city: v));
                    }
                  }
                : null,
            icon: Icons.location_city_outlined,
          ),
          const SizedBox(height: 8),

          // District dropdown — enabled only when city selected
          _buildDropdown<String>(
            value: state.filterDistrict,
            hint: l10n.allDistricts,
            items: state.districts,
            onChanged: state.filterCity != null
                ? (v) {
                    if (v != null) {
                      context.read<PharmacyBloc>().add(PharmacyFilterChanged(district: v));
                    }
                  }
                : null,
            icon: Icons.my_location_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?>? onChanged,
    required IconData icon,
  }) {
    final isEnabled = onChanged != null && items.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isEnabled
            ? AppColors.primary.withValues(alpha: 0.04)
            : Theme.of(context).disabledColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? AppColors.primary.withValues(alpha: 0.15)
              : Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: items.contains(value) ? value : null,
          hint: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textLight),
              const SizedBox(width: 8),
              Text(hint, style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            ],
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: isEnabled ? AppColors.primary : AppColors.textLight),
          items: items.map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, AppLocalizations l10n, PharmaciesLoaded state) {
    final pharmacies = state.filtered;

    if (pharmacies.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.local_pharmacy_outlined,
        title: l10n.noPharmaciesFound,
        subtitle: l10n.noPharmaciesInArea,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: pharmacies.length,
      itemBuilder: (context, i) {
        final p = pharmacies[i];
        final isSelected = state.selectedPharmacy?.id == p.id;

        return GestureDetector(
          onTap: () {
            context.read<PharmacyBloc>().add(PharmacySelected(p));
            Navigator.pop(context, p);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.local_pharmacy_rounded, color: AppColors.primary, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              p.fullLocation,
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.address,
                        style: TextStyle(fontSize: 11, color: AppColors.textLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
