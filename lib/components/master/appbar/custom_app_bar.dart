import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/action_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onReturn;
  final List<Widget>? actions;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final bool isWithNotification;
  final int notificationCount;
  final VoidCallback? onNotifications;
  final String notificationTooltip;
=======
>>>>>>> d8439a4 (fix: refactor code)
  final bool isWithAccount;
  final bool showAvatar;
=======
  final bool isWithNotification;
<<<<<<< HEAD
<<<<<<< HEAD
  final int notificationCount;
  final VoidCallback? onNotifications;
  final String notificationTooltip;
<<<<<<< HEAD
=======
  final int reworkNotificationCount;
  final VoidCallback? onReworkNotifications;
  final bool isWithBsNotification;
  final int bsNotificationCount;
  final VoidCallback? onBsNotifications;
>>>>>>> 83f4dcb (feat: notifikasi evaluasi bs)
=======
  final int notificationCount;
  final VoidCallback? onNotifications;
  final String notificationTooltip;
>>>>>>> 07c9d40 (fix: notification all evaluasi)
=======
  final bool isWithAnomalyNotification;
  final int anomalyNotificationCount;
  final VoidCallback? onAnomalyNotifications;
  final String anomalyNotificationTooltip;
>>>>>>> d94a57a (feat:)
  final bool isWithAccount;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
  final bool isWithNotification;
  final bool isWithAccount;
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
  final bool showAvatar;
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
>>>>>>> b1c3b09b (fix: user name di appbar)
=======
  final bool showAvatar;
>>>>>>> aa863171 (fix: responsive UI to mobile)
  final bool showNameWithAvatar;
  final tab;
  final bool? canDelete;
  final bool? canUpdate;
  final handleDelete;
  final handleUpdate;
  final handleFinish;
  final handleLogout;
  final id;
  final label;
  final user;
  final deleteStatus;
  final updateStatus;
  final isTextEditor;
  final handleSave;
  final name;
  final bool isLoading;
  final bool isDashboardSettingsLoading;
  final VoidCallback? onDashboardSettings;
<<<<<<< HEAD
<<<<<<< HEAD
  final VoidCallback? onReportSettings;
<<<<<<< HEAD
<<<<<<< HEAD
  final VoidCallback? onEdit;
<<<<<<< HEAD
=======
>>>>>>> 7a6aa3b1 (feat: model for report)
=======
>>>>>>> 5e1caa7c (feat: widget controller)
=======
  final VoidCallback? onReportSettings;
>>>>>>> 65038198 (feat:)
=======
  final VoidCallback? onEdit;
>>>>>>> 41ded02d (fix: rework)
=======
  final showAvatar;
>>>>>>> 0721b7ab (chore: update version)

  const CustomAppBar(
      {super.key,
      required this.title,
      this.onReturn,
      this.actions,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      this.isWithNotification = false,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 92623572 (feat: notifikasi evaluasi bs)
=======
>>>>>>> 20fcb172 (fix: notification all evaluasi)
      this.notificationCount = 0,
      this.onNotifications,
      this.notificationTooltip = 'Evaluasi',
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> d8439a4 (fix: refactor code)
=======
      this.isWithNotification = false,
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
      this.isWithNotification = false,
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
      this.reworkNotificationCount = 0,
      this.onReworkNotifications,
<<<<<<< HEAD
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
      this.isWithBsNotification = false,
      this.bsNotificationCount = 0,
      this.onBsNotifications,
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
=======
      this.notificationCount = 0,
      this.onNotifications,
      this.notificationTooltip = 'Evaluasi',
>>>>>>> e2884b8b (fix: notification all evaluasi)
=======
      this.reworkNotificationCount = 0,
      this.onReworkNotifications,
      this.isWithBsNotification = false,
      this.bsNotificationCount = 0,
      this.onBsNotifications,
>>>>>>> 83f4dcb (feat: notifikasi evaluasi bs)
<<<<<<< HEAD
>>>>>>> 92623572 (feat: notifikasi evaluasi bs)
=======
=======
      this.notificationCount = 0,
      this.onNotifications,
      this.notificationTooltip = 'Evaluasi',
>>>>>>> 07c9d40 (fix: notification all evaluasi)
<<<<<<< HEAD
>>>>>>> 20fcb172 (fix: notification all evaluasi)
=======
=======
      this.isWithAnomalyNotification = false,
      this.anomalyNotificationCount = 0,
      this.onAnomalyNotifications,
      this.anomalyNotificationTooltip = 'Notifikasi',
>>>>>>> d94a57a (feat:)
>>>>>>> a5b9c62d (feat:)
      this.isWithAccount = false,
      this.handleDelete,
      this.handleUpdate,
      this.id,
      this.label,
      this.handleLogout,
      this.user,
      this.deleteStatus,
      this.updateStatus,
      this.isTextEditor = false,
      this.handleSave,
      this.name,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      this.handleFinish,
      this.isLoading = false,
<<<<<<< HEAD
      this.showNameWithAvatar = false});
=======
      this.isLoading = false});
>>>>>>> d8439a4 (fix: refactor code)
=======
      this.handleFinish,
      this.isLoading = false,
      this.isDashboardSettingsLoading = false,
      this.onDashboardSettings,
      this.onReportSettings,
      this.onEdit,
      this.showNameWithAvatar = false});
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
      this.handleFinish,
      this.isLoading = false,
      this.showNameWithAvatar = false});
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
      this.showNameWithAvatar = false,
      this.onDashboardSettings,
      this.onEdit,
      this.onReportSettings,
      this.isDashboardSettingsLoading = false});
>>>>>>> 0721b7ab (chore: update version)

  @override
  Widget build(BuildContext context) {
    String getInitial(String? name) {
      if (name == null || name.trim().isEmpty) return '?';
      return name.trim()[0].toUpperCase();
    }

    return AppBar(
      leading: onReturn != null
          ? IconButton(
              onPressed: onReturn,
              icon: Icon(Icons.chevron_left),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: CustomTheme().fontSize('xl'),
        ),
      ),
      actions: [
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        if (isWithNotification)
          _buildNotificationButton(
<<<<<<< HEAD
<<<<<<< HEAD
            tooltip: notificationTooltip,
            icon: Icons.assignment_late_outlined,
            count: notificationCount,
            onPressed: onNotifications,
=======
            tooltip: 'Evaluasi Rework',
            icon: Icons.assignment_late_outlined,
            count: reworkNotificationCount,
            onPressed: onReworkNotifications,
          ),
        if (isWithBsNotification)
          _buildNotificationButton(
            tooltip: 'Evaluasi BS',
            icon: Icons.report_gmailerrorred_outlined,
            count: bsNotificationCount,
            onPressed: onBsNotifications,
>>>>>>> 83f4dcb (feat: notifikasi evaluasi bs)
=======
            tooltip: notificationTooltip,
            icon: Icons.assignment_late_outlined,
            count: notificationCount,
            onPressed: onNotifications,
>>>>>>> 07c9d40 (fix: notification all evaluasi)
          ),
<<<<<<< HEAD
=======
>>>>>>> 7a6aa3b1 (feat: model for report)
=======
>>>>>>> 5e1b7ecb (fix: dashboard)
=======
        if (isWithNotification)
          _buildNotificationButton(
            tooltip: notificationTooltip,
            icon: Icons.assignment_late_outlined,
            count: notificationCount,
            onPressed: onNotifications,
          ),
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
        if (isWithAnomalyNotification)
          _buildNotificationButton(
            tooltip: anomalyNotificationTooltip,
            icon: Icons.notifications_outlined,
            count: anomalyNotificationCount,
            onPressed: onAnomalyNotifications,
          ),
>>>>>>> a5b9c62d (feat:)
        if (isDashboardSettingsLoading)
          const Padding(
            padding: EdgeInsets.all(14),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (onDashboardSettings != null)
<<<<<<< HEAD
=======
        if (onDashboardSettings != null)
>>>>>>> 5e1caa7c (feat: widget controller)
=======
>>>>>>> 5e1b7ecb (fix: dashboard)
          IconButton(
            tooltip: 'Atur widget dashboard',
            onPressed: onDashboardSettings,
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 65038198 (feat:)
        if (onReportSettings != null)
          IconButton(
            tooltip: 'Atur widget laporan',
            onPressed: onReportSettings,
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 41ded02d (fix: rework)
        if (onEdit != null)
          IconButton(
            tooltip: 'Edit',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
<<<<<<< HEAD
=======
>>>>>>> 7a6aa3b1 (feat: model for report)
=======
>>>>>>> 5e1caa7c (feat: widget controller)
=======
>>>>>>> 65038198 (feat:)
=======
>>>>>>> 41ded02d (fix: rework)
        if (isWithAccount)
          PopupMenuButton<String>(
            icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showNameWithAvatar)
                    Text(
                      name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
>>>>>>> aa863171 (fix: responsive UI to mobile)
                  if (showAvatar)
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: CustomTheme().colors('primary'),
                      child: Text(
                        getInitial(name),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: CustomTheme().fontSize('sm'),
                        ),
<<<<<<< HEAD
<<<<<<< HEAD
                      ),
                    )
                  else
                    const Icon(Icons.account_circle_outlined),
=======
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: CustomTheme().colors('primary'),
                    child: Text(
                      getInitial(name),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: CustomTheme().fontSize('sm'),
                      ),
                    ),
                  ),
<<<<<<< HEAD
>>>>>>> 632c9e3 (fix: show logged in name di appbar)
=======
>>>>>>> 6f05bd35 (merge to fase 2  (#27))
=======
                      ),
                    )
                  else
                    const Icon(Icons.account_circle_outlined),
>>>>>>> 9dacc402 (fix: responsive UI to mobile)
=======
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: CustomTheme().colors('primary'),
                    child: Text(
                      getInitial(name),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: CustomTheme().fontSize('sm'),
                      ),
                    ),
                  ),
>>>>>>> b1c3b09b (fix: user name di appbar)
=======
                      ),
                    )
                  else
                    const Icon(Icons.account_circle_outlined),
>>>>>>> aa863171 (fix: responsive UI to mobile)
                ].separatedBy(CustomTheme().hGap('xl'))),
            color: Colors.white,
            offset: Offset(0, 40),
            onSelected: (value) {
              if (value == 'logout') {
                handleLogout();
              }

              if (value == 'account') {
                Navigator.pushNamed(context, '/account');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(
                      '@$user',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('sm'),
                        color: CustomTheme().colors('secondary'),
                      ),
                    ),
                  ].separatedBy(
                    CustomTheme().vGap('sm'),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'account',
                child: Text('Account'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Log Out'),
              ),
            ],
          ),

        /// TAMPILKAN SETELAH LOADING SELESAI
        if (!isLoading)
          Row(
            children: [
              if (updateStatus == true)
                ActionTextButton(
                  label: 'Edit',
                  onPressed: handleUpdate,
                ),
              if (deleteStatus == true)
                ActionTextButton(
                  label: 'Hapus',
                  textColor: Colors.red,
                  borderColor: Colors.red,
                  onPressed: () => handleDelete(id.toString()),
                ),
            ],
          ),

        /// ACTION CUSTOM JUGA MENUNGGU LOADING
        if (!isLoading) ...?actions,
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: Column(
          children: [
            if (tab != null) tab!,
            Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton({
    required String tooltip,
    required IconData icon,
    required int count,
    VoidCallback? onPressed,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
