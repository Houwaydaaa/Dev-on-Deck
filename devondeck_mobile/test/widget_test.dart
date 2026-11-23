
import 'package:flutter_test/flutter_test.dart';
import 'package:devondeck_mobile/main.dart';

// Houni ntestiw ken el application tet7al correctement
void main() {
  testWidgets('DevOnDeck application loads correctly',
      (WidgetTester tester) async {

    // Nlanciw el application
    await tester.pumpWidget(const DevOnDeckApp());

    // Nthabtou eli esm el application mawjoud
    expect(find.text('DevOnDeck'), findsOneWidget);

    // Nthabtou eli section competences mawjouda
    expect(find.text('Compétences supplémentaires'), findsOneWidget);
  });
}
