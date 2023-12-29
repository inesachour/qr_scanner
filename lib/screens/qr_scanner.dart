import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/database/qrcode_database.dart';
import 'package:qr_scanner/models/qrcode.dart';
import 'package:qr_scanner/screens/scan_history.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          title: Text("Scanner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              MobileScanner(
                allowDuplicates: false,
                onDetect: onDetectBarcode,
              ),

              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  child: const Icon(Icons.history),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanHistoryScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  void onDetectBarcode(Barcode barcode, MobileScannerArguments? args) async {
    if(barcode.rawValue == null || barcode.rawValue!.isEmpty) {
      return;
    }
    QrCode qrCode = QrCode(text: barcode.rawValue!, creationTime: DateTime.now());
    await QrCodeDatabase.instance.create(qrCode);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(qrCode.text),
        );
      },
    );
  }

}