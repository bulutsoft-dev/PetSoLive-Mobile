import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_dto.dart';
import '../blocs/account_cubit.dart';
import '../../main.dart';
import 'package:intl/intl.dart';
import '../../core/helpers/city_list.dart';
import 'package:petsolive/presentation/screens/login_screen.dart';
import '../../injection_container.dart';

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
  final _profileImageUrlController = TextEditingController();
  bool _obscurePassword = true;

  DateTime? _selectedDate;

  String? _selectedCity;
  String? _selectedDistrict;

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCity == null || _selectedDistrict == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen şehir ve ilçe seçiniz.')),
        );
        return;
      }
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen doğum tarihi seçiniz.')),
        );
        return;
      }
      try {
        final dto = RegisterDto(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          dateOfBirth: _selectedDate!,
          city: _selectedCity!,
          district: _selectedDistrict!,
          profileImageUrl: _profileImageUrlController.text.isNotEmpty
              ? _profileImageUrlController.text.trim()
              : 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.freepik.com%2Ffree-icon%2Fuser_318-804790.jpg&f=1&nofb=1&ipt=5936ab431b7527eb5f5e20fc8c26d918ebeea72414e3fa5b59a57ea07459717f',
        );
        context.read<AccountCubit>().register(dto);
      } catch (e, stack) {
        debugPrint('Register Hatası: $e');
        debugPrintStack(stackTrace: stack);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt sırasında hata oluştu: $e')),
        );
      }
    }
  }

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
                    'Kayıt Ol',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PetSoLive’a katıl, topluluğumuza güç ver!',
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
                              children: const [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Kayıt başarılı, giriş yapıldı!'),
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
                                Expanded(child: Text(state.message ?? 'Kayıt başarılı! Giriş yapabilirsiniz.')),
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
                                Expanded(child: Text(state.error)),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Kullanıcı Adı',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'Kullanıcı adı zorunlu' : null,
                                  autofillHints: const [AutofillHints.username],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'E-posta',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  validator: (value) => value == null || !value.contains('@') ? 'Geçerli e-posta girin' : null,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Şifre',
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  obscureText: _obscurePassword,
                                  validator: (value) => value == null || value.length < 6 ? 'En az 6 karakterli şifre girin' : null,
                                  autofillHints: const [AutofillHints.password],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Telefon',
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  validator: (value) => value == null || value.length < 10 ? 'Telefon numarası zorunlu' : null,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: const [AutofillHints.telephoneNumber],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    labelText: 'Adres',
                                    prefixIcon: Icon(Icons.home),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'Adres zorunlu' : null,
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
                                  decoration: const InputDecoration(
                                    labelText: 'Şehir',
                                    prefixIcon: Icon(Icons.location_city),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'Şehir zorunlu' : null,
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
                                  decoration: const InputDecoration(
                                    labelText: 'İlçe',
                                    prefixIcon: Icon(Icons.map),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'İlçe zorunlu' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _dateOfBirthController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Doğum Tarihi',
                                    prefixIcon: const Icon(Icons.cake),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: _pickDate,
                                    ),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'Doğum tarihi zorunlu' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _profileImageUrlController,
                                  decoration: const InputDecoration(
                                    labelText: 'Profil Fotoğrafı (opsiyonel)',
                                    prefixIcon: Icon(Icons.image),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _onRegisterPressed,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('Kayıt Ol'),
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
                                    child: const Text('Zaten hesabım var'),
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
                    '© 2025 PetSoLive & Bulutsoft',
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