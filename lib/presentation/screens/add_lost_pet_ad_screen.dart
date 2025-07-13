import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/lost_pet_ad_cubit.dart';
import '../../core/network/auth_service.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../../core/helpers/city_list.dart';
import '../partials/base_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/admob_banner_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../data/providers/image_upload_provider.dart';
import '../../data/providers/lost_pet_ad_api_service.dart';

class AddLostPetAdScreen extends StatefulWidget {
  const AddLostPetAdScreen({Key? key}) : super(key: key);

  @override
  State<AddLostPetAdScreen> createState() => _AddLostPetAdScreenState();
}

class _AddLostPetAdScreenState extends State<AddLostPetAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _imageUrlController = TextEditingController();
  DateTime? _lastSeenDate;
  bool _isLoading = false;
  String? _selectedCity;
  String? _selectedDistrict;
  File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;

  Future<void> submit() async {
    debugPrint('[LOST PET AD] submit() çağrıldı');
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImageFile == null || _uploadedImageUrl == null) {
      debugPrint('[LOST PET AD] Resim yüklenmemiş, işlem iptal.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir resim yükleyin!')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final user = await authService.getUser();
      debugPrint('[LOST PET AD] Token: ' + (token ?? 'null'));
      debugPrint('[LOST PET AD] User: ' + (user != null ? user.toString() : 'null'));
      if (token == null || user == null) {
        debugPrint('[LOST PET AD] Kullanıcı veya token yok, login yönlendirmesi.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('lost_pet_ad.form_login_required'.tr())),
        );
        setState(() => _isLoading = false);
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      final dto = LostPetAdDto(
        id: 0,
        petName: _petNameController.text,
        description: _descriptionController.text,
        lastSeenDate: _lastSeenDate ?? DateTime.now(),
        imageUrl: _uploadedImageUrl!,
        userId: user['id'] ?? 0,
        lastSeenCity: _selectedCity ?? '',
        lastSeenDistrict: _selectedDistrict ?? '',
        createdAt: DateTime.now(),
        userName: user['username'] ?? '',
      );
      debugPrint('[LOST PET AD] DTO: ' + dto.toJson().toString());
      await LostPetAdApiService().createMultipart(dto, token, _selectedImageFile!, _uploadedImageUrl!);
      debugPrint('[LOST PET AD] createMultipart çağrısı tamamlandı.');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('lost_pet_ad.add_success'.tr()), backgroundColor: Colors.green),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('[LOST PET AD] Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('lost_pet_ad.form_failed'.tr(args: [e.toString()])), backgroundColor: Colors.red),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    debugPrint('[LOST PET AD] _pickAndUploadImage() çağrıldı');
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _isUploadingImage = true;
      });
      try {
        debugPrint('[LOST PET AD] Resim seçildi, upload başlıyor: ' + pickedFile.path);
        final url = await ImageUploadProvider.uploadToImgbb(_selectedImageFile!);
        debugPrint('[LOST PET AD] Resim upload tamamlandı, url: $url');
        setState(() {
          _uploadedImageUrl = url;
          _isUploadingImage = false;
        });
      } catch (e) {
        debugPrint('[LOST PET AD] Resim upload hatası: $e');
        setState(() => _isUploadingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim yüklenemedi: $e')),
        );
      }
    } else {
      debugPrint('[LOST PET AD] Resim seçilmedi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final districts = _selectedCity != null ? CityList.getDistrictsByCity(_selectedCity!) : <String>[];
    return Scaffold(
      appBar: BaseAppBar(
        title: 'lost_pet_ad.add_title'.tr(),
        showLogo: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              // Görsel seçme alanı EN ÜSTTE
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: GestureDetector(
                    onTap: _isUploadingImage ? null : _pickAndUploadImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _selectedImageFile != null
                              ? Image.file(_selectedImageFile!, width: 120, height: 120, fit: BoxFit.cover)
                              : (_uploadedImageUrl != null
                                  ? Image.network(_uploadedImageUrl!, width: 120, height: 120, fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        width: 120,
                                        height: 120,
                                        color: Colors.grey[200],
                                        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[400]),
                                      ),
                                    )
                                  : Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                                    )),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: _isUploadingImage
                                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Icon(Icons.camera_alt, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Temel Bilgiler
              Row(
                children: [
                  Icon(Icons.pets, color: Colors.indigo, size: 20),
                  const SizedBox(width: 8),
                  Text('lost_pet_ad.form_pet_info'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _petNameController,
                decoration: InputDecoration(labelText: 'lost_pet_ad.form_pet_name'.tr()),
                validator: (v) => v == null || v.isEmpty ? 'lost_pet_ad.form_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'lost_pet_ad.form_description'.tr()),
                minLines: 2,
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'lost_pet_ad.form_required'.tr() : null,
              ),
              const SizedBox(height: 18),
              // Son Görülme Bilgileri
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.teal, size: 20),
                  const SizedBox(width: 8),
                  Text('lost_pet_ad.form_last_seen'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedCity,
                      items: CityList.cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedCity = v;
                          _selectedDistrict = null;
                        });
                      },
                      decoration: InputDecoration(labelText: 'lost_pet_ad.form_city'.tr()),
                      validator: (v) => v == null || v.isEmpty ? 'lost_pet_ad.form_required'.tr() : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedDistrict,
                      items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: _selectedCity == null
                          ? null
                          : (v) => setState(() => _selectedDistrict = v),
                      decoration: InputDecoration(labelText: 'lost_pet_ad.form_district'.tr()),
                      validator: (v) => v == null || v.isEmpty ? 'lost_pet_ad.form_required'.tr() : null,
                      disabledHint: Text('lost_pet_ad.form_city'.tr()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _lastSeenDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _lastSeenDate = picked);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(labelText: 'lost_pet_ad.form_date'.tr()),
                  child: Text(
                    _lastSeenDate != null
                        ? DateFormat('yyyy-MM-dd').format(_lastSeenDate!)
                        : 'lost_pet_ad.form_select_date'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
                      onPressed: _isLoading ? null : submit,
                      label: _isLoading
                          ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('lost_pet_ad.form_save'.tr()),
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