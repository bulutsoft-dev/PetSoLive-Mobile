import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/account_cubit.dart';
import '../../data/models/veterinarian_dto.dart';
import '../../data/providers/veterinarian_api_service.dart';
import '../../injection_container.dart';
import '../partials/base_app_bar.dart';
import 'login_screen.dart';

class VeterinarianApplicationScreen extends StatefulWidget {
  const VeterinarianApplicationScreen({Key? key}) : super(key: key);

  @override
  State<VeterinarianApplicationScreen> createState() => _VeterinarianApplicationScreenState();
}

class _VeterinarianApplicationScreenState extends State<VeterinarianApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qualificationsController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _clinicPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _qualificationsController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accountState = context.read<AccountCubit>().state;
    if (accountState is! AccountSuccess) {
      // Kullanıcı login değilse login ekranına yönlendir
      Future.microtask(() {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final accountState = context.read<AccountCubit>().state;
    if (accountState is! AccountSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile.login_required'.tr()), backgroundColor: Colors.red),
      );
      setState(() => _isLoading = false);
      return;
    }
    final user = accountState.response.user;
    final token = accountState.response.token;
    final dto = VeterinarianDto(
      id: 0,
      userId: user.id,
      userName: user.username,
      qualifications: _qualificationsController.text.trim(),
      clinicAddress: _clinicAddressController.text.trim(),
      clinicPhoneNumber: _clinicPhoneController.text.trim(),
      appliedDate: DateTime.now(),
      status: 'Pending',
    );
    try {
      await VeterinarianApiService().register(dto, token);
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('profile.veterinarian_apply_success'.tr()), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile.veterinarian_apply_error'.tr(args: [e.toString()])), backgroundColor: Colors.red),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: BaseAppBar(
        title: 'profile.veterinarian_apply_title'.tr(),
        showLogo: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _qualificationsController,
                enabled: !_isLoading,
                decoration: InputDecoration(labelText: 'profile.qualifications'.tr(), prefixIcon: Icon(Icons.school)),
                validator: (v) => v == null || v.isEmpty ? 'profile.qualifications_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clinicAddressController,
                enabled: !_isLoading,
                decoration: InputDecoration(labelText: 'profile.clinic_address'.tr(), prefixIcon: Icon(Icons.location_on)),
                validator: (v) => v == null || v.isEmpty ? 'profile.clinic_address_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clinicPhoneController,
                enabled: !_isLoading,
                decoration: InputDecoration(labelText: 'profile.clinic_phone'.tr(), prefixIcon: Icon(Icons.phone)),
                validator: (v) => v == null || v.isEmpty ? 'profile.clinic_phone_required'.tr() : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text('form.cancel'.tr()),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                              const SizedBox(width: 10),
                              Text('profile.veterinarian_apply_loading'.tr()),
                            ],
                          )
                        : Text('form.save'.tr()),
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