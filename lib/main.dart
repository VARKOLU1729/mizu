import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

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
    // String password = r"$eWPQD!Ypy";
    // String jsCode = await rootBundle.loadString('assets/webphone_api.js');
    // final x = javascriptRuntime.evaluate(jsCode);
    final x = await javascriptRuntime.evaluateAsync('ensure();', sourceUrl: 'assets/webphone_api.js');
    javascriptRuntime.executePendingJob();
    JsEvalResult asyncResult = await javascriptRuntime.handlePromise(x);
    print(asyncResult.stringResult);
    // javascriptRuntime.evaluate("webphone_api.register();");
    final jsRes = await javascriptRuntime.evaluateAsync("ensure();");
    print(jsRes.stringResult);
  }
  

  @override
  void initState()
  {
      super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter JS Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, style: TextStyle(fontSize: 20)),
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
