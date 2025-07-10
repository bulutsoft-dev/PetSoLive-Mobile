import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_cubit.dart';
import '../partials/base_app_bar.dart';
import '../../data/models/pet_dto.dart';
import '../../data/models/user_dto.dart';
import '../../data/models/adoption_request_dto.dart';
import '../../data/providers/adoption_request_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/admob_banner_widget.dart';

class AdoptionRequestFormScreen extends StatefulWidget {
  final PetDto pet;
  final UserDto user;
  const AdoptionRequestFormScreen({Key? key, required this.pet, required this.user}) : super(key: key);

  @override
  State<AdoptionRequestFormScreen> createState() => _AdoptionRequestFormScreenState();
}

class _AdoptionRequestFormScreenState extends State<AdoptionRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _messageController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  DateTime? _selectedDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _selectedDate = widget.user.dateOfBirth;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }
    setState(() { _loading = true; });
    final adoptionRequest = AdoptionRequestDto(
      id: 0,
      petId: widget.pet.id,
      petName: widget.pet.name,
      userId: widget.user.id,
      userName: widget.user.username ?? '-',
      message: _messageController.text,
      status: 'pending',
      requestDate: DateTime.now(),
    );
    final api = AdoptionRequestApiService();
    final accountState = context.read<AccountCubit>().state;
    String? token;
    if (accountState is AccountSuccess) {
      token = accountState.response.token;
    }
    if (token == null) {
      setState(() { _loading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oturum bulunamadı!')),
      );
      return;
    }
    final success = await api.sendAdoptionRequest(adoptionRequest, token);
    setState(() { _loading = false; });
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sahiplenme isteğiniz gönderildi!')),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.of(context).pop(true); // Detay ekranı için result:true
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sahiplenme isteği gönderilemedi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Sahiplenme Başvurusu',
        showLogo: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Row(
                children: [
                  Icon(Icons.pets, color: colorScheme.primary, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'adoption_form.title'.tr(args: [widget.pet.name]),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'adoption_form.subtitle'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
              const SizedBox(height: 22),
              // Bilgilendirme kutusu
              Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.18)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: colorScheme.primary, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'adoption_form.info'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontSize: 15.2),
                      ),
                    ),
                  ],
                ),
              ),
              // Kullanıcı adı ve e-posta
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.user.username,
                      decoration: InputDecoration(
                        labelText: 'adoption_form.name'.tr(),
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.user.email,
                      decoration: InputDecoration(
                        labelText: 'adoption_form.email'.tr(),
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Telefon
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'adoption_form.phone'.tr() + ' *',
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'adoption_form.required_phone'.tr() : null,
              ),
              const SizedBox(height: 16),
              // Adres
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'adoption_form.address'.tr() + ' *',
                  prefixIcon: const Icon(Icons.home),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (v) => v == null || v.isEmpty ? 'adoption_form.required_address'.tr() : null,
              ),
              const SizedBox(height: 16),
              // Doğum tarihi
              GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime(now.year - 18),
                    firstDate: DateTime(1900),
                    lastDate: now,
                  );
                  if (picked != null) {
                    setState(() { _selectedDate = picked; });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'adoption_form.birthdate'.tr() + ' *',
                      prefixIcon: const Icon(Icons.cake),
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
                          : '',
                    ),
                    validator: (v) => _selectedDate == null ? 'adoption_form.required_birthdate'.tr() : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Mesaj
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'adoption_form.message'.tr(),
                  prefixIcon: const Icon(Icons.message),
                  border: const OutlineInputBorder(),
                  hintText: 'adoption_form.message_hint'.tr(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _loading ? null : _submit,
                icon: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.pets),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _loading ? 'adoption_form.sending'.tr() : 'adoption_form.submit'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
              AdmobBannerWidget(),
            ],
          ),
        ),
      ),
    );
  }
} 