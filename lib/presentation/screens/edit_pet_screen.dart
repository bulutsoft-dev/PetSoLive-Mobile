import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/pet_dto.dart';
import '../../data/providers/pet_api_service.dart';
import '../../data/local/session_manager.dart';
import '../partials/base_app_bar.dart';

class EditPetScreen extends StatefulWidget {
  final PetDto pet;
  const EditPetScreen({Key? key, required this.pet}) : super(key: key);

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _speciesController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  String? _selectedGender;
  late final TextEditingController _weightController;
  late final TextEditingController _colorController;
  DateTime? _selectedDate;
  late final TextEditingController _descriptionController;
  late final TextEditingController _vaccinationStatusController;
  late final TextEditingController _microchipIdController;
  late final TextEditingController _imageUrlController;
  bool? _isNeutered;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Erkek', 'Dişi'];

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    _nameController = TextEditingController(text: pet.name);
    _speciesController = TextEditingController(text: pet.species);
    _breedController = TextEditingController(text: pet.breed);
    _ageController = TextEditingController(text: pet.age != null ? pet.age.toString() : '');
    _selectedGender = pet.gender;
    _weightController = TextEditingController(text: pet.weight != null ? pet.weight.toString() : '');
    _colorController = TextEditingController(text: pet.color ?? '');
    _selectedDate = pet.dateOfBirth;
    _descriptionController = TextEditingController(text: pet.description);
    _vaccinationStatusController = TextEditingController(text: pet.vaccinationStatus ?? '');
    _microchipIdController = TextEditingController(text: pet.microchipId ?? '');
    _isNeutered = pet.isNeutered ?? false;
    _imageUrlController = TextEditingController(text: pet.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _vaccinationStatusController.dispose();
    _microchipIdController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final updatedPet = widget.pet.copyWith(
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _selectedGender ?? '',
      weight: double.tryParse(_weightController.text) ?? 0,
      color: _colorController.text,
      dateOfBirth: _selectedDate,
      description: _descriptionController.text,
      vaccinationStatus: _vaccinationStatusController.text,
      microchipId: _microchipIdController.text,
      isNeutered: _isNeutered,
      imageUrl: _imageUrlController.text,
    );
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken() ?? '';
    try {
      await PetApiService().update(widget.pet.id, updatedPet, token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('edit_pet.success'.tr())),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('form.error'.tr(args: [e.toString()]))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'pet_detail.edit',
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
                  Icon(Icons.edit, size: 36, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Text('pet_detail.edit'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text('edit_pet.subtitle'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 18),
              if (_imageUrlController.text.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _imageUrlController.text,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                ),
              // Kimlik Bilgileri
              Row(
                children: [
                  Icon(Icons.badge, color: Colors.indigo, size: 20),
                  const SizedBox(width: 8),
                  Text('edit_pet.identity'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'pets.name'.tr()),
                      validator: (v) => v == null || v.isEmpty ? 'form.required'.tr() : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _speciesController,
                      decoration: InputDecoration(labelText: 'pets.species'.tr()),
                      validator: (v) => v == null || v.isEmpty ? 'form.required'.tr() : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _breedController,
                      decoration: InputDecoration(labelText: 'pets.breed'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: _genderOptions.map((g) => DropdownMenuItem(value: g, child: Text('pets.gender_' + g).tr())).toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                      decoration: InputDecoration(labelText: 'pets.gender'.tr()),
                      validator: (v) => (v == null || v.isEmpty) ? 'form.required'.tr() : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Fiziksel Özellikler
              Row(
                children: [
                  Icon(Icons.pets, color: Colors.teal, size: 20),
                  const SizedBox(width: 8),
                  Text('edit_pet.physical'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'pets.age'.tr()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _colorController,
                      decoration: InputDecoration(labelText: 'pets.color'.tr()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(labelText: 'pets.weight'.tr()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime(2020, 1, 1),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'pets.date_of_birth'.tr()),
                        child: Text(
                          _selectedDate != null
                              ? _selectedDate!.toIso8601String().split('T').first
                              : 'form.select'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Sağlık Bilgileri
              Row(
                children: [
                  Icon(Icons.health_and_safety, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text('edit_pet.health'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _vaccinationStatusController,
                      decoration: InputDecoration(labelText: 'pets.vaccination_status'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SwitchListTile(
                      title: Text('pets.is_neutered'.tr()),
                      value: _isNeutered ?? false,
                      onChanged: (v) => setState(() => _isNeutered = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Açıklama
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text('pets.description'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'pets.description'.tr()),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _microchipIdController,
                decoration: InputDecoration(labelText: 'pets.microchip_id'.tr()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'pets.image_url'.tr()),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _isLoading ? null : _save,
                      label: _isLoading ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('form.save'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.cancel),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      label: Text('form.cancel'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 