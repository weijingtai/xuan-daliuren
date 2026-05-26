import 'package:flutter/material.dart';
import 'package:daliuren/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大六壬 Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SelectionPage(),
      onGenerateRoute: NavigatorGenerator.generateRoute,
    );
  }
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('大六壬架构选择')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/daliuren/old');
              },
              child: const Text('老架构 (Direct View)'),
            ),
            const SizedBox(height: 24),
 ElevatedButton(
 onPressed: () {
 Navigator.of(context).pushNamed('/daliuren');
 },
 child: const Text('新架构 (DaLiuRenView)'),
 ),
 const SizedBox(height: 24),
 ElevatedButton(
 onPressed: () {
 Navigator.of(context).pushNamed('/daliuren/new');
 },
 child: const Text('旧架构新UI (Design System)'),
 ),
 const SizedBox(height: 24),
 ElevatedButton(
 onPressed: () {
 Navigator.of(context).pushNamed('/daliuren/dev');
 },
 child: const Text('多流派调试 (DevPage)'),
 ),
          ],
        ),
      ),
    );
  }
}
