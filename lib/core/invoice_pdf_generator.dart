import 'package:flutter/services.dart';
import 'package:invoice_generator/core/utils.dart';
import 'package:invoice_generator/domain/entities/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfGenerator {
  static const _defaultHeader = 'assets/images/default_header.png';
  static const _defaultFooter = 'assets/images/default_footer.png';
  static const _signature = 'assets/images/signature.png';
  static const _fontRegular = 'assets/fonts/NotoSans-Regular.ttf';
  static const _fontBold = 'assets/fonts/NotoSans-Bold.ttf';
  static const _teal = PdfColor.fromInt(0xFF008080);
  static const _lineColor = PdfColors.grey400;

  static String fileName(InvoiceEntity invoice) {
    final prefix =
        invoice.type == InvoiceEntityType.invoice ? 'invoice' : 'receipt';
    return '${prefix}_${invoice.number}.pdf';
  }

  static Future<Uint8List> generate(InvoiceEntity invoice) async {
    final headerBytes =
        await _loadImage(invoice.headerImageUrl, _defaultHeader);
    final footerBytes =
        await _loadImage(invoice.footerImageUrl, _defaultFooter);
    final signatureBytes = await _loadImage(_signature, _signature);

    final regularFont = pw.Font.ttf(await rootBundle.load(_fontRegular));
    final boldFont = pw.Font.ttf(await rootBundle.load(_fontBold));

    final headerImage = pw.MemoryImage(headerBytes);
    final footerImage = pw.MemoryImage(footerBytes);
    final signatureImage = pw.MemoryImage(signatureBytes);

    final isInvoice = invoice.type == InvoiceEntityType.invoice;
    final docTitle = isInvoice ? 'INVOICE' : 'RECEIPT';
    final numberLabel = isInvoice ? 'Invoice#' : 'Receipt#';

    final theme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
    );

    final pdf = pw.Document(theme: theme);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildHeader(
                headerImage,
                docTitle,
                numberLabel,
                invoice,
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _buildCustomerAndPayment(invoice, isInvoice),
              ),
              pw.Expanded(
                child: _buildItemsSection(invoice, signatureImage),
              ),
              pw.Image(footerImage, fit: pw.BoxFit.fitWidth),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> _loadImage(String? url, String fallback) async {
    final path = (url == null || url.isEmpty) ? fallback : url;
    try {
      final data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    } catch (_) {
      if (path != fallback) {
        return _loadImage(null, fallback);
      }
      rethrow;
    }
  }

  static pw.Widget _thinLine({double verticalMargin = 4}) {
    return pw.Container(
      margin: pw.EdgeInsets.symmetric(vertical: verticalMargin),
      height: 0.5,
      color: _lineColor,
    );
  }

  static pw.Widget _buildHeader(
    pw.MemoryImage headerImage,
    String docTitle,
    String numberLabel,
    InvoiceEntity invoice,
  ) {
    return pw.SizedBox(
      height: 140,
      child: pw.Stack(
        children: [
          pw.Positioned.fill(
            child: pw.Image(headerImage, fit: pw.BoxFit.cover),
          ),
          pw.Positioned(
            left: 16,
            bottom: 12,
            child: pw.Text(
              docTitle,
              style: pw.TextStyle(
                fontSize: 40,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          pw.Positioned(
            right: 16,
            bottom: 8,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '$numberLabel    ${invoice.number}',
                  style: _labelStyle(color: PdfColors.white, fontSize: 14),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Date    ${formatDate(invoice.date.toLocal())}',
                  style: _labelStyle(color: PdfColors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomerAndPayment(
    InvoiceEntity invoice,
    bool isInvoice,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                isInvoice ? 'Invoice to: ' : 'Receipt to',
                style: _labelStyle(fontSize: 16),
              ),
              pw.Text(
                invoice.customerName,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Payment Info', style: _labelStyle(fontSize: 14)),
              pw.SizedBox(height: 4),
              pw.Text('Name: Sparklean limited', style: _bodyStyle(10)),
              _thinLine(verticalMargin: 2),
              pw.Text('MoMo: 0595532921', style: _bodyStyle(12)),
              pw.SizedBox(height: 4),
              pw.Text('Bank: 2346972761010', style: _bodyStyle(12)),
              pw.Text(
                'First Atlantic Bank - Madina',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsSection(
    InvoiceEntity invoice,
    pw.MemoryImage signatureImage,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Container(
            color: _teal,
            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: pw.Row(
              children: [
                pw.SizedBox(width: 32, child: _headerCell('SL')),
                pw.Expanded(child: _headerCell('Item Description')),
                pw.SizedBox(width: 16),
                pw.SizedBox(width: 80, child: _headerCell('Price (₵)')),
                pw.SizedBox(width: 32, child: _headerCell('Qty')),
                pw.SizedBox(
                  width: 100,
                  child: _headerCell('Total (₵)', align: pw.TextAlign.right),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          ...invoice.items.indexed.map((entry) {
            final index = entry.$1;
            final item = entry.$2;
            return pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 32,
                        child: _bodyCell('${index + 1}'),
                      ),
                      pw.Expanded(child: _bodyCell(item.description)),
                      pw.SizedBox(width: 16),
                      pw.SizedBox(
                        width: 80,
                        child: _bodyCell(
                          formatAsPrice(item.amount, showCurrency: false),
                        ),
                      ),
                      pw.SizedBox(
                        width: 32,
                        child: _bodyCell('${item.quantity}'),
                      ),
                      pw.SizedBox(
                        width: 100,
                        child: _bodyCell(
                          formatAsPrice(
                            item.quantity * item.amount,
                            showCurrency: false,
                          ),
                          align: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                _thinLine(),
              ],
            );
          }),
          pw.SizedBox(height: 24),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Thank you for your business',
                      style: _bodyStyle(12),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text('Signed', style: _bodyStyle(11)),
                    pw.SizedBox(height: 4),
                    pw.SizedBox(
                      height: 36,
                      child: pw.Image(signatureImage, fit: pw.BoxFit.contain),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text('Patience Kpeh', style: _labelStyle(fontSize: 12)),
                    pw.Text('CEO', style: _bodyStyle(11)),
                  ],
                ),
                pw.SizedBox(
                  width: 220,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Sub Total:   ${formatAsPrice(invoice.total)}',
                        style: _labelStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Tax:   0.00%',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      _thinLine(verticalMargin: 6),
                      pw.Text(
                        'Total:   ${formatAsPrice(invoice.total)}',
                        style: _labelStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.TextStyle _labelStyle({PdfColor? color, double fontSize = 12}) {
    return pw.TextStyle(
      fontSize: fontSize,
      fontWeight: pw.FontWeight.bold,
      color: color,
    );
  }

  static pw.TextStyle _bodyStyle(double fontSize) {
    return pw.TextStyle(fontSize: fontSize);
  }

  static pw.Widget _headerCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
    );
  }

  static pw.Widget _bodyCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    );
  }
}
