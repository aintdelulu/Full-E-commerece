import 'user.dart';

class AuthService {
  static AppUser? _currentUser;

  // Predefined mock users list with dummy weeklyOrders
  static final List<AppUser> _users = [
    AppUser(
      username: 'admin',
      password: 'admin123',
      isAdmin: true,
      email: 'admin@example.com',
      weeklyOrders: [5, 4, 3, 6, 4], // Mon–Fri
    ),
    AppUser(
      username: 'user',
      password: 'user123',
      isAdmin: false,
      email: 'user@example.com',
      weeklyOrders: [2, 3, 1, 2, 3],
    ),
    AppUser(
      username: 'alice',
      password: 'alice123',
      isAdmin: false,
      email: 'alice@example.com',
      weeklyOrders: [3, 3, 4, 4, 2],
    ),
    AppUser(
      username: 'bob',
      password: 'bob123',
      isAdmin: false,
      email: 'bob@example.com',
      weeklyOrders: [1, 2, 2, 3, 2],
    ),
    AppUser(
      username: 'corre',
      password: 'corre123',
      isAdmin: false,
      email: 'corre@example.com',
      weeklyOrders: [4, 5, 3, 4, 5],
    ),
    AppUser(
      username: 'ivan',
      password: 'ivan123',
      isAdmin: false,
      email: 'ivan@example.com',
      weeklyOrders: [2, 2, 1, 3, 2],
    ),
    AppUser(
      username: 'james',
      password: 'james123',
      isAdmin: false,
      email: 'james@example.com',
      weeklyOrders: [5, 5, 5, 5, 5],
    ),
  ];

  /// Public: get all users
  static List<AppUser> get users => List.unmodifiable(_users);

  /// Public: get currently logged-in user
  static AppUser? get currentUser => _currentUser;

  /// Check if logged in
  static bool isLoggedIn() => _currentUser != null;

  /// Check if the current user is an admin
  static bool isAdmin() => _currentUser?.isAdmin ?? false;

  /// Login user by username and password
  static bool login(String username, String password) {
    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Logout the current user
  static void logout() {
    _currentUser = null;
  }

  /// Check if username exists
  static bool usernameExists(String username) {
    return _users.any((u) => u.username.toLowerCase() == username.toLowerCase());
  }

  /// Register a new user (mock, in-memory only)
  static bool register(String username, String password, String email, {bool isAdmin = false}) {
    if (usernameExists(username)) return false;

    _users.add(
      AppUser(
        username: username,
        password: password,
        email: email,
        isAdmin: isAdmin,
        weeklyOrders: [0, 0, 0, 0, 0],
      ),
    );
    return true;
  }
}
