import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('Affichage de la page profil', (WidgetTester tester) async {
    await tester.pumpWidget(const DevOnDeckApp());

    expect(find.text('Mon profil développeur'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}