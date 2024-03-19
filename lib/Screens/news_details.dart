import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetails extends StatefulWidget {
  final Map<String, dynamic> news;
  const NewsDetails({super.key, required this.news});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  bool isloading = true;
  int progress = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progressInt) {
            progress = progressInt;
            if (progress > 90) {
              isloading = false;
            } else {
              isloading = true;
            }
            print("WebView is loading: Progress($progress%)");
            setState(() {});
          },
          onPageStarted: (String url) {
            print("Page Is Starting:($url)");
          },
          onPageFinished: (String url) {
            print("Page has Finished: ($url)");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.news['url']));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.news['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Visibility(
                  visible: isloading,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.blueAccent,
                    minHeight: 3,
                    value: progress / 100,
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 1),
              height: size.height * 0.8,
              child: WebViewWidget(controller: webViewController),
            )
          ],
        ),
      ),
    );
  }
}
