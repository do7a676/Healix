import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../store/healix_store.dart';
import '../utils/page_transitions.dart';
import 'home_page.dart';
import 'doctor_home_page.dart';

class SignUpPage extends StatefulWidget {
  final String role;
  const SignUpPage({super.key, required this.role});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;

  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  int _selectedGender = 0; // 0 = Male, 1 = Female
  String _selectedCountryCode = "20"; // Egypt

  @override
  void dispose() {
    _userNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_firstNameController.text.trim().isEmpty || 
        _lastNameController.text.trim().isEmpty || 
        _userNameController.text.trim().isEmpty || 
        _emailController.text.trim().isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Format DOB for backend (YYYY-MM-DD)
    String formattedDob = "2000-01-01";
    if (_dobController.text.isNotEmpty) {
      try {
        final parts = _dobController.text.split('/');
        if (parts.length == 3) {
          formattedDob = "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
        }
      } catch (e) {
        formattedDob = "2000-01-01";
      }
    }

    final result = await authService.register(
      userName: _userNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: "+${_selectedCountryCode}${_phoneController.text.trim()}",
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: formattedDob,
      gender: _selectedGender,
      address: _addressController.text.trim(),
      role: widget.role,
      licenseId: _licenseController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      final user = result.user!;
      healixStore.setUserName(user.fullName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully! Welcome.'), backgroundColor: Colors.green),
      );
      if (user.role == 'doctor') {
        Navigator.pushAndRemoveUntil(context,
          SlideRightRoute(page: DoctorHomePage(username: user.fullName)),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(context,
          SlideRightRoute(page: HomePage(username: user.fullName)),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Registration failed'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) return Colors.grey[200];
              return null;
            }),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Image.asset('assets/images/logo_full.jpeg', height: 60),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.role == 'doctor' ? 'Create Doctor Account' : 'Create Patient Account',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Join Healix to start tracking your health.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildTextField(Icons.person_outline, 'First Name', 'John', controller: _firstNameController)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(Icons.person_outline, 'Last Name', 'Doe', controller: _lastNameController)),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(Icons.badge_outlined, 'Username', 'john_doe', controller: _userNameController),
            const SizedBox(height: 20),
            _buildTextField(Icons.email_outlined, 'Email Address', 'john@example.com',
                controller: _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildPhoneField(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    Icons.calendar_today_outlined, 
                    'Date of Birth', 
                    'DD/MM/YYYY', 
                    controller: _dobController,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _dobController.text = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text("Male")),
                          DropdownMenuItem(value: 1, child: Text("Female")),
                        ],
                        onChanged: (val) => setState(() => _selectedGender = val ?? 0),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(Icons.home_outlined, 'Address', '123 Main St', controller: _addressController),
            
            if (widget.role == 'doctor') ...[
              const SizedBox(height: 20),
              _buildTextField(Icons.badge_outlined, 'License ID', 'Enter your medical license ID',
                  controller: _licenseController),
            ],
            const SizedBox(height: 20),
            _buildTextField(Icons.lock_outline, 'Password', '••••••••',
                obscure: true, controller: _passwordController),
            const SizedBox(height: 20),
            _buildTextField(Icons.lock_outline, 'Confirm Password', '••••••••',
                obscure: true, controller: _confirmPassController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) return Colors.grey.shade300;
                    if (states.contains(MaterialState.hovered)) return const Color(0xFF006699);
                    return const Color(0xFF0088CC);
                  }),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "20", child: Text("🇪🇬 +20")),
                    DropdownMenuItem(value: "1", child: Text("🇺🇸 +1")),
                    DropdownMenuItem(value: "44", child: Text("🇬🇧 +44")),
                    DropdownMenuItem(value: "966", child: Text("🇸🇦 +966")),
                    DropdownMenuItem(value: "971", child: Text("🇦🇪 +971")),
                  ],
                  onChanged: (val) => setState(() => _selectedCountryCode = val ?? "20"),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '0123456789',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label, String hint, {
    bool obscure = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0088CC), size: 20),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ],
    );
  }
}
