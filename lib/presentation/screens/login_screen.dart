import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_dto.dart';
import '../blocs/account_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final dto = AuthDto(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      context.read<AccountCubit>().login(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state is AccountSuccess) {
            // Başarılı giriş, ana ekrana yönlendir
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AccountFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AccountLoading;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Şifre'),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onLoginPressed,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Giriş Yap'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 