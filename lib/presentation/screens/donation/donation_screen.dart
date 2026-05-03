import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/medicine_unit.dart';
import '../../../data/models/pharmacy_model.dart';
import '../../blocs/donation/donation_bloc.dart';
import '../../blocs/pharmacy/pharmacy_bloc.dart';
import 'pharmacy_picker_screen.dart';

/// Donation form screen — allows donors to submit medicine details
class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});
  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _expiryCtrl =
      TextEditingController(); // Added controller for expiry date
  DateTime? _expiryDate;
  String _category = 'General';
  MedicineUnit _unit = MedicineUnit.box;

  String? _boxImagePath;
  final ImagePicker _picker = ImagePicker();

  PharmacyModel? _selectedPharmacy;
  bool _pharmacyError = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    _qtyCtrl.dispose();
    _expiryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.camera),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 1024,
                  maxHeight: 1024,
                );
                if (image != null) setState(() => _boxImagePath = image.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.gallery),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  maxWidth: 1024,
                  maxHeight: 1024,
                );
                if (image != null) setState(() => _boxImagePath = image.path);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (date != null) {
      setState(() {
        _expiryDate = date;
        _expiryCtrl.text = DateFormatters.formatDate(
          date,
          Localizations.localeOf(context).languageCode,
        );
      });
    }
  }

  Future<void> _pickPharmacy() async {
    final pharmacy = await Navigator.push<PharmacyModel>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PharmacyBloc>(),
          child: const PharmacyPickerScreen(),
        ),
      ),
    );
    if (pharmacy != null) {
      setState(() {
        _selectedPharmacy = pharmacy;
        _pharmacyError = false;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;

    if (_boxImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.boxImageRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectExpiryDate),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedPharmacy == null) {
      setState(() => _pharmacyError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pharmacyRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<DonationBloc>().add(
      DonationCreateRequested(
        name: _nameCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        expiryDate: _expiryDate!.toIso8601String(),
        quantity: int.parse(_qtyCtrl.text),
        category: _category,
        unit: _unit.value,
        boxImagePath: _boxImagePath,
        pharmacyId: _selectedPharmacy!.id,
        pharmacyName: _selectedPharmacy!.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<DonationBloc, DonationState>(
      listener: (context, state) {
        if (state is DonationCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.donationSubmittedSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is DonationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.donateMedicine,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.volunteer_activism,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.yourDonationWillBe,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Pharmacy Picker
                _buildPharmacyPicker(l10n),
                const SizedBox(height: 24),

                // Medicine Name
                AppTextField(
                  controller: _nameCtrl,
                  label: l10n.medicineName,
                  hint: l10n.medicineNameHint,
                  prefixIcon: Icons.medication,
                  validator: (v) =>
                      Validators.required(v, l10n.medicineNameRequired),
                ),
                const SizedBox(height: 24),

                // Box Image Upload (Replaces Description)
                _buildImagePicker(l10n),
                const SizedBox(height: 24),

                // Category dropdown
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    prefixIcon: const Icon(
                      Icons.category_outlined,
                      color: AppColors.textLight,
                      size: 22,
                    ),
                  ),
                  items:
                      [
                            ('General', l10n.catGeneral),
                            ('Antibiotics', l10n.catAntibiotics),
                            ('Pain Relief', l10n.catPainRelief),
                            ('Digestive', l10n.catDigestive),
                            ('Diabetes', l10n.catDiabetes),
                            ('Cardiovascular', l10n.catCardiovascular),
                            ('Vitamins', l10n.catVitamins),
                            ('Other', l10n.catOther),
                          ]
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.$1,
                              child: Text(c.$2),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _category = v ?? 'General'),
                ),
                const SizedBox(height: 16),

                // Quantity & Unit Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        controller: _qtyCtrl,
                        label: l10n.quantity,
                        hint: l10n.quantityHint,
                        prefixIcon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        validator: Validators.quantity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<MedicineUnit>(
                        initialValue: _unit,
                        isExpanded: true,
                        decoration: InputDecoration(labelText: l10n.unit),
                        items: [
                          DropdownMenuItem(
                            value: MedicineUnit.box,
                            child: Text(l10n.box),
                          ),
                          DropdownMenuItem(
                            value: MedicineUnit.strip,
                            child: Text(l10n.strip),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _unit = v ?? MedicineUnit.box),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Expiry date picker
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _expiryCtrl,
                      label: l10n.expiryDate,
                      hint: l10n.selectExpiryDate,
                      prefixIcon: Icons.calendar_today_outlined,
                      validator: (_) =>
                          _expiryDate == null ? l10n.expiryDateRequired : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Notes for Pharmacist (New optional field)
                AppTextField(
                  controller: _notesCtrl,
                  label: l10n.notesForPharmacist,
                  hint: l10n.addReviewNotesOptional,
                  prefixIcon: Icons.note_alt_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                BlocBuilder<DonationBloc, DonationState>(
                  builder: (context, state) => AppButton(
                    text: l10n.submitDonation,
                    icon: Icons.send,
                    isLoading: state is DonationLoading,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyPicker(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _pickPharmacy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _selectedPharmacy != null
              ? AppColors.primary.withValues(alpha: 0.05)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _pharmacyError
                ? AppColors.error
                : _selectedPharmacy != null
                ? AppColors.primary
                : AppColors.divider.withValues(alpha: 0.5),
            width: _selectedPharmacy != null || _pharmacyError ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _selectedPharmacy != null
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _selectedPharmacy != null
                    ? Icons.check_circle_rounded
                    : Icons.local_pharmacy_outlined,
                color: _selectedPharmacy != null
                    ? AppColors.success
                    : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPharmacy?.name ?? l10n.selectPharmacy,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: _selectedPharmacy != null
                          ? Theme.of(context).textTheme.titleMedium?.color
                          : AppColors.textLight,
                    ),
                  ),
                  if (_selectedPharmacy != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _selectedPharmacy!.fullLocation,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ] else if (_pharmacyError) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.pharmacyRequired,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _boxImagePath == null
                ? AppColors.divider.withValues(alpha: 0.3)
                : AppColors.success.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: _boxImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(_boxImagePath!), fit: BoxFit.cover),
                    Container(
                      color: Colors.black26,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.boxImageAttached,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.attachBoxImage,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.jpgPngOrPdf,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
