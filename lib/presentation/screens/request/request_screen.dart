import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/medicine_model.dart';
import '../../blocs/request/request_bloc.dart';

/// Request screen — patients can request a specific medicine
class RequestScreen extends StatefulWidget {
  final MedicineModel? medicine;
  const RequestScreen({super.key, this.medicine});
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();
  bool _isUrgent = false;
  XFile? _prescriptionImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source, 
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) setState(() => _prescriptionImage = image);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.gallery),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false) || widget.medicine == null) return;
    
    if (_prescriptionImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.attachPrescription), backgroundColor: AppColors.error)
      );
      return;
    }
    
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.notesForPharmacist} is required'), backgroundColor: AppColors.error)
      );
      return;
    }

    context.read<RequestBloc>().add(RequestCreateRequested(
      medicineId: widget.medicine!.id, isUrgent: _isUrgent, reason: _reasonCtrl.text.trim(), prescriptionPath: _prescriptionImage?.path,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final med = widget.medicine;
    return BlocListener<RequestBloc, RequestState>(
      listener: (context, state) {
        if (state is RequestCreated) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.requestSubmitted), backgroundColor: AppColors.success));
          context.pop();
        } else if (state is RequestError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.requestMedicine,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: med == null
          ? Center(child: Text(AppLocalizations.of(context)!.medicineNotFound))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                // Medicine info card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Container(width: 64, height: 64,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.medication_rounded, color: AppColors.primary, size: 32)),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(med.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(med.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ])),
                  ]),
                ),
                const SizedBox(height: 8),
                // Expiry info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: (med.isExpired ? AppColors.error : AppColors.info).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.event, size: 16, color: med.isExpired ? AppColors.error : AppColors.info),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.expiresAt(DateFormatters.formatDate(med.expiryDate), med.daysUntilExpiry.toString()),
                      style: TextStyle(fontSize: 12, color: med.isExpired ? AppColors.error : AppColors.info)),
                  ]),
                ),
                const SizedBox(height: 24),

                if (!med.inStock) ...[
                  Container(padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      const Icon(Icons.warning_amber, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(child: Text(AppLocalizations.of(context)!.thisMedicineIsCurrently, style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w500))),
                    ]),
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: () => _showImagePicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, 
                        borderRadius: BorderRadius.circular(14), 
                        border: Border.all(color: _prescriptionImage != null ? AppColors.success.withValues(alpha: 0.5) : Theme.of(context).dividerColor.withValues(alpha: 0.5))
                      ),
                      child: Row(children: [
                        Icon(Icons.receipt_long, color: _prescriptionImage != null ? AppColors.success : AppColors.primary),
                        const SizedBox(width: 16),
                        Expanded(child: Text(_prescriptionImage != null ? AppLocalizations.of(context)!.prescriptionAttached : AppLocalizations.of(context)!.attachPrescription, style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.titleSmall?.color))),
                        if (_prescriptionImage != null)
                          IconButton(icon: const Icon(Icons.close, color: AppColors.error, size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: () => setState(() => _prescriptionImage = null))
                        else
                          const Icon(Icons.add_a_photo, color: AppColors.textLight, size: 20),
                      ]),
                    ),
                  ),
                  if (_prescriptionImage != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(_prescriptionImage!.path), height: 120, width: double.infinity, fit: BoxFit.cover)),
                  ],
                  const SizedBox(height: 16),
                  AppTextField(controller: _reasonCtrl, label: AppLocalizations.of(context)!.notesForPharmacist, hint: "", prefixIcon: Icons.note_outlined, maxLines: 3),
                  const SizedBox(height: 16),

                  // Urgent toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isUrgent ? AppColors.error.withValues(alpha: 0.08) : Theme.of(context).cardColor, 
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero, title: Text(AppLocalizations.of(context)!.markAsUrgent, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(AppLocalizations.of(context)!.urgentRequestsGetHigher, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                      value: _isUrgent, activeTrackColor: AppColors.error,
                      onChanged: (v) => setState(() => _isUrgent = v),
                    ),
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) => AppButton(text: AppLocalizations.of(context)!.submitRequest, icon: Icons.send, isLoading: state is RequestLoading, onPressed: _submit),
                  ),
                ],
              ])),
            ),
      ),
    );
  }
}
