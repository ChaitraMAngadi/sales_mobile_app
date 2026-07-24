import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

enum _AspectOption { one, three, four, free }

class UploadLogoDialog extends StatefulWidget {
  final Uint8List imageBytes;

  const UploadLogoDialog({super.key, required this.imageBytes});

  @override
  State<UploadLogoDialog> createState() => _UploadLogoDialogState();
}

class _UploadLogoDialogState extends State<UploadLogoDialog> {
  final CropController _controller = CropController();
  _AspectOption _selected = _AspectOption.free;
  bool _isCropping = false;

  double? get _aspectRatio {
    switch (_selected) {
      case _AspectOption.one:
        return 1 / 1;
      case _AspectOption.three:
        return 3 / 1;
      case _AspectOption.four:
        return 4 / 3;
      case _AspectOption.free:
        return null;
    }
  }

  Widget _aspectButton(String label, _AspectOption option) {
    final bool isSelected = _selected == option;
    return GestureDetector(
      onTap: () => setState(() => _selected = option),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_outlined, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Hospital Logo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Crop and set the logo for bills & PDFs',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context, null),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Aspect ratio buttons
            Row(
              children: [
                const Text(
                  'Aspect: ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(width: 4),
                _aspectButton('1:1', _AspectOption.one),
                _aspectButton('3:1', _AspectOption.three),
                _aspectButton('4:3', _AspectOption.four),
                _aspectButton('Free', _AspectOption.free),
              ],
            ),
            const SizedBox(height: 16),

            // Crop area
            SizedBox(
              height: 360,
              child: 
              Crop(
  controller: _controller,
  image: widget.imageBytes,
  aspectRatio: _aspectRatio,
  onCropped: (CropResult result) {
    setState(() => _isCropping = false);

    if (result is CropSuccess) {
      Navigator.pop(context, result.croppedImage);
    } else if (result is CropFailure) {
      Navigator.pop(context, null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Crop failed: ${result.cause}'),
        ),
      );
    }
  },
  withCircleUi: false,
  baseColor: Colors.grey.shade100,
  maskColor: Colors.white.withOpacity(0.6),
  progressIndicator: const Center(
    child: CircularProgressIndicator(color: AppColors.primary),
  ),
),
              // Crop(
              //   controller: _controller,
              //   image: widget.imageBytes,
              //   aspectRatio: _aspectRatio,
              //   onCropped: (croppedData) {
              //     setState(() => _isCropping = false);
              //     Navigator.pop(context, croppedData);
              //   },
              //   withCircleUi: false,
              //   baseColor: Colors.grey.shade100,
              //   maskColor: Colors.white.withOpacity(0.6),
              //   progressIndicator: const Center(
              //     child: CircularProgressIndicator(color: AppColors.primary),
              //   ),
              // ),
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isCropping
                      ? null
                      : () {
                          setState(() => _isCropping = true);
                          _controller.crop();
                        },
                  child: _isCropping
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Save Logo',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}