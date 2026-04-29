import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_di_test/main.dart'; // သင့် main.dart ကို import လုပ်ပါ

void main() {
  testWidgets('App should render AuthPage with Sign In buttons', (WidgetTester tester) async {
    // 1. Riverpod သုံးထားသောကြောင့် Widget Test တွင်လည်း ProviderScope ဖြင့် အုပ်ပေးရမည်
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // 2. UI ပေါ်လာရန် စောင့်ခြင်း
    await tester.pumpAndSettle();

    // 3. 'Sign in with Google' ဆိုသော စာသား ပါ/မပါ စစ်ဆေးခြင်း
    expect(find.text('Sign in with Google'), findsOneWidget);

    // 4. 'Traditional Sign in' ဆိုသော စာသား ပါ/မပါ စစ်ဆေးခြင်း
    expect(find.text('Traditional Sign in (Correct)'), findsOneWidget);
  });
}
