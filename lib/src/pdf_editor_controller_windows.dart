import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf_editor/pdf_editor.dart';
import 'package:pdf_editor/src/pdf_editor_controller_unsupported.dart'
    as unsupported;
import 'package:webview_windows/webview_windows.dart';

/// Controller for windows
class PdfEditorController extends unsupported.PdfEditorController {
  PdfEditorController();

  StreamController _listener = StreamController();

  @override
  void loadPdf(Uint8List bytes) async {
    _evaluateJavascript(source: """
    PDFViewerApplication.open({
       data: $bytes
    });
    """);
  }

  @override
  StreamController? get listener => _listener;

  /// Manages the [WebviewController] for the [PdfEditorController]
  WebviewController? _editorController;

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  @override
  // ignore: unnecessary_getters_setters
  WebviewController? get editorController => _editorController;

  /// Internal method to set the [WebViewController] when webview initialization
  /// is complete
  @override
  // ignore: unnecessary_getters_setters
  set editorController(dynamic controller) {
    _editorController = controller as WebviewController?;
    listener!.add("loaded");
  }


  /// A function to quickly call a document.execCommand function in a readable format
  @override
  void execCommand(String command, {String? argument}) {
    _evaluateJavascript(
        source:
            "document.execCommand('$command', false${argument == null ? "" : ", '$argument'"});");
  }

  /// Sets the editor to full-screen mode.
  @override
  void setFullScreen() {
    _evaluateJavascript(
        source: '\$("#summernote-2").summernote("fullscreen.toggle");');
  }

  /// Sets the focus to the editor.
  @override
  void setFocus() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('focus');");
  }

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  @override
  void clearFocus() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Reloads the IFrameElement, throws an exception on mobile
  @override
  void reloadWeb() {
    throw Exception(
        'Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this function');
  }

  @override
  Stream<dynamic>? get webMessage => editorController?.webMessage;


  /// Helper function to evaluate JS and check the current environment
  dynamic _evaluateJavascript({required source}) async {
    if (!kIsWeb) {
      // var loadingState = await _editorController?.loadingState.last;
      if (editorController == null /*|| loadingState == LoadingState.loading*/) {
        throw Exception(
            'HTML editor is still loading, please wait before evaluating this JS: $source!');
      }
      var result = await editorController!.executeScript(source);
      return result;
    } else {
      throw Exception(
          'Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart');
    }
  }

  /// Helper function to evaluate JS and check the current environment
  dynamic evaluateJavascript({required source}) async {
    if (!kIsWeb) {
      // var loadingState = await _editorController?.loadingState.last;
      if (editorController == null /*|| loadingState == LoadingState.loading*/) {
        throw Exception(
            'HTML editor is still loading, please wait before evaluating this JS: $source!');
      }
      var result = await editorController!.executeScript(source);
      return result;
    } else {
      throw Exception(
          'Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart');
    }
  }

}
