import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_application_4/database/database_helper.dart';
import 'package:logger/logger.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  BackupPageState createState() => BackupPageState();
}

class BackupPageState extends State<BackupPage> {
  final logger = Logger();

  // 백업 데이터 처리
  Future<void> backupData() async {
    try {
      // MANAGE_EXTERNAL_STORAGE 권한 요청
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        // 다운로드 폴더 경로 지정
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          final file = File('${directory.path}/GB_N.csv');
          final contacts = await DatabaseHelper.instance.getContacts();

          String csvData = 'Name,Number\n';
          for (final contact in contacts) {
            csvData += '${contact['name']},${contact['number']}\n';
          }

          await file.writeAsString(csvData);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('백업이 완료되었습니다.')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('다운로드 폴더가 존재하지 않습니다.')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('저장소 권한이 허용되지 않았습니다.')),
          );
        }
      }
    } catch (e) {
      logger.e('백업 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('백업 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  // 데이터 복원 처리
  Future<void> restoreData() async {
    try {
      final params = OpenFileDialogParams();
      final filePath = await FlutterFileDialog.pickFile(params: params);

      if (filePath != null) {
        final file = File(filePath);
        final contents = await file.readAsString();
        final lines = contents.split('\n');

        if (mounted) {
          for (int i = 1; i < lines.length; i++) {
            final line = lines[i];
            if (line.isNotEmpty) {
              final parts = line.split(',');
              if (parts.length == 2) {
                try {
                  final existingContacts =
                      await DatabaseHelper.instance.searchContacts(parts[0]);
                  if (existingContacts.isEmpty ||
                      !existingContacts
                          .any((contact) => contact['number'] == parts[1])) {
                    await DatabaseHelper.instance
                        .insertContact({'name': parts[0], 'number': parts[1]});
                  }
                } catch (e) {
                  logger.e('데이터 삽입 오류: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('일부 데이터 복원 중 오류가 발생했습니다.')));
                  }
                }
              }
            }
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('복원이 완료되었습니다.')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("파일 선택이 취소되었습니다.")),
          );
        }
      }
    } catch (e) {
      logger.e('복원 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('복원 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('백업 및 복원'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: backupData,
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
