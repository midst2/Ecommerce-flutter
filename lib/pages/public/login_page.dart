import 'package:ecommerce/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _keepMe = true;
  bool _loading = false;
  bool _obscure = true;
  bool _socialLoading = false;

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _onLogin() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final response = await AuthService.login(
      email: _email.text.trim(),
      password: _password.text,
      keepMe: _keepMe,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (response.success) {
      final name = response.user?.displayName;
      final message = (name != null && name.isNotEmpty)
          ? 'Welcome back, $name!'
          : 'Welcome back!';
      _showSnack(message);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(response.message ?? 'Unable to sign in.');
    }
  }

  Future<void> _onGoogle() async {
    setState(() => _socialLoading = true);
    final response = await AuthService.signInWithGoogle();
    setState(() => _socialLoading = false);
    if (!mounted) return;
    if (response.success) {
      final email = response.user?.email;
      final name = response.user?.displayName;
      final who = (name != null && name.isNotEmpty)
          ? name
          : (email != null && email.isNotEmpty ? email : 'Google user');
      _showSnack('Signed in as $who');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(response.message ?? 'Google sign-in failed');
    }
  }

  Future<void> _onFacebook() async {
    setState(() => _socialLoading = true);
    final response = await AuthService.signInWithFacebook();
    setState(() => _socialLoading = false);
    if (!mounted) return;
    if (response.success) {
      final email = response.user?.email;
      final name = response.user?.displayName;
      final who = (name != null && name.isNotEmpty)
          ? name
          : (email != null && email.isNotEmpty ? email : 'Facebook user');
      _showSnack('Signed in as $who');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(response.message ?? 'Facebook sign-in failed');
    }
  }

  Future<void> _onApple() async {
    setState(() => _socialLoading = true);
    final response = await AuthService.signInWithApple();
    setState(() => _socialLoading = false);
    if (!mounted) return;
    if (response.success) {
      final email = response.user?.email;
      final name = response.user?.displayName;
      final who = (name != null && name.isNotEmpty)
          ? name
          : (email != null && email.isNotEmpty ? email : 'Apple user');
      _showSnack('Signed in as $who');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(response.message ?? 'Apple sign-in failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);
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
                    'Sign in',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use your email and password',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
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
                          obscureText: _obscure,
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
                              tooltip: _obscure ? 'Show' : 'Hide',
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: _keepMe,
                              onChanged: (v) =>
                                  setState(() => _keepMe = v ?? true),
                            ),
                            const Text(
                              'Keep me signed in',
                              style: TextStyle(fontSize: 13),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => _showSnack('Not implemented'),
                              child: const Text('Forgot password?'),
                            ),
                          ],
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
                            onPressed: _loading ? null : _onLogin,
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
                                    'Sign in',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('or'),
                            ),
                            Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _socialLoading ? null : _onGoogle,
                                icon: const Icon(Icons.g_mobiledata),
                                label: _socialLoading
                                    ? const Text('Signing in...')
                                    : const Text('Continue with Google'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _socialLoading ? null : _onFacebook,
                                icon: const Icon(Icons.facebook),
                                label: _socialLoading
                                    ? const Text('Signing in...')
                                    : const Text('Continue with Facebook'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _socialLoading ? null : _onApple,
                                icon: const Icon(Icons.apple),
                                label: _socialLoading
                                    ? const Text('Signing in...')
                                    : const Text('Continue with Apple'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New here?',
                              style: TextStyle(fontSize: 13),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: const Text('Create an account'),
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
