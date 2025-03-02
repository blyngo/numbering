import 'package:flutter/material.dart';
import 'package:flutter_application_4/database/database_helper.dart';
import 'package:flutter_application_4/pages/backup_page.dart';
import 'package:flutter_application_4/pages/input_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _contacts = [];
  bool isSpecialSearch = false; // 특수 검색어 상태

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchContacts([String query = '']) async {
    final contacts = await DatabaseHelper.instance.getContacts();

    setState(() {
      if (query.isEmpty) {
        // 검색어가 비어있을 때는 아무것도 표시하지 않음
        _contacts = [];
        isSpecialSearch = false;
      } else if (["all", "모두", "전부", "전체"].contains(query.toLowerCase())) {
        // 특수 검색어일 때 모든 카드 표시
        _contacts = contacts;
        isSpecialSearch = true;
      } else {
        // 일반 검색어일 때 일치하는 카드만 표시
        _contacts = contacts.where((contact) {
          final name = contact['name'] ?? '';
          final number = contact['number'] ?? '';
          return name.contains(query) || number.contains(query);
        }).toList();
        isSpecialSearch = false;
      }
    });
  }

  Future<void> _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    await _fetchContacts(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 기능'),
        backgroundColor: Colors.purple[100], // 연한 보라색
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BackupPage())),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InputPage(
                        onItemAdded: () =>
                            _fetchContacts(_controller.text.trim())))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '숫자나 이름을 입력하세요',
                border: UnderlineInputBorder(),
              ),
              onChanged: _fetchContacts,
            ),
            Expanded(
              child: _contacts.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다'))
                  : ListView.builder(
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        final contact = _contacts[index];
                        return ListTile(
                          title: Text(contact['name']),
                          subtitle: Text(contact['number']),
                          trailing: isSpecialSearch
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red), // 빨간색 쓰레기통
                                  onPressed: () =>
                                      _deleteContact(contact['id']),
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
