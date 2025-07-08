import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../../data/models/pet_dto.dart';
import '../../data/local/session_manager.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();
  DateTime? _selectedDate;
  final _descriptionController = TextEditingController();
  final _vaccinationStatusController = TextEditingController();
  final _microchipIdController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool? _isNeutered = false;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Erkek', 'Dişi'];
  final List<String> _speciesOptions = ['Köpek', 'Kedi', 'Kuş', 'Diğer...'];
  bool _customSpecies = false;

  Future<List<String>> fetchSpeciesList() async {
    // Burada gerçek API çağrısı yapılabilir
    await Future.delayed(const Duration(milliseconds: 300));
    // Örnek veri, API'dan geliyormuş gibi
    return ['Köpek', 'Kedi', 'Kuş', 'Hamster', 'Balık', 'Diğer...'];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('pets.add'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  Icon(Icons.pets, size: 48, color: colorScheme.primary),
                  const SizedBox(height: 8),
                  Text('Hayvan Ekle', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('pets.add_subtitle'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
                ],
              ),
              const SizedBox(height: 24),
              // Görsel önizleme
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
              // Temel bilgiler
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
                    child: Column(
                      children: [
                        // Tür alanı sadece TextField olacak
                        TextFormField(
                          controller: _speciesController,
                          decoration: InputDecoration(labelText: 'pets.species'.tr()),
                          validator: (v) => v == null || v.isEmpty ? 'form.required'.tr() : null,
                        ),
                      ],
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
                      items: _genderOptions.map((g) => DropdownMenuItem(value: g, child: Text('pets.gender_$g'.tr()))).toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                      decoration: InputDecoration(labelText: 'pets.gender'.tr()),
                      validator: (v) => (v == null || v.isEmpty) ? 'form.required'.tr() : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                            color: _selectedDate != null
                                ? Colors.black
                                : Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Sağlık ve açıklama
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
              TextFormField(
                controller: _microchipIdController,
                decoration: InputDecoration(labelText: 'pets.microchip_id'.tr()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'pets.description'.tr()),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'pets.image_url'.tr()),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => _isLoading = true);
                    final pet = PetDto(
                      id: 0,
                      name: _nameController.text,
                      species: _speciesController.text,
                      breed: _breedController.text,
                      age: int.tryParse(_ageController.text) ?? 0,
                      gender: _selectedGender ?? '',
                      weight: double.tryParse(_weightController.text) ?? 0,
                      color: _colorController.text,
                      dateOfBirth: _selectedDate?.toUtc() ?? DateTime.now().toUtc(),
                      description: _descriptionController.text,
                      vaccinationStatus: _vaccinationStatusController.text,
                      microchipId: _microchipIdController.text,
                      isNeutered: _isNeutered,
                      imageUrl: _imageUrlController.text,
                    );
                    final sessionManager = SessionManager();
                    final token = await sessionManager.getToken() ?? '';
                    try {
                      await context.read<PetCubit>().create(pet, token);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('pets.add_success'.tr())),
                      );
                      await Future.delayed(const Duration(milliseconds: 800));
                      Navigator.of(context).pop();
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('form.error'.tr(args: [e.toString()]))),
                      );
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  }
                },
                label: _isLoading ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('form.save'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 