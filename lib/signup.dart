import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2C3E50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2C3E50), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/eldercare.png'),
                  ),
                ),
                SizedBox(height: 16),

                // Title
                Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Sign up to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Full Name
                _buildLabel('Full Name'),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Enter your full name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email
                _buildLabel('Email'),
                _buildTextField(
                  controller: _emailController,
                  hint: 'Enter your email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Phone Number
                _buildLabel('Phone Number'),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'Enter your phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Date of Birth
                _buildLabel('Date of Birth'),
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
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 22, color: Color(0xFF4A90E2)),
                          SizedBox(width: 16),
                          Text(
                            _selectedDate == null
                                ? 'Select date of birth'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDate == null
                                  ? Color(0xFFBDC3C7)
                                  : Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Password
                _buildLabel('Password'),
                _buildPasswordField(
                  controller: _passwordController,
                  hint: 'Enter password',
                  obscureText: _obscurePassword,
                  onToggle: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
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
                SizedBox(height: 16),

                // Confirm Password
                _buildLabel('Confirm Password'),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hint: 'Re-enter password',
                  obscureText: _obscureConfirmPassword,
                  onToggle: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Terms & Conditions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value!;
                          });
                        },
                        activeColor: Color(0xFF4A90E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'I accept the Terms & Conditions and Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Sign Up Button
                Container(
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
                      if (_formKey.currentState!.validate() && _acceptTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 12),
                                Text('Account Created Successfully!'),
                              ],
                            ),
                            backgroundColor: Color(0xFF50C878),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else if (!_acceptTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please accept terms & conditions'),
                            backgroundColor: Color(0xFFE74C3C),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
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
                SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
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
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
          prefixIcon: Icon(icon, size: 22, color: Color(0xFF4A90E2)),
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
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDC3C7)),
          prefixIcon: Icon(Icons.lock, size: 22, color: Color(0xFF4A90E2)),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              size: 22,
              color: Color(0xFF7F8C8D),
            ),
            onPressed: onToggle,
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
        validator: validator,
      ),
    );
  }
}
