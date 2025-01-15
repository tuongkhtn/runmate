import "package:flutter/material.dart";
import "../../../common/utils/constants.dart";
import "dart:io";

class AvatarWidget extends StatelessWidget {
  final File? avatarFile;
  final VoidCallback onPickAvatar;

  const AvatarWidget({
    super.key,
    required this.avatarFile,
    required this.onPickAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: avatarFile != null
          ? FileImage(avatarFile!)
          : const AssetImage(kDefaultAvatarPath) as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3b3d3e),
            ),
            child: IconButton(
              onPressed: onPickAvatar,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}