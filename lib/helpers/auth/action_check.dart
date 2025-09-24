bool hasMenuAction(List<dynamic> menus, String menuName, String action) {
  final menu = menus.firstWhere(
    (m) => m['name'] == menuName,
    orElse: () => null,
  );

  if (menu == null) return false;

  final actions = List<String>.from(menu['actions'] ?? []);

  return actions.contains(action);
}
