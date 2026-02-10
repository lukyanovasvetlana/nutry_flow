import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final void Function(String code)? onScanned;

  const BarcodeScannerScreen({super.key, this.onScanned});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isHandled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Сканер штрих-кода'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_isHandled) return;
              if (capture.barcodes.isEmpty) return;
              final code = capture.barcodes.first.rawValue;
              if (code == null || code.isEmpty) return;
              _isHandled = true;
              widget.onScanned?.call(code);
              Navigator.of(context).pop(code);
            },
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.button.withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
              child: const Text(
                'Наведите камеру на штрих-код',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
