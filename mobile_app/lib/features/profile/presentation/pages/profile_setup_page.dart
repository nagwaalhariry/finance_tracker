import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_button.dart';
import '../cubit/user_profile_cubit.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  String _currency = 'USD';
  bool _isEditing = false;
  bool _submitted = false;

  static const _currencies = ['USD', 'EUR', 'EGP', 'SAR', 'AED', 'GBP'];

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<UserProfileCubit>().state.profile;
    if (profile != null && _salaryController.text.isEmpty) {
      _salaryController.text = profile.monthlySalary.toStringAsFixed(2);
      _currency = profile.currency;
      _isEditing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingProfile = context.watch<UserProfileCubit>().state.profile;
    return Scaffold(
      appBar: AppBar(
        title: Text(existingProfile == null ? 'Setup Monthly Balance' : 'Edit Monthly Balance'),
      ),
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state.status == UserProfileStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          if (_submitted && state.status == UserProfileStatus.loaded && _isEditing) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add your monthly salary/balance and choose your preferred currency.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Monthly Salary'),
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(labelText: 'Currency'),
                    items: _currencies
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => _currency = value ?? _currency),
                  ),
                  const Spacer(),
                  AppButton(
                    label: state.status == UserProfileStatus.loading ? 'Saving...' : 'Continue',
                    icon: Icons.check_circle_outline,
                    onPressed: state.status == UserProfileStatus.loading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() != true) return;
                            final uid = FirebaseAuth.instance.currentUser?.uid;
                            if (uid == null) return;
                            _submitted = true;
                            await context.read<UserProfileCubit>().saveProfile(
                                  userId: uid,
                                  monthlySalary:
                                      double.parse(_salaryController.text.trim()),
                                  currency: _currency,
                                );
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
