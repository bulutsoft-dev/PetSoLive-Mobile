import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/pet_dto.dart';
import '../../data/models/user_dto.dart';
import '../../data/models/adoption_request_dto.dart';
import '../../data/providers/adoption_request_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_cubit.dart';

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
      petName: widget.pet.name, // Düzeltildi
      userId: widget.user.id,
      userName: widget.user.username ?? '-', // Düzeltildi
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
        const SnackBar(content: Text('Oturum bulunamadı!')), // veya uygun hata mesajı
      );
      return;
    }
    final success = await api.sendAdoptionRequest(adoptionRequest, token);
    setState(() { _loading = false; });
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sahiplenme isteğiniz gönderildi!')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sahiplenme isteği gönderilemedi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sahiplenme Başvurusu')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.user.username,
                decoration: const InputDecoration(
                  labelText: 'Adı',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 14),
              TextFormField(
                initialValue: widget.user.email,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Mesaj (isteğe bağlı)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Telefon zorunlu' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (v) => v == null || v.isEmpty ? 'Adres zorunlu' : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate != null
                        ? 'Doğum Tarihi: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}'
                        : 'Doğum Tarihi seçilmedi'),
                  ),
                  TextButton(
                    onPressed: () async {
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
                    child: const Text('Tarih Seç'),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Başvuruyu Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 