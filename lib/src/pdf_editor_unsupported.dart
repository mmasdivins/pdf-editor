import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_editor/pdf_editor.dart';
/// Fallback HtmlEditor class (should never be called)
class PdfEditor extends StatelessWidget {
  PdfEditor({
    Key? key,
    required this.controller,
    required this.loadPdf,
    required this.savePdf,
    this.callbacks,
    this.htmlEditorOptions = const HtmlEditorOptions(),
    this.htmlToolbarOptions = const HtmlToolbarOptions(),
    this.otherOptions = const OtherOptions(),
    this.plugins = const [],
  }) : super(key: key);

  /// The controller that is passed to the widget, which allows multiple [PdfEditor]
  /// widgets to be used on the same page independently.
  final PdfEditorController controller;

  final Future<Uint8List> Function() loadPdf;

  final Future Function(Uint8List) savePdf;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  final Callbacks? callbacks;

  /// Defines options for the html editor
  final HtmlEditorOptions htmlEditorOptions;

  /// Defines options for the editor toolbar
  final HtmlToolbarOptions htmlToolbarOptions;

  /// Defines other options
  final OtherOptions otherOptions;

  /// Sets the list of Summernote plugins enabled in the editor.
  final List<Plugins> plugins;

  @override
  Widget build(BuildContext context) {
    return Text('Unsupported in this environment');
  }
}
