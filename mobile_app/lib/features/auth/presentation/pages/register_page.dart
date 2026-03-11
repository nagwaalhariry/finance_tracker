import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required this.initialMode, super.key});

  final AuthEntryMode initialMode;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = false;

  @override
  void initState() {
    super.initState();
    _isLoginMode = widget.initialMode == AuthEntryMode.login;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.error && state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage!)),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isLoginMode ? 'Welcome back' : 'Create account',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter email';
                          }
                          if (!value.contains('@')) return 'Enter valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 chars';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() != true) return;
                                if (_isLoginMode) {
                                  context.read<AuthCubit>().login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                } else {
                                  context.read<AuthCubit>().register(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                }
                              },
                        child: state.status == AuthStatus.loading
                            ? const CircularProgressIndicator()
                            : Text(_isLoginMode ? 'Login' : 'Register'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () => setState(() => _isLoginMode = !_isLoginMode),
                        child: Text(
                          _isLoginMode
                              ? "Don't have an account? Register"
                              : 'Already have an account? Login',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
