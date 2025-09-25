import 'package:ecommerce/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _onRegister() async {
    if (!_form.currentState!.validate()) return;
    if (_password.text != _confirm.text) {
      _showSnack('Passwords do not match');
      return;
    }
    setState(() => _loading = true);
    final response = await AuthService.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (response.success) {
      final name = response.user?.displayName ?? _name.text.trim();
      final welcomeName = name.isNotEmpty ? name : 'Nike Member';
      _showSnack('Welcome, $welcomeName!');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(response.message ?? 'Could not register');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    InputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: w < 500 ? 16 : 0,
              vertical: 24,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Text(
                    'Create an account',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'It’s quick and easy',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Full name',
                            enabledBorder: border(Colors.grey.shade400),
                            focusedBorder: border(Colors.black),
                            errorBorder: border(Colors.redAccent),
                            focusedErrorBorder: border(Colors.redAccent),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email address',
                            enabledBorder: border(Colors.grey.shade400),
                            focusedBorder: border(Colors.black),
                            errorBorder: border(Colors.redAccent),
                            focusedErrorBorder: border(Colors.redAccent),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure1,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            enabledBorder: border(Colors.grey.shade400),
                            focusedBorder: border(Colors.black),
                            errorBorder: border(Colors.redAccent),
                            focusedErrorBorder: border(Colors.redAccent),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              tooltip: _obscure1 ? 'Show' : 'Hide',
                              icon: Icon(
                                _obscure1
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure1 = !_obscure1),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirm,
                          obscureText: _obscure2,
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            enabledBorder: border(Colors.grey.shade400),
                            focusedBorder: border(Colors.black),
                            errorBorder: border(Colors.redAccent),
                            focusedErrorBorder: border(Colors.redAccent),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              tooltip: _obscure2 ? 'Show' : 'Hide',
                              icon: Icon(
                                _obscure2
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure2 = !_obscure2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: _loading ? null : _onRegister,
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Create account',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(fontSize: 13),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: const Text('Sign in'),
                            ),
                          ],
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
    );
  }
}
