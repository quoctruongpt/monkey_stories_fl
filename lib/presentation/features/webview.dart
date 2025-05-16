import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

final logger = Logger('WebViewScreen');

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({super.key, required this.title, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onPageStarted: (String url) {
                setState(() {
                  _progress = 0.0;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _progress = 1.0;
                });
              },
              onWebResourceError: (WebResourceError error) {
                // You can add error handling here if needed
                logger.severe('WebResourceError: ${error.description}');
              },
              onNavigationRequest: (NavigationRequest request) {
                // You can decide here if you want to navigate to the request.url
                // For now, allow all navigation
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context).translate(widget.title),
        // Add the progress bar to the AppBar for a cleaner look,
        // or keep it in a Stack as shown below.
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_progress < 1.0 &&
              _progress > 0.0) // Show progress only during loading
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
