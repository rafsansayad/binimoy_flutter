import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../widgets/widgets.dart';
import 'widgets/feed_post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _posts = const [];
  int _unreadChats = 3; // mock badge

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), _loadMock);
  }

  Future<void> _loadMock() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _loading = false;
      _error = null;
      _posts = _generateMockPosts(40);
    });
  }

  List<Map<String, dynamic>> _generateMockPosts(int count) {
    final Random rng = Random();
    final List<String> names = [
      'Rahim Uddin','Karim Khan','Hasan Mahmud','Rakib Hasan','Arif Hossain','Tanvir Ahmed','Nayeem Islam','Shanto Rahman','Sumon Ali','Rafi Chowdhury',
      'Nusrat Jahan','Jannat Ara','Ayesha Siddiqua','Riya Rahman','Samia Akter','Moumita Das','Priya Saha','Farzana Hoque','Mitu Akter','Tania Sultana',
      'Fahim Rahman','Shakib Khan','Sabbir Hossain','Mizanur Rahman','Sajid Hasan','Rifat Islam','Shuvo Roy','Ridoy Ahmed','Ishrak Rahman','Tahmid Hasan'
    ];
    final List<String> messages = [
      'Tea at TSC ☕',
      'Khichuri & beef biryani 🍛',
      'Rickshaw fare 🚲',
      'CNG share 🚕',
      'Metro Rail top‑up 🚝',
      'Fuchka party 🥟',
      'Chotpoti & jhalmuri 🌶️',
      'Tuition fee 📚',
      'Cricket tickets 🏏',
      'Nagad cashout fee 💸',
      'bKash transfer 🔁',
      'Birthday gift 🎁',
      'Iftar snacks 🕌',
      'Wi‑Fi bill 📶',
    ];

    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < count; i++) {
      final String payer = names[rng.nextInt(names.length)];
      String payee = names[rng.nextInt(names.length)];
      if (payee == payer) {
        payee = names[(names.indexOf(payee) + 1) % names.length];
      }
      final String msg = messages[rng.nextInt(messages.length)];
      final bool liked = rng.nextBool();
      final int likes = rng.nextInt(120);
      final int comments = rng.nextInt(30);
      final String time = rng.nextBool()
          ? '${rng.nextInt(59) + 1}m'
          : '${rng.nextInt(5) + 1}h';
      final bool hasImage = i % 5 == 0; // every 5th post shows media
      list.add({
        'userName': payer,
        'avatar': '',
        'action': 'paid',
        'counterparty': payee,
        'time': time,
        'message': msg,
        'image': hasImage ? 'https://picsum.photos/800/450?random=$i' : '',
        'liked': liked,
        'likes': likes,
        'comments': comments,
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: const Text('Feed'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _BadgeIconButton(
              icon: Icons.chat_bubble_outline_rounded,
              badgeCount: _unreadChats,
              onPressed: () => AppSnackBar.showInfo(context, 'Chats coming soon'),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [cs.surfaceVariant.withOpacity(0.25), Colors.transparent],
            ),
          ),
        ),
      ),
      backgroundColor: cs.surface,
      body: RefreshIndicator(
        onRefresh: _loadMock,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cs.surfaceVariant.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
            AppBottomDock(
              onScan: () {},
              onPrimaryTap: () {},
              activeIndex: 0,
              trailingActions: const [
                DockAction(icon: Icons.home_rounded, tooltip: 'Home'),
                DockAction(icon: Icons.credit_card_rounded, tooltip: 'Cards'),
                DockAction(icon: Icons.notifications_none_rounded, tooltip: 'Notifications'),
                DockAction(icon: Icons.person_rounded, tooltip: 'Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return ListView.builder(
        itemCount: 8,
        itemBuilder: (_, i) => SkeletonFeedItem(hasMedia: i.isEven),
      );
    }
    if (_error != null) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Center(child: Text(_error!)),
          const SizedBox(height: 16),
          Center(
            child: PrimaryPillButton(label: 'Retry', onPressed: _loadMock, icon: Icons.refresh_rounded, expand: false),
          ),
        ],
      );
    }
    if (_posts.isEmpty) {
      return ListView(children: const [SizedBox(height: 80), Center(child: Text('No posts yet'))]);
    }
    return ListView.separated(
      itemCount: _posts.length + (_posts.length ~/ 7),
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (_, index) {
        // Insert a promo every 7th slot
        if ((index + 1) % 7 == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PromoCard(
              icon: Icons.groups_2_rounded,
              title: 'Split a bill with friends',
              subtitle: 'Create a bill and let everyone pay their share',
              onTap: () {},
            ),
          );
        }
        final int postIndex = index - (index ~/ 7);
        final p = _posts[postIndex];
        return FeedPostCard(
          userName: p['userName'],
          userAvatarUrl: p['avatar'],
          actionText: p['action'],
          counterpartyName: p['counterparty'],
          message: p['message'],
          timeLabel: p['time'],
          imageUrl: p['image'],
          isLiked: p['liked'],
          likeCount: p['likes'],
          commentCount: p['comments'],
          onLike: () => setState(() {
            p['liked'] = !(p['liked'] as bool);
            p['likes'] = (p['liked'] as bool) ? (p['likes'] as int) + 1 : (p['likes'] as int) - 1;
          }),
          onComment: () {},
        );
      },
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onPressed;
  const _BadgeIconButton({required this.icon, required this.badgeCount, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 22, color: cs.onSurface),
      tooltip: 'Chats',
    );

    if (badgeCount <= 0) return button;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        button,
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: cs.error,
              shape: BoxShape.circle,
              border: Border.all(color: cs.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

