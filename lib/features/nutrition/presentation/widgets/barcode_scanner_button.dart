import 'package:flutter/material.dart';

class BarcodeScannerButton extends StatelessWidget {
  final Function(String) onBarcodeScanned;

  const BarcodeScannerButton({
    Key? key,
    required this.onBarcodeScanned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ),
        onPressed: () => _scanBarcode(context),
      ),
    );
  }

  void _scanBarcode(BuildContext context) {
    // TODO: Implement barcode scanning
    // For now, show a placeholder dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сканер штрихкода'),
        content: const Text('Функция сканирования штрихкода будет добавлена позже.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 