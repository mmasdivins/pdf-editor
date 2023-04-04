import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pdf_editor/src/pdf_editor_controller_windows.dart' as ecw;
import 'package:pdf_editor/pdf_editor.dart'
    hide NavigationActionPolicy, UserScript, ContextMenu;
import 'package:pdf_editor/utils/utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The HTML Editor widget itself, for mobile (uses InAppWebView)
class PdfEditorWidget extends StatefulWidget {
  PdfEditorWidget({
    Key? key,
    required this.controller,
    required this.loadPdf,
    required this.savePdf,
    this.callbacks,
    required this.plugins,
    required this.htmlEditorOptions,
    required this.htmlToolbarOptions,
    required this.otherOptions,
  }) : super(key: key);

  final ecw.PdfEditorController controller;
  final Future<Uint8List> Function() loadPdf;
  final Future Function(Uint8List) savePdf;
  final Callbacks? callbacks;
  final List<Plugins> plugins;
  final HtmlEditorOptions htmlEditorOptions;
  final HtmlToolbarOptions htmlToolbarOptions;
  final OtherOptions otherOptions;

  @override
  _PdfEditorWidgetWindowsState createState() => _PdfEditorWidgetWindowsState();
}

/// State for the mobile Html editor widget
///
/// A stateful widget is necessary here to allow the height to dynamically adjust.
class _PdfEditorWidgetWindowsState extends State<PdfEditorWidget> {
  final _controller = WebviewController();

  late String createdViewId;
  Future<bool>? pdfViewerInit;

  /// Tracks whether the callbacks were initialized or not to prevent re-initializing them
  bool callbacksInitialized = false;

  /// The height of the document loaded in the editor
  late double docHeight;

  /// The file path to the html code
  late String filePath;

  /// String to use when creating the key for the widget
  late String key;

  /// Stream to transfer the [VisibilityInfo.visibleFraction] to the [onWindowFocus]
  /// function of the webview
  StreamController<double> visibleStream = StreamController<double>.broadcast();

  /// Helps get the height of the toolbar to accurately adjust the height of
  /// the editor when the keyboard is visible.
  GlobalKey toolbarKey = GlobalKey();

  /// Variable to cache the viewable size of the editor to update it in case
  /// the editor is focused much after its visibility changes
  double? cachedVisibleDecimal;

  @override
  void initState() {
    widget.controller.editorController = _controller;

    createdViewId = getRandString(10);
    widget.controller.viewId = createdViewId;

    docHeight = widget.otherOptions.height;
    key = getRandString(10);

    filePath =
    'packages/pdf_editor/assets/web/viewer.html';

    initViewer();

    _controller.webMessage.listen((event) async {
      var data = json.decode(event);
      var v = data["pdf_data"];
      var list = <int>[];
      v.forEach((k,v) => list.add(v));
      await widget.savePdf(Uint8List.fromList(list));
    });

    super.initState();
  }

  initViewer() async {
    WebviewController.initializeEnvironment(
      additionalArguments: "--disable-web-security"
    );
    await _controller.initialize();

    await _controller.loadUrl(getAssetFileUrl("web/viewer.html"));
    // await _controller.loadUrl("https://mozilla.github.io/pdf.js/web/viewer.html?file=https://raw.githubusercontent.com/mmasdivins/html-editor-enhanced/windows/lib/pdf-lib_form_creation_example.pdf");
    // await _controller.loadUrl("https://github.com/hlwhl/webview_cef");

    _controller.loadingState.listen((event) async {
      if (event == LoadingState.navigationCompleted){
        widget.controller.loadPdf(await widget.loadPdf());
      }
    });



    setState(mounted, this.setState, () {
      pdfViewerInit = Future.value(true);
    });
  }

  String getAssetFileUrl(String asset) {
    final assetsDirectory = p.join(
        p.dirname(Platform.resolvedExecutable),
        'data',
        'flutter_assets',
        'packages',
        'pdf_editor',
        'assets',
        asset);

    return Uri.file(assetsDirectory).toString();
  }

  @override
  void dispose() {
    visibleStream.close();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: VisibilityDetector(
        key: Key(key),
        onVisibilityChanged: (VisibilityInfo info) async {
          if (!visibleStream.isClosed) {
            cachedVisibleDecimal = info.visibleFraction == 1
                ? (info.size.height / widget.otherOptions.height).clamp(0, 1)
                : info.visibleFraction;
            visibleStream.add(info.visibleFraction == 1
                ? (info.size.height / widget.otherOptions.height).clamp(0, 1)
                : info.visibleFraction);
          }
        },
        child: Container(
          height: docHeight + 10,
          decoration: widget.otherOptions.decoration,
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<bool>(
                    future: pdfViewerInit,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Webview(
                          _controller,
                        );
                      } else {
                        return Container(
                            height: widget.htmlEditorOptions.autoAdjustHeight
                                ? docHeight
                                : widget.otherOptions.height);
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
