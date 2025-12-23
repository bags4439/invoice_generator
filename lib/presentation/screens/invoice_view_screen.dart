import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:invoice_generator/core/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../domain/entities/invoice.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class InvoiceViewScreen extends StatelessWidget {
  final InvoiceEntity invoice;

  InvoiceViewScreen({super.key, required this.invoice});

  final GlobalKey _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
              '${invoice.type == InvoiceEntityType.invoice ? 'Invoice' : 'Receipt'} ${invoice.number}')),
      body: RepaintBoundary(
        key: _widgetKey,
        child: _page(), // your existing widget
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.share),
        onPressed: () => _captureAndShareWidget(),
      ),
    );
  }

  Widget _page() => [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            [
              Image.asset(
                  invoice.headerImageUrl ?? 'assets/images/default_header.png'),
              [
                Text(
                  invoice.type == InvoiceEntityType.invoice
                      ? 'INVOICE'
                      : 'RECEIPT',
                  style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 32),
                ).padding(left: 8, bottom: 2),
                [
                  Text('${invoice.type == InvoiceEntityType.invoice
                      ? 'Invoice#': 'Receipt#'}    ${invoice.number}',
                      style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12)),
                  SizedBox(
                    height: 4,
                  ),
                  Text('Date    ${formatDate(invoice.date.toLocal())}',
                      style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12))
                ]
                    .toColumn(crossAxisAlignment: CrossAxisAlignment.end)
                    .padding(right: 16, bottom: 8)
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .positioned(bottom: 0, left: 0, right: 0)
            ].toStack(),
            [
              [
                Text(
                  invoice.type == InvoiceEntityType.invoice
                      ? "Invoice to: ":"Receipt to",
                  style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Text(invoice.customerName,
                        style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                    .flexible()
              ]
                  .toColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min)
                  .padding(all: 16)
                  .expanded(),
              [
                Text(
                  "Payment Info",
                  style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Name: Sparklean limited',
                  style: TextStyle(fontFamily: 'Times New Roman', fontSize: 12),
                ),
                Divider(),
                Text(
                  'MoMo: 0595532921',
                  style: TextStyle(fontFamily: 'Times New Roman', fontSize: 14),
                ),
                SizedBox(
                  height: 4,
                ),
                [
                  [
                    Text(
                      'Bank: 2346972761010',
                      style: TextStyle(
                          fontFamily: 'Times New Roman', fontSize: 14),
                    ),
                    Text(
                      'First Atlantic Bank - Madina',
                      style: TextStyle(
                          fontFamily: 'Times New Roman', fontSize: 12, fontStyle: FontStyle.italic),
                    )
                  ].toColumn(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start)
                ].toRow(crossAxisAlignment: CrossAxisAlignment.start)
              ]
                  .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                  .padding(all: 16)
                  .expanded()
            ].toRow(crossAxisAlignment: CrossAxisAlignment.start),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  [
                    SizedBox(
                      width: 25,
                      child:
                          textDescription(text: "SL", textColor: Colors.white),
                    ),
                    textDescription(
                            text: "Item Description", textColor: Colors.white)
                        .expanded(),
                    SizedBox(
                      width: 80,
                      child: textDescription(
                          text: 'Price', textColor: Colors.white),
                    ),
                    SizedBox(
                      width: 30,
                      child:
                          textDescription(text: 'Qty', textColor: Colors.white),
                    ),
                    SizedBox(
                      width: 80,
                      child: textDescription(
                          text: 'Total',
                          textAlign: TextAlign.right,
                          textColor: Colors.white),
                    )
                  ]
                      .toRow()
                      .padding(horizontal: 16, vertical: 8)
                      .decorated(color: Colors.teal),
                  SizedBox(
                    height: 16,
                  ),
                  ...invoice.items.indexed.map((e) {
                    final index = e.$1; // the index
                    final i = e.$2;
                    return [
                      [
                        SizedBox(
                          width: 25,
                          child: textDescription(text: "${index + 1}"),
                        ),
                        textDescription(text: i.description).expanded(),
                        SizedBox(
                          width: 80,
                          child: textDescription(
                              text:
                                  formatAsPrice(i.amount, showCurrency: false)),
                        ),
                        SizedBox(
                          width: 30,
                          child: textDescription(text: '${i.quantity}'),
                        ),
                        SizedBox(
                          width: 80,
                          child: textDescription(
                              text: formatAsPrice(i.quantity * i.amount,
                                  showCurrency: false),
                              textAlign: TextAlign.right),
                        )
                      ].toRow().padding(horizontal: 16, vertical: 8),
                      Divider()
                    ].toColumn(crossAxisAlignment: CrossAxisAlignment.stretch);
                  }),
                  SizedBox(
                    height: 54,
                  ),
                  [
                    Text(
                      'Sub Total:   ${formatAsPrice(invoice.total)}',
                      style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text('Tax:   0.00%',
                        style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    Divider(),
                    Text('Total:   ${formatAsPrice(invoice.total)}',
                        style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                            fontSize: 16))
                  ]
                      .toColumn(crossAxisAlignment: CrossAxisAlignment.end)
                      .width(250)
                      .padding(right: 16),
                  SizedBox(
                    height: 54,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Thank you for your business',
                      style: TextStyle(fontFamily: 'Times New Roman'),
                    ),
                  ).padding(left: 16),
                  SizedBox(
                    height: 54,
                  ),
                ],
              ),
            ),
          ],
        ).decorated(color: Colors.white).expanded(),
        Image.asset(
            invoice.footerImageUrl ?? 'assets/images/default_footer.png'),
      ].toColumn();

  Widget textDescription(
      {required String text,
      TextAlign textAlign = TextAlign.start,
      Color textColor = Colors.black87}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Times New Roman'),
    );
  }

  Future _captureAndShareWidget() async {
    try {
      // Capture widget
      RenderRepaintBoundary boundary = _widgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/invoice.png').create();
      await file.writeAsBytes(pngBytes);

      // Share
      await Share.shareXFiles([XFile(file.path)],
          text: 'Invoice ${invoice.number}');
    } catch (e) {
      print("Error capturing widget: $e");
    }
  }
}
