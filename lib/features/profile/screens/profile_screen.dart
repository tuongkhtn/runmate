import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../auth/models/user_model.dart";
import "../../../common/utils/constants.dart";
import "../../../common/providers/user_provider.dart";
import "../widgets/editable_text_field.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";
import "../../auth/services/user_service.dart";
import "../../../common/widgets/custom_elevated_button.dart";
import "../widgets/avatar_widget.dart";

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

  final UserService _userService = UserService();

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if(user != null) {
      _nameController.text = user.name;
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
    if(!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      if(user != null) {
        await _userService.updateUser(
          userId: user.userId,
          name: _nameController.text.trim(),
        );

        userProvider.setUser(
          user.copyWith(
            name: _nameController.text.trim(),
          )
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      Provider.of<UserProvider>(context, listen: false).clearUser();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully!")),
      );
      Navigator.pushReplacementNamed(context, "/login");
    } catch(e) {
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