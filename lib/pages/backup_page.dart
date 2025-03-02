import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_application_4/database/database_helper.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  BackupPageState createState() => BackupPageState();
}

class BackupPageState extends State<BackupPage> {
  Future<void> _backupData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/backup.txt');
    final contacts = await DatabaseHelper.instance.getContacts();
    final backupData = contacts.map((contact) {
      return 'Name: ${contact['name']}, Number: ${contact['number']}';
    }).join('\n');

    await file.writeAsString(backupData);
    await Share.share('데이터 백업 파일입니다. 파일을 첨부합니다.', subject: '백업 파일');
  }

  Future<void> restoreData() async {
    final params = OpenFileDialogParams();
    final filePath = await FlutterFileDialog.pickFile(params: params);

    if (filePath != null) {
      final file = File(filePath);
      final contents = await file.readAsString();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('복원이 완료되었습니다: $contents')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('백업 및 복원'),
        backgroundColor: Colors.purple[100], // 연한 보라색 적용
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _backupData,
              icon: const Icon(Icons.backup),
              label: const Text('백업하기'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: restoreData,
              icon: const Icon(Icons.restore),
              label: const Text('복원하기'),
            ),
          ],
        ),
      ),
    );
  }
}
