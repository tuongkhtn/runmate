import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../../common/utils/constants.dart";
import "../widgets/editable_text_field.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";
import "../../../common/widgets/custom_elevated_button.dart";
import "../widgets/avatar_widget.dart";
import "../../../models/user.dart";
import "../../../repositories/user_repository.dart";
import "../../../common/providers/user_id_provider.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _dateOfBirthFocusNode = FocusNode();
  File? _avatar;

  final UserRepository _userRepository = UserRepository();

  User? _currentUser;
  bool _isLoading = true;

  // Map để lưu trạng thái chỉnh sửa của từng trường
  final Map<String, bool> _isEditing = {
    'name': false,
    'address': false,
    'phoneNumber': false,
    'dateOfBirth': false,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _dateOfBirthFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userId = Provider.of<UserIdProvider>(context, listen: false).userId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found! Please log in again.")),
      );
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    try {
      final user = await _userRepository.getUserById(userId);
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _addressController.text = user.address;
        _phoneNumberController.text = user.phoneNumber;
        _dateOfBirthController.text = user.dateOfBirth.toLocal().toString().split(' ')[0];
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading user data: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleEditing(String field, bool editing) {
    setState(() {
      // Reset tất cả các trạng thái isEditing về false
      _isEditing.updateAll((key, value) => false);

      // Chỉ cập nhật trạng thái của trường được chỉnh sửa
      if (editing) {
        _isEditing[field] = true;

        // Chuyển focus đến trường được chỉnh sửa
        switch (field) {
          case 'name':
            _nameFocusNode.requestFocus();
            break;
          case 'address':
            _addressFocusNode.requestFocus();
            break;
          case 'phoneNumber':
            _phoneNumberFocusNode.requestFocus();
            break;
          case 'dateOfBirth':
            _dateOfBirthFocusNode.requestFocus();
            break;
        }
      } else {
        // Hủy focus nếu ngừng chỉnh sửa
        switch (field) {
          case 'name':
            _nameFocusNode.unfocus();
            break;
          case 'address':
            _addressFocusNode.unfocus();
            break;
          case 'phoneNumber':
            _phoneNumberFocusNode.unfocus();
            break;
          case 'dateOfBirth':
            _dateOfBirthFocusNode.unfocus();
            break;
        }
      }
    });
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _avatar = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return; // Dừng nếu biểu mẫu không hợp lệ
    }

    setState(() {
      _isLoading = true; // Hiển thị trạng thái loading
    });

    try {
      final userId = Provider.of<UserIdProvider>(context, listen: false).userId;
      if (userId == null) {
        throw Exception("User ID not found! Please log in again.");
      }

      // Tạo một map chứa thông tin cần cập nhật
      final updatedData = {
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'dateOfBirth': DateTime.parse(_dateOfBirthController.text).toIso8601String(),
      };

      // Gọi hàm updateUser để cập nhật dữ liệu
      await _userRepository.updateUser(userId, updatedData);

      setState(() {
        // Cập nhật thông tin người dùng cục bộ
        _currentUser = _currentUser!.copyWith(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          dateOfBirth: DateTime.parse(_dateOfBirthController.text),
        );
      });

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Tắt trạng thái loading
      });
    }
  }


  void _logout() {
    try {
      Provider.of<UserIdProvider>(context, listen: false).clearUserId();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully!")),
      );
      Navigator.pushReplacementNamed(context, "/login");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during logout: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        width: double.infinity,
        color: kSecondaryColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            children: [
              const Text(
                "Profile Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              AvatarWidget(
                avatarFile: _avatar,
                onPickAvatar: _pickAvatar,
              ),
              const SizedBox(height: 45),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditableTextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      isEditing: _isEditing['name']!,
                      onEditToggle: (editing) => _toggleEditing('name', editing),
                      label: 'Name',
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    EditableTextField(
                      controller: _addressController,
                      focusNode: _addressFocusNode,
                      isEditing: _isEditing['address']!,
                      onEditToggle: (editing) => _toggleEditing('address', editing),
                      label: 'Address',
                      prefixIcon: const Icon(Icons.home, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    EditableTextField(
                      controller: _phoneNumberController,
                      focusNode: _phoneNumberFocusNode,
                      isEditing: _isEditing['phoneNumber']!,
                      onEditToggle: (editing) => _toggleEditing('phoneNumber', editing),
                      label: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    EditableTextField(
                      controller: _dateOfBirthController,
                      focusNode: _dateOfBirthFocusNode,
                      isEditing: _isEditing['dateOfBirth']!,
                      onEditToggle: (editing) => _toggleEditing('dateOfBirth', editing),
                      label: 'Date of Birth',
                      prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight, // Căn chỉnh sang góc phải
                      child: SizedBox(
                        width: 120,
                        child: CustomElevatedButton(
                          onPressed: _saveProfile,
                          text: "Save Profile",
                          isLoading: _isLoading,
                        ),
                      )
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _logout,
                  text: "Log Out",
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
