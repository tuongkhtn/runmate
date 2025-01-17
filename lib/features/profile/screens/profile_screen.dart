import "package:flutter/material.dart";
import "../../../common/utils/constants.dart";
import "../widgets/editable_text_field.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";
import "../../../common/widgets/custom_elevated_button.dart";
import "../widgets/avatar_widget.dart";
import "../../../models/user.dart";
import "../../../repositories/user_repository.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  File? _avatar;

  final UserRepository _userRepository = UserRepository();

  late User _currentUser;
  bool _isLoading = false;
  bool _isEditing = false;

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
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    // Nhận thông tin người dùng từ arguments
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is User) {
      setState(() {
        _currentUser = arguments;
        print("User: $_currentUser");
        _nameController.text = _currentUser.name; // Gán giá trị vào TextField
      });
    }
  }

  void _toggleEditing(bool editing) {
    setState(() {
      _isEditing = editing;
      if(_isEditing) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null) {
      setState(() {
        _avatar = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfile() async {

  }

  void _logout() {
    try {
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
      body: Container(
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

              const SizedBox(height: 20,),

              AvatarWidget(
                avatarFile: _avatar,
                onPickAvatar: _pickAvatar,
              ),

              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditableTextField(
                      controller: _nameController,
                      focusNode: _focusNode,
                      isEditing: _isEditing,
                      onEditToggle: _toggleEditing,
                      label: 'Name',
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                    ),

                    const SizedBox(height: 30,),
                  ],
                ),
              ),

              const Spacer(),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _logout,
                  text: "Log Out",
                  isLoading: false,
                ),
              )
            ],
          )
        )
      )
    );
  }
}