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
import '../widgets/image_upload_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  DateTime? _lastSeenDate;
  bool _isLoading = false;
  String? _selectedCity;
  String? _selectedDistrict;
  File? _selectedImage;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir resim seçin!')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final user = await authService.getUser();
      if (token == null || user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('lost_pet_ad.form_login_required'.tr())),
        );
        setState(() => _isLoading = false);
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      var uri = Uri.parse('https://petsolive-api.onrender.com/api/LostPetAd');
      var request = http.MultipartRequest('POST', uri);
      request.fields['petName'] = _petNameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['lastSeenDate'] = _lastSeenDate?.toIso8601String() ?? '';
      request.fields['lastSeenCity'] = _selectedCity ?? '';
      request.fields['lastSeenDistrict'] = _selectedDistrict ?? '';
      request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['x-api-key'] = 'YOUR_SECRET_API_KEY'; // Replace with your actual API key
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        print('Başarılı: $respStr');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('lost_pet_ad.add_success'.tr()), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true);
      } else {
        final respStr = await response.stream.bytesToString();
        print('Hata: ${response.statusCode} $respStr');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('lost_pet_ad.form_failed'.tr(args: [respStr])), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Hata: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('lost_pet_ad.form_failed'.tr(args: [e.toString()])), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              if (_selectedImage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 300,
                                      height: 300,
                                      color: Colors.grey[200],
                                      child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      Future.microtask(() => Navigator.of(ctx).pop());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(Icons.close, color: Colors.white, size: 28),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _selectedImage!,
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
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.zoom_in, color: Colors.white, size: 22),
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
              // Görsel
              Row(
                children: [
                  Icon(Icons.image, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text('lost_pet_ad.form_image'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 8),
              // Resim Yükleme
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Resim Seç'),
              ),
              if (_selectedImage != null)
                Image.file(_selectedImage!, width: 100, height: 100),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController, // This controller is no longer used for imageUrl
                decoration: InputDecoration(labelText: 'lost_pet_ad.form_city'.tr()),
                validator: (v) => v == null || v.isEmpty ? 'lost_pet_ad.form_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _districtController, // This controller is no longer used for imageUrl
                decoration: InputDecoration(labelText: 'lost_pet_ad.form_district'.tr()),
                validator: (v) => v == null || v.isEmpty ? 'lost_pet_ad.form_required'.tr() : null,
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
                      onPressed: _isLoading ? null : _submitForm,
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