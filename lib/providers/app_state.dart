class AppState {
  final String? username;
  final String? token;
  final List<dynamic> menus;

  AppState({
    this.username,
    this.token,
    this.menus = const [],
  });

  AppState copyWith({
    String? username,
    String? token,
    List<dynamic>? menus,
  }) {
    return AppState(
      username: username ?? this.username,
      token: token ?? this.token,
      menus: menus ?? this.menus,
    );
  }

  static AppState initial() => AppState(username: null, token: null, menus: []);
}

class LoginAction {
  final String username;
  final String token;

  LoginAction(this.username, this.token);
}

class LogoutAction {}

class SetMenusAction {
  final List<dynamic> menus;

  SetMenusAction(this.menus);
}

AppState appReducer(AppState state, dynamic action) {
  if (action is LoginAction) {
    return state.copyWith(username: action.username, token: action.token);
  } else if (action is LogoutAction) {
    return AppState.initial();
  } else if (action is SetMenusAction) {
    return state.copyWith(menus: action.menus);
  }

  return state;
}
