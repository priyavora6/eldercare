import 'package:flutter/material.dart';

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
                _buildWelcomeText(),
                SizedBox(height: 32),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 16),
                _buildRememberMeAndForgotPassword(),
                SizedBox(height: 24),
                _buildLoginButton(),
                SizedBox(height: 20),
                _buildBiometricButton(),
                SizedBox(height: 16),
                _buildDivider(),
                SizedBox(height: 16),
                _buildGoogleLoginButton(),
                SizedBox(height: 24),
                _buildSignUpLink(),
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

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Center(
          child: Text(
            'Welcome Back',
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
            'Login to your account',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email or Phone',
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
              hintText: 'Enter email or phone number',
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
              prefixIcon: Icon(Icons.person, size: 24, color: Color(0xFF4A90E2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE74C3C), width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE74C3C), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email or phone';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
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
              hintText: 'Enter password',
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE74C3C), width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE74C3C), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
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
              'Remember Me',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Forgot Password clicked'),
                backgroundColor: Color(0xFF4A90E2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Text(
            'Forgot Password?',
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

  Widget _buildLoginButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A90E2).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Login Successful!'),
                  ],
                ),
                backgroundColor: Color(0xFF50C878),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return Container(
      height: 50,
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
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Biometric Login clicked'),
              backgroundColor: Color(0xFF4A90E2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        icon: Icon(Icons.fingerprint, size: 28, color: Color(0xFF4A90E2)),
        label: Text(
          'Login with Fingerprint',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A90E2),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF4A90E2),
          padding: EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Color(0xFF4A90E2), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.white,
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Container(
      height: 50,
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
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Google Login clicked'),
              backgroundColor: Color(0xFF4A90E2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        icon: Icon(Icons.g_mobiledata, size: 28, color: Color(0xFF2C3E50)),
        label: Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF2C3E50),
          padding: EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Color(0xFFE0E0E0), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign Up',
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
