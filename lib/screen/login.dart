import 'package:flutter/material.dart';
import 'package:eldercare/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                _buildLogo(),
                SizedBox(height: 20),
                _buildWelcomeText(l10n),
                SizedBox(height: 32),
                _buildEmailField(l10n),
                SizedBox(height: 20),
                _buildPasswordField(l10n),
                SizedBox(height: 16),
                _buildRememberMeAndForgotPassword(l10n),
                SizedBox(height: 24),
                _buildLoginButton(l10n),
                SizedBox(height: 20),
                _buildBiometricButton(l10n),
                SizedBox(height: 16),
                _buildDivider(),
                SizedBox(height: 16),
                _buildGoogleLoginButton(l10n),
                SizedBox(height: 24),
                _buildSignUpLink(l10n),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        child: Image.asset('assets/eldercare.png'),
      ),
    );
  }

  Widget _buildWelcomeText(AppLocalizations l10n) {
    return Column(
      children: [
        Center(
          child: Text(
            l10n.welcomeBack,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            l10n.loginToYourAccount,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.emailOrPhone,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
            decoration: InputDecoration(
              hintText: l10n.emailOrPhone,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
              prefixIcon: Icon(Icons.person, size: 24, color: Color(0xFF4A90E2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterEmail;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.password,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
            decoration: InputDecoration(
              hintText: l10n.password,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
              prefixIcon: Icon(Icons.lock, size: 24, color: Color(0xFF4A90E2)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                  color: Color(0xFF7F8C8D),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterPassword;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
                activeColor: Color(0xFF4A90E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              l10n.rememberMe,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            l10n.forgotPassword,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4A90E2),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.loginSuccessful),
                backgroundColor: Color(0xFF50C878),
              ),
            );
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacementNamed(context, '/home');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          l10n.login,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton(AppLocalizations l10n) {
    return Container(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.fingerprint, size: 28, color: Color(0xFF4A90E2)),
        label: Text(
          l10n.loginWithFingerprint,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A90E2),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF4A90E2), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Color(0xFF7F8C8D),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton(AppLocalizations l10n) {
    return Container(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.g_mobiledata, size: 28, color: Color(0xFF2C3E50)),
        label: Text(
          l10n.continueWithGoogle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFE0E0E0), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: Text(
            l10n.signUp,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
        ),
      ],
    );
  }
}
