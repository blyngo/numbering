import 'package:flutter/material.dart';
import 'package:flutter_application_4/database/database_helper.dart';

class InputPage extends StatefulWidget {
  final VoidCallback onItemAdded;

  const InputPage({super.key, required this.onItemAdded});

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  bool isCard = false;

  Future<void> _addContact() async {
    final name = nameController.text.trim();
    String number = numberController.text.trim();

    if (isCard) {
      number = '카드 $number';
    }

    if (name.isNotEmpty && number.isNotEmpty) {
      await DatabaseHelper.instance.insertContact({
        'name': name,
        'number': number,
      });
      widget.onItemAdded();
      // 입력 필드 초기화
      nameController.clear();
      numberController.clear();
      isCard = false;
      setState(() {}); // 상태 업데이트
      if (mounted) {
        // mounted 체크 추가
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('항목 추가'),
        backgroundColor: Colors.purple[100], // 연한 보라색 적용
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: '번호'),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: const Text('카드 번호로 추가'),
              value: isCard,
              onChanged: (value) {
                setState(() {
                  isCard = value ?? false;
                });
              },
            ),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
