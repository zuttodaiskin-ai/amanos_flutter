import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class MfaPage extends StatefulWidget {
  final int userId;

  const MfaPage({super.key, required this.userId});

  @override
  State<MfaPage> createState() => _MfaPageState();
}

class _MfaPageState extends State<MfaPage> {
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 70,
                      color: theme.colorScheme.primary,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'التحقق بخطوتين',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'أدخل رمز التحقق الذي تم إرساله إليك',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 35),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('رمز التحقق'),

                          const SizedBox(height: 8),

                          TextField(
                            controller: codeController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              hintText: '------',
                              counterText: '',
                              prefixIcon: Icon(Icons.lock_clock_outlined),
                            ),
                          ),

                          const SizedBox(height: 25),

                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state is MfaVerificationFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }

                              if (state is MfaVerificationSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم تسجيل الدخول بنجاح'),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is MfaVerificationLoading) {
                                return const SizedBox(
                                  height: 52,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return ElevatedButton(
                                onPressed: () {
                                  context.read<LoginCubit>().verifyMfa(
                                    userId: widget.userId,
                                    code: codeController.text.trim(),
                                  );
                                },
                                child: const Text(
                                  'تحقق',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('العودة إلى تسجيل الدخول'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
