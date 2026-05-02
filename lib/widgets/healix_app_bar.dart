import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../store/healix_store.dart';

class HealixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final List<Widget>? extraActions;

  const HealixAppBar({
    super.key,
    this.onNotificationTap,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Center(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: healixStore.profileImageUrl,
                    builder: (context, url, _) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00AACD),
                          shape: BoxShape.circle,
                          image: url != null
                              ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
                              : null,
                        ),
                        child: url == null
                            ? const Icon(Icons.person_outline, color: Colors.white, size: 24)
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
      title: Image.asset(
        'assets/images/logo_full.jpeg',
        height: 32,
        fit: BoxFit.contain,
      ),
      actions: [
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: healixStore.notifications,
          builder: (context, notifications, _) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF0F172A), size: 26),
                  onPressed: onNotificationTap ?? () => _showNotifications(context),
                ),
                if (notifications.isNotEmpty)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        if (extraActions != null) ...extraActions!,
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    TextButton(
                      onPressed: () => healixStore.clearNotifications(),
                      child: const Text('Clear All', style: TextStyle(color: Color(0xFF00AACD))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: healixStore.notifications,
                  builder: (context, notifications, _) {
                    if (notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text('No notifications yet', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final note = notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: note['color'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(note['icon'], color: note['color'], size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          note['title'],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          note['time'],
                                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      note['body'],
                                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
