import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_dto.dart';
import '../blocs/account_cubit.dart';
import '../../main.dart';
import 'package:intl/intl.dart';
import '../../core/helpers/city_list.dart';
import 'package:petsolive/presentation/screens/login_screen.dart';
import '../../injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';
import 'package:petsolive/presentation/widgets/image_upload_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  bool _obscurePassword = true;

  DateTime? _selectedDate;

  String? _selectedCity;
  String? _selectedDistrict;

  File? _selectedImage;
  final picker = ImagePicker();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('tr'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
        SnackBar(content: Text('Lütfen bir profil fotoğrafı seçin!')),
      );
      return;
    }
    
    // Create RegisterDto with the form data
    final registerDto = RegisterDto(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      dateOfBirth: _selectedDate ?? DateTime.now(),
      city: _selectedCity ?? '',
      district: _selectedDistrict ?? '',
      profileImageUrl: null, // Will be handled by the API service
    );
    
    // Use the AccountCubit to register with image
    context.read<AccountCubit>().registerWithImage(registerDto, _selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary.withOpacity(0.12), colorScheme.secondary.withOpacity(0.10), colorScheme.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(0.13),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondary.withOpacity(0.10),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    LocaleKeys.register_title.tr(),
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.register_subtitle.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  BlocConsumer<AccountCubit, AccountState>(
                    listener: (context, state) async {
                      if (state is AccountSuccess) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(LocaleKeys.register_success.tr()),
                              ],
                            ),
                            backgroundColor: Colors.green.shade50,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        await Future.delayed(const Duration(milliseconds: 800));
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScaffold(),
                          ),
                          (route) => false,
                        );
                      } else if (state is AccountRegisterSuccess) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(child: Text(state.message ?? LocaleKeys.register_success_message.tr())),
                              ],
                            ),
                            backgroundColor: Colors.green.shade50,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        await Future.delayed(const Duration(milliseconds: 1200));
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      } else if (state is AccountFailure) {
                        debugPrint('AccountFailure: ${state.error}');
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(child: Text(state.error.tr())),
                              ],
                            ),
                            backgroundColor: Colors.red.shade50,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AccountLoading;
                      return Card(
                        elevation: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        shadowColor: colorScheme.primary.withOpacity(0.18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_username.tr(),
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? LocaleKeys.register_username_required.tr() : null,
                                  autofillHints: const [AutofillHints.username],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_email.tr(),
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  validator: (value) => value == null || !value.contains('@') ? LocaleKeys.register_email_required.tr() : null,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_password.tr(),
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  obscureText: _obscurePassword,
                                  validator: (value) => value == null || value.length < 6 ? LocaleKeys.register_password_required.tr() : null,
                                  autofillHints: const [AutofillHints.password],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_phone.tr(),
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  validator: (value) => value == null || value.length < 10 ? LocaleKeys.register_phone_required.tr() : null,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: const [AutofillHints.telephoneNumber],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_address.tr(),
                                    prefixIcon: Icon(Icons.home),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? LocaleKeys.register_address_required.tr() : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedCity,
                                  items: CityList.cities.map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  )).toList(),
                                  onChanged: (city) {
                                    setState(() {
                                      _selectedCity = city;
                                      _selectedDistrict = null;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_city.tr(),
                                    prefixIcon: Icon(Icons.location_city),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? LocaleKeys.register_city_required.tr() : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedDistrict,
                                  items: (_selectedCity != null ? CityList.getDistrictsByCity(_selectedCity!) : <String>[])
                                      .map((district) => DropdownMenuItem(
                                    value: district,
                                    child: Text(district),
                                  )).toList(),
                                  onChanged: (district) {
                                    setState(() {
                                      _selectedDistrict = district;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_district.tr(),
                                    prefixIcon: Icon(Icons.map),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? LocaleKeys.register_district_required.tr() : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _dateOfBirthController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: LocaleKeys.register_birthdate.tr(),
                                    prefixIcon: const Icon(Icons.cake),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: _pickDate,
                                    ),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? LocaleKeys.register_birthdate_required.tr() : null,
                                ),
                                const SizedBox(height: 16),
                                // Profil Resmi Yükleme
                                ElevatedButton(
                                  onPressed: _pickImage,
                                  child: Text('Profil Fotoğrafı Seç'),
                                ),
                                if (_selectedImage != null)
                                  Image.file(_selectedImage!, width: 100, height: 100),
                                const SizedBox(height: 12),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: isLoading ? CircularProgressIndicator() : Text(LocaleKeys.register_button.tr()),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    child: Text(LocaleKeys.register_already_have.tr()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    LocaleKeys.register_copyright.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.4)),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 