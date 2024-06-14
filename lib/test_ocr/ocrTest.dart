// import 'package:flutter/material.dart';
// import 'package:ocr_scan_text/ocr_scan_text.dart';
// import 'scan_all_module.dart';
//
// class OcrTest extends StatefulWidget {
//   const OcrTest({super.key});
//
//   @override
//   State<OcrTest> createState() => _OcrTestState();
// }
//
// class _OcrTestState extends State<OcrTest> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan"),
//       ),
//       body: Center(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width - 20,
//           height: MediaQuery.of(context).size.height - 40,
//           child: _buildLiveScan(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//
//         },
//       ),
//     );
//   }
//
//   Widget _buildLiveScan() {
//     return LiveScanWidget(
//       ocrTextResult: (ocrTextResult) {
//         ocrTextResult.mapResult.forEach((module, result) {
//           print(result);
//         });
//       },
//       scanModules: [ScanAllModule()],
//     );
//   }
// }