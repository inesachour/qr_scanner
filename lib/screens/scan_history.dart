import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_scanner/constants/custom_theme.dart';
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

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primaryColor,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: CustomTheme.secondaryBackgroundColor,))
            : qrCodes == null || qrCodes!.isEmpty
              ? Center(child: Text("Your history is empty", style: TextStyle(color: CustomTheme.secondaryBackgroundColor, fontSize: 22),))
              : Column(
                children: [
                  SizedBox(
                    height: height *0.05,
                  ),
                  Container(
                    height: height *0.05,
                    child: Text(
                      "Scanning History",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: height *0.03,
                  ),
                  Container(
                    height: height *0.05,
                    child: Text(
                      "Here you can find the history of\nall your scanned QR codes",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: height *0.03,
                  ),
                  Container(
                    height: height *0.6,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomTheme.secondaryBackgroundColor),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: CustomTheme.secondaryBackgroundColor,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.qr_code_2, color: CustomTheme.primaryColor,),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      qrCodes![index].text,
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      DateFormat('dd MMMM yyyy HH:mm').format(qrCodes![index].creationTime),
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        },
                      itemCount: qrCodes!.length,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
