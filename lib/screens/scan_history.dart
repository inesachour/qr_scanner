import 'package:flutter/material.dart';
import 'package:qr_scanner/database/qrcode_database.dart';
import 'package:qr_scanner/models/qrcode.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  late List<QrCode> qrCodes;
  bool isLoading = true;

  @override
  void initState() {
    getAllQrCodes();
    super.initState();
  }

  @override
  void dispose() {
    QrCodeDatabase.instance.close();
    super.dispose();
  }

  getAllQrCodes() async {
    setState(() => isLoading = true);
    qrCodes = await QrCodeDatabase.instance.readAllQrCodes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : qrCodes.isEmpty
              ? Text("Empty")
              : ListView.builder(
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Text(qrCodes[index].text),
            );
          },
          itemCount: qrCodes.length,
        ),
      ),
    );
  }
}
