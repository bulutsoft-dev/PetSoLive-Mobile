import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/pet_dto.dart';
import '../../data/providers/pet_api_service.dart';
import '../../data/local/session_manager.dart';
import '../partials/base_app_bar.dart';
import '../../core/constants/admob_banner_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_upload_button.dart'; // Added import for ImageUploadButton

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
  bool? _isNeutered;
  bool _isLoading = false;
  File? _selectedImage;
  String? _uploadedImageUrl; // Add this for uploaded image url
  final picker = ImagePicker();

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
    _uploadedImageUrl = pet.imageUrl; // Initialize with existing image url
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
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken() ?? '';
    try {
      if (_selectedImage != null) {
        await PetApiService().updatePetMultipart(
          id: widget.pet.id,
          name: _nameController.text,
          species: _speciesController.text,
          breed: _breedController.text,
          age: int.tryParse(_ageController.text) ?? 0,
          gender: _selectedGender ?? '',
          weight: double.tryParse(_weightController.text) ?? 0,
          color: _colorController.text,
          dateOfBirth: _selectedDate ?? DateTime.now(),
          description: _descriptionController.text,
          microchipId: _microchipIdController.text,
          vaccinationStatus: _vaccinationStatusController.text,
          isNeutered: _isNeutered,
          imageFile: _selectedImage!,
          token: token,
        );
      } else {
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
          imageUrl: _uploadedImageUrl ?? '', // Use uploaded image url
        );
        final response = await PetApiService().updateWithResponse(widget.pet.id, updatedPet, token);
        if (response != 200 && response != 204) {
          throw Exception('Status: ' + response.toString());
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('edit_pet.success'.tr()),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('form.error'.tr(args: [e.toString()])),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: BaseAppBar(
        title: 'pet_detail.edit'.tr(),
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
              // Pet image preview at the top (like AddPetScreen), larger and with zoom icon
              if (_selectedImage != null)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: Center(
                              child: Image.file(_selectedImage!, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_selectedImage!, width: 180, height: 180, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.zoom_in, color: Colors.white, size: 28),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: Center(
                              child: Image.network(_uploadedImageUrl!, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(_uploadedImageUrl!, width: 180, height: 180, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.zoom_in, color: Colors.white, size: 28),
                          ),
                        ),
                      ],
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
              // Görsel yükle butonu en altta, preview kaldırıldı
              const SizedBox(height: 28),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ImageUploadButton(
                    label: 'pets.image_url'.tr(),
                    initialUrl: _uploadedImageUrl,
                    onImageUploaded: (url) {
                      setState(() {
                        _uploadedImageUrl = url;
                      });
                    },
                  ),
                ),
              ),
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
              AdmobBannerWidget(),
            ],
          ),
        ),
      ),
    );
  }
} 