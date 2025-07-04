import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/pet_cubit.dart';
import '../../data/models/pet_dto.dart';

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
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _vaccinationStatusController = TextEditingController();
  final _microchipIdController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool? _isNeutered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pets.add'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Adı'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              TextFormField(
                controller: _speciesController,
                decoration: InputDecoration(labelText: 'Türü'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Cinsi'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Yaşı'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Cinsiyeti'),
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Ağırlığı (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Rengi'),
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(labelText: 'Doğum Tarihi (YYYY-AA-GG)'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
              TextFormField(
                controller: _vaccinationStatusController,
                decoration: InputDecoration(labelText: 'Aşı Durumu'),
              ),
              TextFormField(
                controller: _microchipIdController,
                decoration: InputDecoration(labelText: 'Mikroçip ID'),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Görsel URL'),
              ),
              SwitchListTile(
                title: Text('pets.is_neutered'.tr()),
                value: _isNeutered ?? false,
                onChanged: (v) => setState(() => _isNeutered = v),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final pet = PetDto(
                      id: 0,
                      name: _nameController.text,
                      species: _speciesController.text,
                      breed: _breedController.text,
                      age: int.tryParse(_ageController.text) ?? 0,
                      gender: _genderController.text,
                      weight: double.tryParse(_weightController.text) ?? 0,
                      color: _colorController.text,
                      dateOfBirth: DateTime.tryParse(_dateOfBirthController.text) ?? DateTime.now(),
                      description: _descriptionController.text,
                      vaccinationStatus: _vaccinationStatusController.text,
                      microchipId: _microchipIdController.text,
                      isNeutered: _isNeutered,
                      imageUrl: _imageUrlController.text,
                    );
                    // TODO: Token alınmalı
                    final token = '';
                    await context.read<PetCubit>().create(pet, token);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('common.save'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 