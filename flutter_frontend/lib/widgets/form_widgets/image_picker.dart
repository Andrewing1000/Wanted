import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGallery extends StatefulWidget {
  final ValueChanged<List<Uint8List>> onImagesChanged;

  ImageGallery({required this.onImagesChanged});

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final List<Uint8List> _images = [];
  final ImagePicker _picker = ImagePicker(); // Shared ImagePicker instance

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
  if (await Permission.camera.request().isGranted) {
  } else if (await Permission.camera.isPermanentlyDenied) {
    openAppSettings();
  }
}

  Future<void> _addImage() async {
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot add more than 10 images')),
      );
      return;
    }

    // Show a dialog to choose between Camera and Gallery
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take Photo'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Choose from Gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _images.add(imageBytes);
        });
        widget.onImagesChanged(_images);
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _images.length < 10 ? _images.length + 1 : _images.length,
        itemBuilder: (context, index) {
          if (index == _images.length && _images.length < 10) {
            // Add Button
            return GestureDetector(
              onTap: _addImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Center(
                  child: Icon(Icons.add, size: 40, color: Colors.grey.shade600),
                ),
              ),
            );
          }

          // Display image
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: MemoryImage(_images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Delete Icon
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Icon(Icons.close, color: Colors.red.shade600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
