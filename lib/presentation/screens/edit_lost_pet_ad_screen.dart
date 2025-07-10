import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/lost_pet_ad_cubit.dart';
import '../../core/network/auth_service.dart';
import '../../data/models/lost_pet_ad_dto.dart';
import '../../core/helpers/city_list.dart';

class EditLostPetAdScreen extends StatefulWidget {
  final LostPetAdDto ad;
  const EditLostPetAdScreen({Key? key, required this.ad}) : super(key: key);

  @override
  State<EditLostPetAdScreen> createState() => _EditLostPetAdScreenState();
}

class _EditLostPetAdScreenState extends State<EditLostPetAdScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _petNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  String? _selectedCity;
  String? _selectedDistrict;
  DateTime? _lastSeenDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final ad = widget.ad;
    _petNameController = TextEditingController(text: ad.petName);
    _descriptionController = TextEditingController(text: ad.description);
    _imageUrlController = TextEditingController(text: ad.imageUrl);
    _selectedCity = ad.lastSeenCity;
    _selectedDistrict = ad.lastSeenDistrict;
    _lastSeenDate = ad.lastSeenDate;
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final user = await authService.getUser();
      if (token == null || user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı oturumu bulunamadı.')),
        );
        setState(() => _isLoading = false);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return;
      }
      final dto = LostPetAdDto(
        id: widget.ad.id,
        petName: _petNameController.text,
        description: _descriptionController.text,
        lastSeenDate: _lastSeenDate ?? DateTime.now(),
        imageUrl: _imageUrlController.text,
        userId: user['id'] ?? 0,
        lastSeenCity: _selectedCity ?? '',
        lastSeenDistrict: _selectedDistrict ?? '',
        createdAt: widget.ad.createdAt,
        userName: user['username'] ?? '',
      );
      await context.read<LostPetAdCubit>().update(widget.ad.id, dto, token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıp ilanı başarıyla güncellendi.'), backgroundColor: Colors.green),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İlan güncellenemedi: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final districts = _selectedCity != null ? CityList.getDistrictsByCity(_selectedCity!) : <String>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıp Hayvan İlanı Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Row(
                children: [
                  Icon(Icons.edit, size: 36, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Text('Kayıp Hayvan İlanı Düzenle', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Kayıp ilanı bilgilerini güncelleyin.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 18),
              if (_imageUrlController.text.isNotEmpty)
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
                                  child: Image.network(
                                    _imageUrlController.text,
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
                  Text('Hayvan Bilgileri', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _petNameController,
                decoration: const InputDecoration(labelText: 'Hayvan Adı'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                minLines: 2,
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              const SizedBox(height: 18),
              // Son Görülme Bilgileri
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.teal, size: 20),
                  const SizedBox(width: 8),
                  Text('Son Görülme', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
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
                      decoration: const InputDecoration(labelText: 'Şehir'),
                      validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
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
                      decoration: const InputDecoration(labelText: 'İlçe'),
                      validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
                      disabledHint: const Text('Önce şehir seçin'),
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
                  decoration: const InputDecoration(labelText: 'Son Görülme Tarihi'),
                  child: Text(
                    _lastSeenDate != null
                        ? DateFormat('yyyy-MM-dd').format(_lastSeenDate!)
                        : 'Tarih seç',
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
                  Text('Görsel', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Resim URL'),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Zorunlu';
                  final uri = Uri.tryParse(v);
                  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
                    return 'Geçerli bir URL girin';
                  }
                  return null;
                },
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
                      onPressed: _isLoading ? null : submit,
                      label: _isLoading
                          ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Kaydet'),
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