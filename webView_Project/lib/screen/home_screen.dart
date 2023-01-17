import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class  HomeScreen extends StatelessWidget {
  WebViewController? controller;
  final homeURL = "https://blog.codefactory.ai";

  HomeScreen ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Code Factory'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (controller == null) { return; }
                controller!.loadUrl(homeURL);
              },
              icon: Icon(
                Icons.home,
              )
          )
        ],
      ),
      body: WebView(
        initialUrl: homeURL,
        // webview 가 생성됐을 경우 함수를 받는다.
        onWebViewCreated: (WebViewController controller){
          this.controller = controller;
        } ,
      ),
    );
  }
}

