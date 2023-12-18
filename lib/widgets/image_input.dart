import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage; //file can also be null , hence the question mark

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    //ImageSource is just another enum provided by ImagePicker library

    if (pickedImage == null) {
      return;
    }
    //converting XFile to normal file below, by using File and path

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    //since onPickImage is defined in the widget class, hence below
    widget.onPickImage(_selectedImage!);
    //theoritically selectedImage can be null, but here it is not because we are setting it equal to pick image which will not be null
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text('Take a picture'),
      onPressed: _takePicture,
    );

    //the file we are passing below is our _selectedImage file
    if (_selectedImage != null) {
      content = GestureDetector(
          onTap: _takePicture,
          child: Image.file(_selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity));
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        )),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
