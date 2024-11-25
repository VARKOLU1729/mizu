import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'dart:ffi';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final JavascriptRuntime javascriptRuntime = getJavascriptRuntime();
  String result = "Nothing";

  void callJsFunction() {
    String jsCode = """
      function greet(name) {
        return "Hello, " + name + "! Welcome to Flutter_JS.";
      }
      greet('Vijay');
    """;

    // Evaluate the JavaScript function
    final jsResult = javascriptRuntime.evaluate(jsCode);
    setState(() {
      result = jsResult.stringResult;
    });
  }


  void callExternalFunction() async {
    String jsCode = await rootBundle.loadString('assets/test.js');
    final x = javascriptRuntime.evaluate(jsCode);
    print(x.isError);


    // Evaluate the JavaScript function
    final jsResult = javascriptRuntime.evaluate("greet('vijay');");
    setState(() {
      result = jsResult.stringResult;
    });
  }

  void callWebphone() async
  {
    String password = r"$eWPQD!Ypy";

    final onLoadedCallbackCode = '''
    webphone_api.onAppStateChange(function (state){
        console.log("on onAppStateChange event: "+state);
    });
    webphone_api.onLoaded(function() {
      console.log("Webphone initialized successfully");
      webphone_api.setparameter('serveraddress', 'sip-bgn-int.ttsl.tel:49868', false);
      webphone_api.setparameter('username', '0605405970002', false);
      webphone_api.setparameter('password', '$password', false);
      webphone_api.setparameter('callto', '6301450563', false);
      webphone_api.register();
    });
    console.log("into callback...........");
  ''';

    final getRegFailReason = '''
    console.log("Calling getregfailreason...");
    webphone_api.getregfailreason(function(state) {
        console.log("Registration Failure Reason: " + state);
    }, true);
    ''';

    final onEvent = '''
    webphone_api.onEvent(function (type, evt)
    {
        console.log(type+evt);
    });
    ''';

    final onRegStateChange = '''
    console.log("Calling onRegStateChange...");
    webphone_api.onRegStateChange(function(state, reason) {
        if (state === "registered") {
            console.log("Webphone is registered.");
        } else if (state === "unregistered") {
            console.log("Webphone is unregistered.");
        } else if (state === "failed") {
            console.log("Registration failed. Reason: " + reason);
        } else {
            console.log("Unknown registration state: " + state);
        }
    });
    ''';


    String jsCode = await rootBundle.loadString('assets/webphone/webphone_api.js');
    final x = await javascriptRuntime.evaluateAsync(jsCode);
    x.isError ? print("error in loading"):{print("loaded successfully")};
    String jsCode1 = await rootBundle.loadString('assets/webphone/js/lib/lib_webphone.js');
    final x1 = await javascriptRuntime.evaluateAsync(jsCode1);
    x1.isError ? print("error in loading"):{print("loaded successfully")};
    await javascriptRuntime.evaluateAsync(onLoadedCallbackCode);
    await javascriptRuntime.evaluateAsync(onEvent);
    await javascriptRuntime.evaluateAsync("webphone_api.start();");
    await javascriptRuntime.evaluateAsync("webphone_api.register();");
    await Future.delayed(Duration(seconds: 3));
    await javascriptRuntime.evaluateAsync(onRegStateChange);
    final jsRes = await javascriptRuntime.evaluateAsync("webphone_api.isregistered();");
    print(jsRes.stringResult);
    await javascriptRuntime.evaluateAsync(getRegFailReason);
    await javascriptRuntime.evaluateAsync("webphone_api.call('+916301450563');");
  }
  

  @override
  void initState()
  {
      super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text('Flutter JS Example', style: TextStyle(color: Colors.white),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: callExternalFunction,
              child: Text('Call JavaScript Function'),
            ),
            ElevatedButton(
              onPressed: callWebphone,
              child: Text('Call webPhone'),
            ),
          ],
        ),
      ),
    );
  }
}
