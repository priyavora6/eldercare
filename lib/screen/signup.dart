import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/language_provider.dart';
import '../widgets/translated_text.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  DateTime? _selectedDate;
  bool _isLoading = false;

  // ── Same colors as Login ──────────────────────────────
  static const primaryColor = Color(0xFF2E8B8B);
  static const backgroundColor = Color(0xFFF4F9F9);
  static const textDark = Color(0xFF1F2937);
  static const textLight = Color(0xFF6B7280);
  static const dangerColor = Color(0xFFE53935);

  // Translated strings
  String _nameHint = 'Enter your full name';
  String _emailHint = 'Enter your email';
  String _phoneHint = 'Enter your phone number';
  String _passwordHint = 'Enter password';
  String _confirmPasswordHint = 'Re-enter password';
  String _dobHint = 'Select date of birth';
  String _nameValidator = 'Please enter your name';
  String _emailValidator = 'Please enter your email';
  String _emailValidator2 = 'Please enter a valid email';
  String _phoneValidator = 'Please enter your phone number';
  String _phoneValidator2 = 'Please enter a valid phone number';
  String _passwordValidator = 'Please enter password';
  String _passwordValidator2 = 'Password must be at least 6 characters';
  String _confirmPasswordValidator = 'Please confirm password';
  String _confirmPasswordValidator2 = 'Passwords do not match';
  Locale? _previousLocale;

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
      langProvider.translate('Enter your full name'),
      langProvider.translate('Enter your email'),
      langProvider.translate('Enter your phone number'),
      langProvider.translate('Enter password'),
      langProvider.translate('Re-enter password'),
      langProvider.translate('Select date of birth'),
      langProvider.translate('Please enter your name'),
      langProvider.translate('Please enter your email'),
      langProvider.translate('Please enter a valid email'),
      langProvider.translate('Please enter your phone number'),
      langProvider.translate('Please enter a valid phone number'),
      langProvider.translate('Please enter password'),
      langProvider.translate('Password must be at least 6 characters'),
      langProvider.translate('Please confirm password'),
      langProvider.translate('Passwords do not match'),
    ]);

    if (mounted) {
      setState(() {
        _nameHint = translations[0];
        _emailHint = translations[1];
        _phoneHint = translations[2];
        _passwordHint = translations[3];
        _confirmPasswordHint = translations[4];
        _dobHint = translations[5];
        _nameValidator = translations[6];
        _emailValidator = translations[7];
        _emailValidator2 = translations[8];
        _phoneValidator = translations[9];
        _phoneValidator2 = translations[10];
        _passwordValidator = translations[11];
        _passwordValidator2 = translations[12];
        _confirmPasswordValidator = translations[13];
        _confirmPasswordValidator2 = translations[14];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select your date of birth'),
            backgroundColor: dangerColor,
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      try {
        await Provider.of<AuthProvider>(context, listen: false).signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          userType: 'Elderly',
          dateOfBirth: _selectedDate!,
          gender: 'Other',
          profileImage: null,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Created Successfully! Please login.'),
            backgroundColor: primaryColor,
          ),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account: ${error.toString()}'),
            backgroundColor: dangerColor,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept terms & conditions'),
          backgroundColor: dangerColor,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1950),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Image.asset('assets/eldercare.png', height: 90),
                ),
                const SizedBox(height: 16),

                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Sign up to get started',
                    style: TextStyle(fontSize: 15, color: textLight),
                  ),
                ),
                const SizedBox(height: 28),

                _buildLabel('Full Name'),
                _buildTextField(
                  controller: _nameController,
                  hint: _nameHint,
                  icon: Icons.person,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? _nameValidator : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Email'),
                _buildTextField(
                  controller: _emailController,
                  hint: _emailHint,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return _emailValidator;
                    if (!v.contains('@')) return _emailValidator2;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Phone Number'),
                _buildTextField(
                  controller: _phoneController,
                  hint: _phoneHint,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return _phoneValidator;
                    if (v.length < 10) return _phoneValidator2;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Date of Birth'),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 22, color: primaryColor),
                        const SizedBox(width: 16),
                        Text(
                          _selectedDate == null
                              ? _dobHint
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedDate == null
                                ? const Color(0xFFBDC3C7)
                                : textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Password'),
                _buildPasswordField(
                  controller: _passwordController,
                  hint: _passwordHint,
                  obscureText: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) return _passwordValidator;
                    if (v.length < 6) return _passwordValidator2;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Confirm Password'),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hint: _confirmPasswordHint,
                  obscureText: _obscureConfirmPassword,
                  onToggle: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) return _confirmPasswordValidator;
                    if (v != _passwordController.text)
                      return _confirmPasswordValidator2;
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (v) => setState(() => _acceptTerms = v!),
                        activeColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'I accept the Terms & Conditions and Privacy Policy',
                        style: TextStyle(fontSize: 14, color: textDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Create Account button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 15, color: textLight),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
          prefixIcon: Icon(icon, size: 22, color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: dangerColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: dangerColor, width: 2),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, color: textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
          prefixIcon: const Icon(Icons.lock, size: 22, color: primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              size: 22,
              color: textLight,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: dangerColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: dangerColor, width: 2),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }
}