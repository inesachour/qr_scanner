import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_scanner/database/qrcode_database.dart';
import 'package:qr_scanner/models/qrcode.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  List<QrCode>? qrCodes;
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

    if(qrCodes == null || qrCodes!.isEmpty){
      getAllQrCodes();
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : qrCodes == null || qrCodes!.isEmpty
              ? Center(child: Text("Your history is empty"))
              : ListView.builder(
          padding: EdgeInsets.all(5),
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    qrCodes![index].text,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(qrCodes![index].creationTime),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          },
          itemCount: qrCodes!.length,
        ),
      ),
    );
  }
}
