///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$home$en home = Translations$home$en.internal(_root);
	late final Translations$posts$en posts = Translations$posts$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Clean Architecture Starter'
	String get name => 'Clean Architecture Starter';
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Try again'
	String get tryAgain => 'Try again';

	/// en: 'Something went wrong'
	String get somethingWentWrong => 'Something went wrong';

	/// en: 'You are currently offline.'
	String get offline => 'You are currently offline.';

	/// en: 'Your internet connection was restored.'
	String get onlineRestored => 'Your internet connection was restored.';

	/// en: 'No Internet Connection'
	String get noInternetTitle => 'No Internet Connection';

	/// en: 'Check your connection and try again.'
	String get checkConnection => 'Check your connection and try again.';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'DEMO'
	String get demoChip => 'DEMO';

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Sign in to your account'
	String get signInSubtitle => 'Sign in to your account';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Enter your username or email'
	String get usernameHint => 'Enter your username or email';

	/// en: 'Please enter your username'
	String get usernameRequired => 'Please enter your username';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Enter your password'
	String get passwordHint => 'Enter your password';

	/// en: 'Please enter your password'
	String get passwordRequired => 'Please enter your password';

	/// en: 'Sign in'
	String get login => 'Sign in';

	/// en: 'Sign in with Google'
	String get signInWithGoogle => 'Sign in with Google';

	/// en: 'Demo: any email + password 123456'
	String get demoHint => 'Demo: any email + password 123456';

	/// en: 'Welcome, $name!'
	String welcome({required Object name}) => 'Welcome, ${name}!';

	/// en: 'Email: $email'
	String emailLabel({required Object email}) => 'Email: ${email}';

	/// en: 'Auth: $type'
	String authTypeLabel({required Object type}) => 'Auth: ${type}';

	/// en: 'Update with SAME name'
	String get updateSameName => 'Update with SAME name';

	/// en: 'Update with NEW name'
	String get updateNewName => 'Update with NEW name';

	/// en: 'Log out'
	String get logOut => 'Log out';

	/// en: 'Try again'
	String get tryAgain => 'Try again';
}

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get title => 'Home';
}

// Path: posts
class Translations$posts$en {
	Translations$posts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Posts'
	String get title => 'Posts';

	/// en: 'No posts yet.'
	String get empty => 'No posts yet.';

	/// en: 'Post'
	String get detailTitle => 'Post';

	/// en: 'Opened via deep link (?highlight=true)'
	String get highlightBanner => 'Opened via deep link (?highlight=true)';

	/// en: 'ID: $id'
	String idLabel({required Object id}) => 'ID: ${id}';

	/// en: 'Create post'
	String get createTitle => 'Create post';

	/// en: 'Title'
	String get titleField => 'Title';

	/// en: 'At least 3 characters (try “forbidden”)'
	String get titleHint => 'At least 3 characters (try “forbidden”)';

	/// en: 'Body'
	String get bodyField => 'Body';

	/// en: 'At least 10 characters'
	String get bodyHint => 'At least 10 characters';

	/// en: 'Server field errors map via FormFieldErrors.fromApi.'
	String get validationHint => 'Server field errors map via FormFieldErrors.fromApi.';

	/// en: 'Create'
	String get submit => 'Create';

	/// en: 'Post created'
	String get created => 'Post created';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Flavor'
	String get flavor => 'Flavor';

	/// en: 'Dark mode'
	String get darkMode => 'Dark mode';

	/// en: 'Language'
	String get language => 'Language';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Clean Architecture Starter',
			'common.retry' => 'Retry',
			'common.cancel' => 'Cancel',
			'common.tryAgain' => 'Try again',
			'common.somethingWentWrong' => 'Something went wrong',
			'common.offline' => 'You are currently offline.',
			'common.onlineRestored' => 'Your internet connection was restored.',
			'common.noInternetTitle' => 'No Internet Connection',
			'common.checkConnection' => 'Check your connection and try again.',
			'auth.demoChip' => 'DEMO',
			'auth.welcomeBack' => 'Welcome Back',
			'auth.signInSubtitle' => 'Sign in to your account',
			'auth.username' => 'Username',
			'auth.usernameHint' => 'Enter your username or email',
			'auth.usernameRequired' => 'Please enter your username',
			'auth.password' => 'Password',
			'auth.passwordHint' => 'Enter your password',
			'auth.passwordRequired' => 'Please enter your password',
			'auth.login' => 'Sign in',
			'auth.signInWithGoogle' => 'Sign in with Google',
			'auth.demoHint' => 'Demo: any email + password 123456',
			'auth.welcome' => ({required Object name}) => 'Welcome, ${name}!',
			'auth.emailLabel' => ({required Object email}) => 'Email: ${email}',
			'auth.authTypeLabel' => ({required Object type}) => 'Auth: ${type}',
			'auth.updateSameName' => 'Update with SAME name',
			'auth.updateNewName' => 'Update with NEW name',
			'auth.logOut' => 'Log out',
			'auth.tryAgain' => 'Try again',
			'home.title' => 'Home',
			'posts.title' => 'Posts',
			'posts.empty' => 'No posts yet.',
			'posts.detailTitle' => 'Post',
			'posts.highlightBanner' => 'Opened via deep link (?highlight=true)',
			'posts.idLabel' => ({required Object id}) => 'ID: ${id}',
			'posts.createTitle' => 'Create post',
			'posts.titleField' => 'Title',
			'posts.titleHint' => 'At least 3 characters (try “forbidden”)',
			'posts.bodyField' => 'Body',
			'posts.bodyHint' => 'At least 10 characters',
			'posts.validationHint' => 'Server field errors map via FormFieldErrors.fromApi.',
			'posts.submit' => 'Create',
			'posts.created' => 'Post created',
			'settings.title' => 'Settings',
			'settings.flavor' => 'Flavor',
			'settings.darkMode' => 'Dark mode',
			'settings.language' => 'Language',
			_ => null,
		};
	}
}
