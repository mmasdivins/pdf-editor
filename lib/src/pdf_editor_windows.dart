import 'package:pdf_editor/pdf_editor.dart'
    hide PdfEditorController;
import 'package:pdf_editor/src/pdf_editor_controller_windows.dart';
import 'package:pdf_editor/src/widgets/pdf_editor_widget_windows.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// HtmlEditor class for mobile
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
    if (!kIsWeb) {
      return PdfEditorWidget(
        key: key,
        controller: controller,
        loadPdf: loadPdf,
        savePdf: savePdf,
        callbacks: callbacks,
        plugins: plugins,
        htmlEditorOptions: htmlEditorOptions,
        htmlToolbarOptions: htmlToolbarOptions,
        otherOptions: otherOptions,
      );
    } else {
      return Text(
          'Flutter Web environment detected, please make sure you are importing package:pdf_editor/pdf_editor.dart');
    }
  }
}
