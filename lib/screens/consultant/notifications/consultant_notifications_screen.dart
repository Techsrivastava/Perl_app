import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/services/notification_service.dart';

class ConsultantNotificationsScreen extends StatefulWidget {
  const ConsultantNotificationsScreen({super.key});

  @override
  State<ConsultantNotificationsScreen> createState() =>
      _ConsultantNotificationsScreenState();
}

class _ConsultantNotificationsScreenState
    extends State<ConsultantNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = const [
    'Admissions',
    'Payments',
    'University Updates',
    'Reverted Applications',
    'Agent Activity',
  ];

  bool _isLoading = true;
  List<dynamic> _notifications = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await NotificationService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  final Set<String> _selectedPriorities = {'All'};
  bool _showUnreadOnly = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications
        .where((n) => !(n['isRead'] as bool))
        .length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                  ),
                ),
                Text(
                  _isLoading
                      ? 'Updating...'
                      : _notifications
                                .where((n) => !(n['isRead'] ?? false))
                                .length >
                            0
                      ? '${_notifications.where((n) => !(n['isRead'] ?? false)).length} unread'
                      : 'All caught up!',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        _notifications
                                .where((n) => !(n['isRead'] ?? false))
                                .length >
                            0
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Filter button
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              tooltip: 'Filter',
              icon: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
              onPressed: _openFilterBottomSheet,
            ),
          ),
          // Export button
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              tooltip: 'Export',
              icon: const Icon(
                Icons.download_rounded,
                size: 20,
                color: Colors.green,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Export started...'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Action buttons row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: unreadCount > 0
                                ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                                : Colors.green.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: unreadCount > 0
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.2)
                                  : Colors.green.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _notifications
                                            .where(
                                              (n) => !(n['isRead'] ?? false),
                                            )
                                            .length >
                                        0
                                    ? Icons.mark_email_unread
                                    : Icons.check_circle_outline,
                                size: 16,
                                color:
                                    _notifications
                                            .where(
                                              (n) => !(n['isRead'] ?? false),
                                            )
                                            .length >
                                        0
                                    ? AppTheme.primaryBlue
                                    : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _notifications
                                              .where(
                                                (n) => !(n['isRead'] ?? false),
                                              )
                                              .length >
                                          0
                                      ? 'You have ${_notifications.where((n) => !(n['isRead'] ?? false)).length} new notifications'
                                      : '✨ All notifications read!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        _notifications
                                                .where(
                                                  (n) =>
                                                      !(n['isRead'] ?? false),
                                                )
                                                .length >
                                            0
                                        ? AppTheme.primaryBlue
                                        : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _markAllRead(_tabs[_tabController.index]),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.done_all, size: 16),
                        label: const Text(
                          'Mark Read',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () =>
                            _clearCategory(_tabs[_tabController.index]),
                        icon: const Icon(
                          Icons.delete_sweep_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppTheme.primaryBlue,
                  indicatorWeight: 3,
                  labelColor: AppTheme.primaryBlue,
                  unselectedLabelColor: AppTheme.mediumGray,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadNotifications,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: _tabs.map(_buildTabContent).toList(),
            ),
    );
  }

  Widget _buildTabContent(String category) {
    final tabNotifications = _filteredNotifications(category);

    if (tabNotifications.isEmpty) {
      return _buildEmptyState(category);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tabNotifications.length,
      itemBuilder: (context, index) {
        final notification = tabNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  List<dynamic> _filteredNotifications(String category) {
    return _notifications.where((notification) {
      final matchesCategory = notification['category'] == category;
      final matchesRead =
          !_showUnreadOnly || !(notification['isRead'] ?? false);
      final matchesPriority =
          _selectedPriorities.contains('All') ||
          _selectedPriorities.contains(notification['priority'] ?? 'Low');
      return matchesCategory && matchesRead && matchesPriority;
    }).toList()..sort((a, b) {
      final aTime = a['createdAt'] != null
          ? DateTime.parse(a['createdAt'])
          : DateTime.now();
      final bTime = b['createdAt'] != null
          ? DateTime.parse(b['createdAt'])
          : DateTime.now();
      return bTime.compareTo(aTime);
    });
  }

  Widget _buildEmptyState(String category) {
    IconData icon;
    Color color;
    switch (category) {
      case 'Admissions':
        icon = Icons.school_outlined;
        color = Colors.green;
        break;
      case 'Payments':
        icon = Icons.currency_rupee_outlined;
        color = Colors.blue;
        break;
      case 'University Updates':
        icon = Icons.campaign_outlined;
        color = Colors.purple;
        break;
      case 'Reverted Applications':
        icon = Icons.replay_circle_filled_outlined;
        color = Colors.orange;
        break;
      case 'Agent Activity':
        icon = Icons.groups_outlined;
        color = Colors.indigo;
        break;
      default:
        icon = Icons.notifications_none;
        color = AppTheme.primaryBlue;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              'No $category alerts',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Stay tuned! New notifications will appear here automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    final bool isRead = notification['isRead'] ?? false;
    final priority = notification['priority'] ?? 'Low';
    final DateTime timestamp = notification['createdAt'] != null
        ? DateTime.parse(notification['createdAt'])
        : DateTime.now();
    final color = _priorityColor(priority);
    final categoryIcon = _getCategoryIcon(
      notification['category'] ?? 'General',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead
              ? const Color(0xFFF3F4F6)
              : color.withValues(alpha: 0.3),
          width: isRead ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isRead
                ? Colors.black.withValues(alpha: 0.03)
                : color.withValues(alpha: 0.08),
            blurRadius: isRead ? 8 : 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showNotificationDetails(notification),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern gradient icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        categoryIcon.$2.withValues(alpha: 0.9),
                        categoryIcon.$2,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: categoryIcon.$2.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(categoryIcon.$1, size: 26, color: Colors.white),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with unread indicator
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.charcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Category and priority badges
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryIcon.$2.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notification['category'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: categoryIcon.$2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildPriorityChip(priority, color),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Message
                      Text(
                        notification['message'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkGray,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Metadata chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _buildMetadataChips(notification),
                      ),
                      const SizedBox(height: 12),
                      // Footer with time and action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: AppTheme.mediumGray,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatTimestamp(timestamp),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.mediumGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) =>
                                _handleAction(value, notification),
                            icon: Icon(
                              Icons.more_vert,
                              size: 18,
                              color: AppTheme.mediumGray,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: isRead ? 'mark-unread' : 'mark-read',
                                child: Row(
                                  children: [
                                    Icon(
                                      isRead
                                          ? Icons.mark_email_unread_outlined
                                          : Icons.mark_email_read_outlined,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(isRead ? 'Mark Unread' : 'Mark Read'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'view-details',
                                child: Row(
                                  children: [
                                    Icon(Icons.open_in_new, size: 18),
                                    SizedBox(width: 8),
                                    Text('View Details'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (IconData, Color) _getCategoryIcon(String category) {
    switch (category) {
      case 'Admissions':
        return (Icons.assignment_turned_in_outlined, Colors.green);
      case 'Payments':
        return (Icons.currency_rupee, Colors.blue);
      case 'University Updates':
        return (Icons.campaign_outlined, Colors.purple);
      case 'Reverted Applications':
        return (Icons.replay_outlined, Colors.orange);
      case 'Agent Activity':
        return (Icons.group_outlined, Colors.indigo);
      default:
        return (Icons.notifications_outlined, AppTheme.primaryBlue);
    }
  }

  List<Widget> _buildMetadataChips(Map<String, dynamic> notification) {
    final List<Widget> chips = [];
    void addChip(String label, IconData icon, Color color) {
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (notification.containsKey('student')) {
      addChip(
        notification['student'] as String,
        Icons.person_outline,
        AppTheme.primaryBlue,
      );
    }
    if (notification.containsKey('agent')) {
      addChip(
        notification['agent'] as String,
        Icons.group_outlined,
        Colors.purple,
      );
    }
    if (notification.containsKey('university')) {
      addChip(
        notification['university'] as String,
        Icons.school_outlined,
        Colors.teal,
      );
    }
    if (notification.containsKey('action')) {
      addChip(
        notification['action'] as String,
        Icons.check_circle_outline,
        Colors.orange,
      );
    }
    return chips;
  }

  Widget _buildPriorityChip(String priority, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority == 'High' ? Icons.priority_high : Icons.flag_outlined,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            priority,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(String action, Map<String, dynamic> notification) {
    setState(() {
      switch (action) {
        case 'mark-read':
          notification['isRead'] = true;
          break;
        case 'mark-unread':
          notification['isRead'] = false;
          break;
        case 'delete':
          _notifications.removeWhere((n) => n['id'] == notification['id']);
          break;
        case 'view-details':
          _showNotificationDetails(notification);
          break;
        case 'mute':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Muted ${notification['category']} notifications (mock).',
              ),
            ),
          );
          break;
      }
    });
  }

  void _markAllRead(String category) {
    setState(() {
      for (final notification in _notifications) {
        if (notification['category'] == category) {
          notification['isRead'] = true;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All $category notifications marked as read.')),
    );
  }

  void _clearCategory(String category) {
    setState(() {
      _notifications.removeWhere(
        (notification) => notification['category'] == category,
      );
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$category notifications cleared.')));
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Priority',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ['All', 'High', 'Medium', 'Low'].map((priority) {
                      final isSelected = _selectedPriorities.contains(priority);
                      return FilterChip(
                        label: Text(priority),
                        selected: isSelected,
                        onSelected: (value) {
                          setModalState(() {
                            if (priority == 'All') {
                              _selectedPriorities
                                ..clear()
                                ..add('All');
                            } else {
                              _selectedPriorities.remove('All');
                              if (value) {
                                _selectedPriorities.add(priority);
                              } else {
                                _selectedPriorities.remove(priority);
                                if (_selectedPriorities.isEmpty) {
                                  _selectedPriorities.add('All');
                                }
                              }
                            }
                          });
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    value: _showUnreadOnly,
                    onChanged: (value) {
                      setModalState(() => _showUnreadOnly = value);
                      setState(() {});
                    },
                    title: const Text(
                      'Show unread only',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(notification['title'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['message'] as String),
              const SizedBox(height: 12),
              ..._buildMetadataChips(notification),
              const SizedBox(height: 12),
              Text(
                'Priority: ${notification['priority']}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Received: ${_formatTimestamp(notification['timestamp'] as DateTime)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Navigating to ${notification['category']} details (mock).',
                    ),
                  ),
                );
              },
              child: const Text('Open Linked Record'),
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}';
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.blue;
      default:
        return AppTheme.primaryBlue;
    }
  }
}
