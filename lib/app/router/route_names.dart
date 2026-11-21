/// Centralised route paths & names — navigate with `context.goNamed(...)`.
class RouteNames {
  const RouteNames._();

  static const String auth = 'auth';
  static const String authPath = '/auth';

  static const String home = 'home';
  static const String homePath = '/home';

  static const String posts = 'posts';
  static const String postsPath = '/posts';

  static const String postDetail = 'postDetail';
  static const String postDetailPath = '/posts/:id';

  static const String createPost = 'createPost';
  static const String createPostPath = '/posts/create';

  static const String settings = 'settings';
  static const String settingsPath = '/settings';
}
