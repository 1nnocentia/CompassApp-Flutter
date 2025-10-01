// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../auth/logout/view_models/logout_viewmodel.dart';
import '../../auth/logout/widgets/logout_button.dart';
import '../../core/localization/applocalization.dart';
import '../../core/themes/dimens.dart';
import '../view_models/home_viewmodel.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final user = viewModel.user;
    if (user == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                user.picture,
                width: Dimens.of(context).profilePictureSize,
                height: Dimens.of(context).profilePictureSize,
              ),
            ),
            LogoutButton(
              viewModel: LogoutViewModel(
                authRepository: context.read(),
                itineraryConfigRepository: context.read(),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.paddingVertical),
        _EditableTitle(text: AppLocalization.of(context).nameTrips(user.name), viewModel: viewModel),
      ],
    );
  }
}

class _EditableTitle extends StatelessWidget {
  const _EditableTitle({required this.text, required this.viewModel});

  final String text;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditNameDialog(context),
      child: Row(
        children: [
          Expanded(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => RadialGradient(
                center: Alignment.bottomLeft,
                radius: 2,
                colors: [Colors.purple.shade700, Colors.purple.shade400],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                text,
                style: GoogleFonts.rubik(
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.edit,
            color: Colors.purple.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController();
    final currentUser = viewModel.user;
    if (currentUser != null) {
      controller.text = currentUser.name;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Your Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  viewModel.updateUserName.execute(newName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
