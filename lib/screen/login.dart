import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../widgets/translated_text.dart';
import 'package:eldercare/provider/auth_provider.dart';
import 'package:eldercare/provider/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isBiometricLoading = false;
  bool _biometricAvailable = false;

  String _emailHintText = 'Email or Phone';
  String _passwordHintText = 'Password';
  String _emailValidatorText = 'Please enter your email or phone number';
  String _passwordValidatorText = 'Please enter your password';

  Locale? _previousLocale;

  static const primaryColor = Color(0xFF2E8B8B);
  static const backgroundColor = Color(0xFFF4F9F9);
  static const textDark = Color(0xFF1F2937);
  static const textLight = Color(0xFF6B7280);
  static const dangerColor = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _biometricAvailable = canCheck && isDeviceSupported;
        });
      }
    } catch (e) {
      debugPrint('Biometric check error: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Provider.of<LanguageProvider>(context).currentLocale;
    if (currentLocale != _previousLocale) {
      _previousLocale = currentLocale;
      _translateAll();
    }
  }

  Future<void> _translateAll() async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final translations = await Future.wait([
      langProvider.translate('Please enter your email or phone number'),
      langProvider.translate('Please enter your password'),
      langProvider.translate('Email or Phone'),
      langProvider.translate('Password'),
    ]);
    if (mounted) {
      setState(() {
        _emailValidatorText = translations[0];
        _passwordValidatorText = translations[1];
        _emailHintText = translations[2];
        _passwordHintText = translations[3];
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Fingerprint Login ──────────────────────────────────
  Future<void> _handleBiometricLogin() async {
    setState(() => _isBiometricLoading = true);
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && mounted) {
        // Biometric passed — try auto-login with saved credentials
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.biometricLogin();

        if (mounted) {
          if (success) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: dangerColor,
                content: TranslatedText('No saved credentials. Please login with email first.'),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: dangerColor,
            content: TranslatedText('Biometric authentication failed: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBiometricLoading = false);
    }
  }

  // ── Google Login ───────────────────────────────────────
  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled
        setState(() => _isGoogleLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null && mounted) {
        // Sync with your AuthProvider
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.syncGoogleUser(userCredential.user!);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: dangerColor,
            content: TranslatedText('Google Sign-In failed. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // ── Email Login ────────────────────────────────────────
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: dangerColor,
              content: TranslatedText(
                authProvider.errorMessage ?? 'Login Failed',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Logo
                Center(
                  child: Image.asset('assets/eldercare.png', height: 110),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: TranslatedText(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Center(
                  child: TranslatedText(
                    'Login to continue your care journey',
                    style: TextStyle(fontSize: 16, color: textLight),
                  ),
                ),

                const SizedBox(height: 40),

                // Email Field
                _buildInputField(
                  label: 'Email or Phone',
                  controller: _emailController,
                  icon: Icons.person,
                  validatorText: _emailValidatorText,
                  hintText: _emailHintText,
                ),

                const SizedBox(height: 25),

                // Password Field
                _buildInputField(
                  label: 'Password',
                  controller: _passwordController,
                  icon: Icons.lock,
                  obscure: _obscurePassword,
                  validatorText: _passwordValidatorText,
                  hintText: _passwordHintText,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: textLight,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                const SizedBox(height: 20),

                // Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: primaryColor,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value!),
                    ),
                    const TranslatedText(
                      'Remember Me',
                      style: TextStyle(fontSize: 16, color: textDark),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const TranslatedText(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── OR divider ─────────────────────────
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR',
                          style: TextStyle(color: textLight, fontSize: 14)),
                    ),
                    Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Google + Fingerprint buttons ───────
                Row(
                  children: [
                    // Google Sign-In
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: _isGoogleLoading ? null : _handleGoogleLogin,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          icon: _isGoogleLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: primaryColor),
                                )
                              : Image.asset(
                                  'assets/google_logo.png',
                                  height: 24,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.g_mobiledata,
                                    size: 28,
                                    color: Color(0xFF4285F4),
                                  ),
                                ),
                          label: const Text(
                            'Google',
                            style: TextStyle(
                              fontSize: 16,
                              color: textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Fingerprint
                    if (_biometricAvailable)
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: _isBiometricLoading
                                ? null
                                : _handleBiometricLogin,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFD1D5DB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            icon: _isBiometricLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: primaryColor),
                                  )
                                : const Icon(
                                    Icons.fingerprint,
                                    size: 28,
                                    color: primaryColor,
                                  ),
                            label: const TranslatedText(
                              'Fingerprint',
                              style: TextStyle(
                                fontSize: 16,
                                color: textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Forgot Password
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const TranslatedText(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TranslatedText(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: textLight),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/signup'),
                      child: const TranslatedText(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String validatorText,
    required String hintText,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 18, color: textDark),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: primaryColor),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            return null;
          },
        ),
      ],
    );
  }
}
