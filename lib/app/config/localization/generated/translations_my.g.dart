///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsMy extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsMy({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.my,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <my>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsMy _root = this; // ignore: unused_field

	@override 
	TranslationsMy $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsMy(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$my app = _Translations$app$my._(_root);
	@override late final _Translations$common$my common = _Translations$common$my._(_root);
	@override late final _Translations$auth$my auth = _Translations$auth$my._(_root);
	@override late final _Translations$home$my home = _Translations$home$my._(_root);
	@override late final _Translations$posts$my posts = _Translations$posts$my._(_root);
	@override late final _Translations$settings$my settings = _Translations$settings$my._(_root);
}

// Path: app
class _Translations$app$my extends Translations$app$en {
	_Translations$app$my._(TranslationsMy root) : this._root = root, super.internal(root);

	final TranslationsMy _root; // ignore: unused_field

	// Translations
	@override String get name => 'Clean Architecture Starter';
}

// Path: common
class _Translations$common$my extends Translations$common$en {
	_Translations$common$my._(TranslationsMy root) : this._root = root, super.internal(root);

	final TranslationsMy _root; // ignore: unused_field

	// Translations
	@override String get retry => 'ပြန်ကြိုးစားရန်';
	@override String get cancel => 'ပယ်ဖျက်ရန်';
	@override String get tryAgain => 'ထပ်မံကြိုးစားရန်';
	@override String get somethingWentWrong => 'တစ်ခုခု မှားယွင်းနေပါသည်';
	@override String get offline => 'အင်တာနက် ချိတ်ဆက်မှု မရှိပါ။';
	@override String get onlineRestored => 'အင်တာနက် ပြန်လည် ချိတ်ဆက်ပြီးပါပြီ။';
	@override String get noInternetTitle => 'အင်တာနက် မရှိပါ';
	@override String get checkConnection => 'ချိတ်ဆက်မှုကို စစ်ဆေးပြီး ထပ်မံကြိုးစားပါ။';
}

// Path: auth
class _Translations$auth$my extends Translations$auth$en {
	_Translations$auth$my._(TranslationsMy root) : this._root = root, super.internal(root);

	final TranslationsMy _root; // ignore: unused_field

	// Translations
	@override String get demoChip => 'DEMO';
	@override String get welcomeBack => 'ပြန်လည်ကြိုဆိုပါတယ်';
	@override String get signInSubtitle => 'အကောင့်သို့ ဝင်ရောက်ပါ';
	@override String get username => 'အသုံးပြုသူအမည်';
	@override String get usernameHint => 'အသုံးပြုသူအမည် သို့မဟုတ် အီးမေးလ် ထည့်ပါ';
	@override String get usernameRequired => 'အသုံးပြုသူအမည် ထည့်ပါ';
	@override String get password => 'စကားဝှက်';
	@override String get passwordHint => 'စကားဝှက် ထည့်ပါ';
	@override String get passwordRequired => 'စကားဝှက် ထည့်ပါ';
	@override String get login => 'ဝင်ရန်';
	@override String get signInWithGoogle => 'Google ဖြင့် ဝင်ရန်';
	@override String get demoHint => 'Demo: အီးမေးလ် + စကားဝှက် 123456';
	@override String welcome({required Object name}) => 'မင်္ဂလာပါ၊ ${name}!';
	@override String emailLabel({required Object email}) => 'အီးမေးလ်: ${email}';
	@override String authTypeLabel({required Object type}) => 'အမျိုးအစား: ${type}';
	@override String get updateSameName => 'နာမည်အတူ ထပ်ပြင်ရန်';
	@override String get updateNewName => 'နာမည်အသစ် ပြောင်းရန်';
	@override String get logOut => 'ထွက်ရန်';
	@override String get tryAgain => 'ထပ်မံကြိုးစားရန်';
}

// Path: home
class _Translations$home$my extends Translations$home$en {
	_Translations$home$my._(TranslationsMy root) : this._root = root, super.internal(root);

	final TranslationsMy _root; // ignore: unused_field

	// Translations
	@override String get title => 'ပင်မ';
}

// Path: posts
class _Translations$posts$my extends Translations$posts$en {
	_Translations$posts$my._(TranslationsMy root) : this._root = root, super.internal(root);

	final TranslationsMy _root; // ignore: unused_field

	// Translations
	@override String get title => 'ပို့စ်များ';
	@override String get empty => 'ပို့စ် မရှိသေးပါ။';
	@override String get detailTitle => 'ပို့စ်';
	@override String get highlightBanner => 'Deep link (?highlight=true) ဖြင့် ဖွင့်ထားသည်';
	@override String idLabel({required Object id}) => 'ID: ${id}';
	@override String get createTitle => 'ပို့စ် အသစ်';
	@override String get titleField => 'ခေါင်းစဉ်';
	@override String get titleHint => 'အနည်းဆုံး ၃ လုံး (forbidden စမ်းကြည့်ပါ)';
	@override String get bodyField => 'အကြောင်းအရာ';
	@override String get bodyHint => 'အနည်းဆုံး ၁၀ လုံး';
	@override String get validationHint => 'Server field errors ကို FormFieldErrors.fromApi ဖြင့် map သည်။';
	@override String get submit => 'ဖန်တီးရန်';
	@override String get created => 'ပို့စ် ဖန်တီးပြီးပါပြီ';
}

// Path: settings
class _Translations$settings$my extends Translations$settings$en {
	_Translations$settings$my._(TranslationsMy root) : this._root = root, super.internal(root);

	final TranslationsMy _root; // ignore: unused_field

	// Translations
	@override String get title => 'ဆက်တင်';
	@override String get flavor => 'Flavor';
	@override String get darkMode => 'အမှောင်မုဒ်';
	@override String get language => 'ဘာသာစကား';
}

/// The flat map containing all translations for locale <my>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsMy {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Clean Architecture Starter',
			'common.retry' => 'ပြန်ကြိုးစားရန်',
			'common.cancel' => 'ပယ်ဖျက်ရန်',
			'common.tryAgain' => 'ထပ်မံကြိုးစားရန်',
			'common.somethingWentWrong' => 'တစ်ခုခု မှားယွင်းနေပါသည်',
			'common.offline' => 'အင်တာနက် ချိတ်ဆက်မှု မရှိပါ။',
			'common.onlineRestored' => 'အင်တာနက် ပြန်လည် ချိတ်ဆက်ပြီးပါပြီ။',
			'common.noInternetTitle' => 'အင်တာနက် မရှိပါ',
			'common.checkConnection' => 'ချိတ်ဆက်မှုကို စစ်ဆေးပြီး ထပ်မံကြိုးစားပါ။',
			'auth.demoChip' => 'DEMO',
			'auth.welcomeBack' => 'ပြန်လည်ကြိုဆိုပါတယ်',
			'auth.signInSubtitle' => 'အကောင့်သို့ ဝင်ရောက်ပါ',
			'auth.username' => 'အသုံးပြုသူအမည်',
			'auth.usernameHint' => 'အသုံးပြုသူအမည် သို့မဟုတ် အီးမေးလ် ထည့်ပါ',
			'auth.usernameRequired' => 'အသုံးပြုသူအမည် ထည့်ပါ',
			'auth.password' => 'စကားဝှက်',
			'auth.passwordHint' => 'စကားဝှက် ထည့်ပါ',
			'auth.passwordRequired' => 'စကားဝှက် ထည့်ပါ',
			'auth.login' => 'ဝင်ရန်',
			'auth.signInWithGoogle' => 'Google ဖြင့် ဝင်ရန်',
			'auth.demoHint' => 'Demo: အီးမေးလ် + စကားဝှက် 123456',
			'auth.welcome' => ({required Object name}) => 'မင်္ဂလာပါ၊ ${name}!',
			'auth.emailLabel' => ({required Object email}) => 'အီးမေးလ်: ${email}',
			'auth.authTypeLabel' => ({required Object type}) => 'အမျိုးအစား: ${type}',
			'auth.updateSameName' => 'နာမည်အတူ ထပ်ပြင်ရန်',
			'auth.updateNewName' => 'နာမည်အသစ် ပြောင်းရန်',
			'auth.logOut' => 'ထွက်ရန်',
			'auth.tryAgain' => 'ထပ်မံကြိုးစားရန်',
			'home.title' => 'ပင်မ',
			'posts.title' => 'ပို့စ်များ',
			'posts.empty' => 'ပို့စ် မရှိသေးပါ။',
			'posts.detailTitle' => 'ပို့စ်',
			'posts.highlightBanner' => 'Deep link (?highlight=true) ဖြင့် ဖွင့်ထားသည်',
			'posts.idLabel' => ({required Object id}) => 'ID: ${id}',
			'posts.createTitle' => 'ပို့စ် အသစ်',
			'posts.titleField' => 'ခေါင်းစဉ်',
			'posts.titleHint' => 'အနည်းဆုံး ၃ လုံး (forbidden စမ်းကြည့်ပါ)',
			'posts.bodyField' => 'အကြောင်းအရာ',
			'posts.bodyHint' => 'အနည်းဆုံး ၁၀ လုံး',
			'posts.validationHint' => 'Server field errors ကို FormFieldErrors.fromApi ဖြင့် map သည်။',
			'posts.submit' => 'ဖန်တီးရန်',
			'posts.created' => 'ပို့စ် ဖန်တီးပြီးပါပြီ',
			'settings.title' => 'ဆက်တင်',
			'settings.flavor' => 'Flavor',
			'settings.darkMode' => 'အမှောင်မုဒ်',
			'settings.language' => 'ဘာသာစကား',
			_ => null,
		};
	}
}
