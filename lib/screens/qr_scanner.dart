import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/shared/constants.dart';
import 'package:qr_scanner/database/qrcode_database.dart';
import 'package:qr_scanner/models/qrcode.dart';
import 'package:qr_scanner/screens/scan_history.dart';
import 'package:qr_scanner/shared/utlis.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool popUpOpened = false;
  bool historyScreenActive = false;

  @override
  void dispose() {
    QrCodeDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primaryColor,
        title: const Text(appName),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.history),
          label: const Text("History"),
          backgroundColor: CustomTheme.primaryColor,
          onPressed: (){
            setState(() {
              historyScreenActive = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanHistoryScreen()),
            ).then((value) {
              setState(() {
                historyScreenActive = false;
              });
            });
          },
        ),
      body: SafeArea(
          child: MobileScanner(
            allowDuplicates: false,
            onDetect: onDetectBarcode,
          ),
        ),
    );
  }

  void onDetectBarcode(Barcode barcode, MobileScannerArguments? args) async {
    if(barcode.rawValue == null || barcode.rawValue!.isEmpty || popUpOpened || historyScreenActive) {
      return;
    }

    setState(() {
      popUpOpened = true;
    });

    QrCode qrCode = QrCode(
      text: barcode.rawValue!.trim(),
      creationTime: DateTime.now(),
      type: barcode.type.name
    );
    await QrCodeDatabase.instance.create(qrCode);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "QR Code scanned successfully",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              const Icon(Icons.qr_code, size: 50, color: CustomTheme.primaryColor,),
              const SizedBox(height: 5,),
              Text(qrCode.text),
              const SizedBox(height: 5,),
              Text("Type: ${qrCode.type}", style: const TextStyle(fontSize: 12, color: Colors.grey),),
              const SizedBox(height: 5,),
              ElevatedButton(
                onPressed: (){
                  copyQrCodeText(context: context, text: qrCode.text);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(CustomTheme.primaryColor,),
                ),
                child: const Text("Copy"),
              ),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      popUpOpened = false;
    });
  }

}