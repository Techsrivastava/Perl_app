import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class ConsultantNotificationsScreen extends StatefulWidget {
  const ConsultantNotificationsScreen({super.key});

  @override
  State<ConsultantNotificationsScreen> createState() => _ConsultantNotificationsScreenState();
}

class _ConsultantNotificationsScreenState extends State<ConsultantNotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = const [
    'Admissions',
    'Payments',
    'University Updates',
    'Reverted Applications',
    'Agent Activity',
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 9001,
      'category': 'Admissions',
      'title': 'New Admission Application',
      'message': '🎓 New admission application received for BNYS – Sunrise University.',
      'student': 'Neeraj Patel',
      'relatedId': 'STU_4520',
      'priority': 'High',
      'timestamp': DateTime(2025, 11, 7, 10, 32),
      'isRead': false,
      'action': 'Submitted',
    },
    {
      'id': 9002,
      'category': 'Payments',
      'title': 'Payment Verified',
      'message': '🧾 Payment for Amit Singh verified successfully.',
      'student': 'Amit Singh',
      'relatedId': 'PAY_9032',
      'priority': 'High',
      'timestamp': DateTime(2025, 11, 7, 9, 15),
      'isRead': false,
      'action': 'Verified',
    },
    {
      'id': 9003,
      'category': 'University Updates',
      'title': 'Fee Structure Updated',
      'message': '🏫 Sunrise University has updated BNYS fee structure.',
      'university': 'Sunrise University',
      'priority': 'Medium',
      'timestamp': DateTime(2025, 11, 6, 18, 5),
      'isRead': true,
      'action': 'Fee Update',
    },
    {
      'id': 9004,
      'category': 'Reverted Applications',
      'title': 'Document Missing',
      'message': '🔁 Rohit Sharma’s admission reverted — Upload missing mark sheet.',
      'student': 'Rohit Sharma',
      'priority': 'High',
      'timestamp': DateTime(2025, 11, 5, 15, 40),
      'isRead': false,
      'action': 'Document Required',
    },
    {
      'id': 9005,
      'category': 'Agent Activity',
      'title': 'New Lead Added',
      'message': '👤 Agent Saurabh Yadav added a new lead – BNYS Student.',
      'agent': 'Saurabh Yadav',
      'priority': 'Low',
      'timestamp': DateTime(2025, 11, 7, 8, 20),
      'isRead': false,
      'action': 'Lead Added',
    },
    {
      'id': 9006,
      'category': 'Payments',
      'title': 'Payment Rejected',
      'message': '🚫 Payment rejected — incorrect receipt uploaded for Priya Verma.',
      'student': 'Priya Verma',
      'priority': 'High',
      'timestamp': DateTime(2025, 11, 4, 20, 10),
      'isRead': true,
      'action': 'Rejected',
    },
    {
      'id': 9007,
      'category': 'Agent Activity',
      'title': 'Fee Receipt Uploaded',
      'message': '💳 Fee receipt uploaded by Agent #102 for Rahul Kumar.',
      'agent': 'Agent #102',
      'priority': 'Medium',
      'timestamp': DateTime(2025, 11, 3, 17, 30),
      'isRead': true,
      'action': 'Payment Upload',
    },
  ];

  final Set<String> _selectedPriorities = {'All'};
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !(n['isRead'] as bool)).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryBlue,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Filter Notifications',
            icon: const Icon(Icons.tune, size: 20),
            onPressed: _openFilterBottomSheet,
          ),
          IconButton(
            tooltip: 'Export Notifications',
            icon: const Icon(Icons.download_outlined, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export triggered (mock action)')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(74),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        unreadCount > 0
                            ? 'You have $unreadCount unread notifications'
                            : 'You are all caught up!',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _markAllRead(_tabs[_tabController.index]),
                      child: const Text('Mark All Read'),
                    ),
                    TextButton(
                      onPressed: () => _clearCategory(_tabs[_tabController.index]),
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppTheme.primaryBlue,
                labelColor: AppTheme.primaryBlue,
                unselectedLabelColor: Colors.grey[500],
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
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

  List<Map<String, dynamic>> _filteredNotifications(String category) {
    return _notifications.where((notification) {
      final matchesCategory = notification['category'] == category;
      final matchesRead = !_showUnreadOnly || !(notification['isRead'] as bool);
      final matchesPriority = _selectedPriorities.contains('All') ||
          _selectedPriorities.contains(notification['priority']);
      return matchesCategory && matchesRead && matchesPriority;
    }).toList()
      ..sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
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
                color: color.withOpacity(0.12),
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

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'] as bool;
    final priority = notification['priority'] as String;
    final DateTime timestamp = notification['timestamp'] as DateTime;
    final color = _priorityColor(priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(isRead ? 0.15 : 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: _buildLeadingIcon(notification),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[900],
                ),
              ),
            ),
            _buildPriorityChip(priority, color),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              notification['message'] as String,
              style: TextStyle(fontSize: 12.5, color: Colors.grey[700], height: 1.35),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _buildMetadataChips(notification),
            ),
            const SizedBox(height: 10),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleAction(value, notification),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: isRead ? 'mark-unread' : 'mark-read',
              child: Text(isRead ? 'Mark as Unread' : 'Mark as Read'),
            ),
            const PopupMenuItem<String>(
              value: 'view-details',
              child: Text('View Details'),
            ),
            const PopupMenuItem<String>(
              value: 'mute',
              child: Text('Mute Category'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMetadataChips(Map<String, dynamic> notification) {
    final List<Widget> chips = [];
    void addChip(String label, IconData icon, Color color) {
      chips.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ));
    }

    if (notification.containsKey('student')) {
      addChip(notification['student'] as String, Icons.person_outline, AppTheme.primaryBlue);
    }
    if (notification.containsKey('agent')) {
      addChip(notification['agent'] as String, Icons.group_outlined, Colors.purple);
    }
    if (notification.containsKey('university')) {
      addChip(notification['university'] as String, Icons.school_outlined, Colors.teal);
    }
    if (notification.containsKey('action')) {
      addChip(notification['action'] as String, Icons.check_circle_outline, Colors.orange);
    }
    return chips;
  }

  Widget _buildLeadingIcon(Map<String, dynamic> notification) {
    IconData icon;
    Color color;

    switch (notification['category']) {
      case 'Admissions':
        icon = Icons.assignment_turned_in_outlined;
        color = Colors.green;
        break;
      case 'Payments':
        icon = Icons.currency_rupee;
        color = Colors.blue;
        break;
      case 'University Updates':
        icon = Icons.campaign_outlined;
        color = Colors.purple;
        break;
      case 'Reverted Applications':
        icon = Icons.replay_outlined;
        color = Colors.orange;
        break;
      case 'Agent Activity':
        icon = Icons.group_outlined;
        color = Colors.indigo;
        break;
      default:
        icon = Icons.notifications_outlined;
        color = AppTheme.primaryBlue;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildPriorityChip(String priority, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w700),
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
            SnackBar(content: Text('Muted ${notification['category']} notifications (mock).')),
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
      _notifications.removeWhere((notification) => notification['category'] == category);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$category notifications cleared.')),
    );
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
                      const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Priority', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
                              _selectedPriorities..clear()..add('All');
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
                    title: const Text('Show unread only', style: TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(notification['title'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['message'] as String),
              const SizedBox(height: 12),
              ..._buildMetadataChips(notification),
              const SizedBox(height: 12),
              Text('Priority: ${notification['priority']}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Received: ${_formatTimestamp(notification['timestamp'] as DateTime)}'),
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
                  SnackBar(content: Text('Navigating to ${notification['category']} details (mock).')),
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
