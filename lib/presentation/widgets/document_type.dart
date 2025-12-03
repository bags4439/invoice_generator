import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

enum DocumentType {invoice, receipt }

class DocumentTypeSelector extends StatefulWidget {
  final Function(DocumentType) docTypeCallback;

  const DocumentTypeSelector({super.key, required this.docTypeCallback});

  @override
  _DocumentTypeSelectorState createState() => _DocumentTypeSelectorState();
}

class _DocumentTypeSelectorState extends State<DocumentTypeSelector> {
  DocumentType _selectedType = DocumentType.invoice; // default

  @override
  void initState() {
    super.initState();
    widget.docTypeCallback(_selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<DocumentType>(
          title: Text(
            'Invoice',
            style: TextStyle(
              fontFamily: 'Times New Roman',
            ),
          ),
          value: DocumentType.invoice,
          groupValue: _selectedType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedType = value;
              });
              widget.docTypeCallback(_selectedType);
            }
          },
        ).constrained(height: 50, width: 170),
        RadioListTile<DocumentType>(
          title: Text(
            'Receipt',
            style: TextStyle(
              fontFamily: 'Times New Roman',
            ),
          ),
          value: DocumentType.receipt,
          groupValue: _selectedType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedType = value;
              });
              widget.docTypeCallback(_selectedType);
            }
          },
        ).constrained(height: 50, width: 170),

      ],
    ).height(50);
  }
}
