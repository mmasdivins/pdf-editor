import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:pdf_editor/pdf_editor.dart';
import 'package:pdf_editor/src/pdf_editor_controller_unsupported.dart'
    as unsupported;
import 'package:meta/meta.dart';

/// Controller for web
class PdfEditorController extends unsupported.PdfEditorController {
  PdfEditorController();


  /// Manages the view ID for the [PdfEditorController] on web
  String? _viewId;

  /// Internal method to set the view ID when iframe initialization
  /// is complete
  @override
  @internal
  set viewId(String? viewId) => _viewId = viewId;

  /// Sets the editor to full-screen mode.
  @override
  void setFullScreen() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setFullScreen'});
  }

  /// Sets the focus to the editor.
  @override
  void setFocus() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setFocus'});
  }

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  @override
  void clearFocus() {
    throw Exception(
        'Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this method.');
  }

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  @override
  void reloadWeb() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: reload'});
  }

  /// A function to quickly call a document.execCommand function in a readable format
  @override
  void execCommand(String command, {String? argument}) {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: execCommand',
      'command': command,
      'argument': argument
    });
  }

  /// A function to execute JS passed as a [WebScript] to the editor. This should
  /// only be used on Flutter Web.
  @override
  Future<dynamic> evaluateJavascriptWeb(String name,
      {bool hasReturnValue = false}) async {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: $name'});
    if (hasReturnValue) {
      var e = await html.window.onMessage.firstWhere(
          (element) => json.decode(element.data)['type'] == 'toDart: $name');
      return json.decode(e.data);
    }
  }

  /// Helper function to run javascript and check current environment
  void _evaluateJavascriptWeb({required Map<String, Object?> data}) async {
    if (kIsWeb) {
      data['view'] = _viewId;
      final jsonEncoder = JsonEncoder();
      var json = jsonEncoder.convert(data);
      html.window.postMessage(json, '*');
    } else {
      throw Exception(
          'Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart');
    }
  }
}
