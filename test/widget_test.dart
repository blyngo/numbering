import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_4/main.dart'; // main.dart 경로 수정

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 앱을 빌드하고 프레임을 트리거합니다.
    await tester.pumpWidget(const MyApp());

    // 카운터가 0부터 시작하는지 확인합니다.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // '+' 아이콘을 탭하고 프레임을 트리거합니다.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 카운터가 증가했는지 확인합니다.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
