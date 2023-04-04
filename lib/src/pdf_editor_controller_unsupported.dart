import 'dart:async';
import 'dart:typed_data';

import 'package:pdf_editor/pdf_editor.dart';
import 'package:meta/meta.dart';

/// Fallback controller (should never be used)
class PdfEditorController {
  PdfEditorController();

  void loadPdf(Uint8List bytes) {}

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  dynamic get editorController => null;

  /// Internal method to set the [InAppWebViewController] when webview initialization
  /// is complete
  @internal
  set editorController(dynamic controller) => {};

  /// Internal method to set the view ID when iframe initialization
  /// is complete
  @internal
  set viewId(String? viewId) => {};


  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  void clearFocus() {}


  /// A function to quickly call a document.execCommand function in a readable format
  void execCommand(String command, {String? argument}) {}

  /// A function to execute JS passed as a [WebScript] to the editor. This should
  /// only be used on Flutter Web.
  Future<dynamic> evaluateJavascriptWeb(String name,
          {bool hasReturnValue = false}) =>
      Future.value();

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  void reloadWeb() {}

  /// Sets the focus to the editor.
  void setFocus() {}

  /// Sets the editor to full-screen mode.
  void setFullScreen() {}


  Stream<dynamic>? get webMessage => null;

  StreamController? get listener => null;

}
