import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.OnPickImage});
  final void Function(File image) OnPickImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takepiture() async {
    final imagepicker = ImagePicker();
    final pickedImage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.OnPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _takepiture,
        icon: const Icon(Icons.camera),
        label: const Text('Take Piture'));
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takepiture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.primary),
        ),
        height: 250,
        width: double.infinity,
        child: content);
  }
}
