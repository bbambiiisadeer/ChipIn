import 'package:flutter/material.dart';
import 'checkslip.dart'; // เพิ่ม import ไฟล์ปลายทาง

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    "All",
    "My Request",
    "Incoming Request",
    "Check Slip",
    "Due Date",
  ];

  // Mock notification data
  final List<Map<String, dynamic>> _allNotifications = [
    {
      "type": "approved",
      "service": "Youtube Premium",
      "logo": "assets/images/youtube.png",
      "message": "Host has been approve your request",
      "detail": "Please pay before 13-13-2025 23:59",
      "price": null,
      "category": "my_request",
      "timestamp": "2 hours ago",
      "status": null,
    },
    {
      "type": "rejected",
      "service": "Youtube Premium",
      "logo": "assets/images/youtube.png",
      "message": "Host has been reject your request",
      "detail": null,
      "price": null,
      "category": "my_request",
      "timestamp": "1 hours ago",
      "status": null,
    },
    {
      "type": "incoming_request",
      "service": "Spotify Premium",
      "logo": "assets/images/spotify.png",
      "message": "poonbcw want to join your group",
      "detail": null,
      "price": "49 THB",
      "category": "incoming_request",
      "timestamp": "5 minutes ago",
      "status": null,
    },
    {
      "type": "payment_received",
      "service": "Youtube Premium",
      "logo": "assets/images/youtube.png",
      "sender": "Youtube Premium",
      "message": "bambiiisadeer sent payment",
      "price": "49 THB",
      "category": "check_slip",
      "timestamp": "1 day ago",
      "status": null,
    },
    {
      "type": "expiring",
      "service": "Youtube Premium",
      "logo": "assets/images/youtube.png",
      "message": "Subscription will expire tomorrow",
      "detail": null,
      "price": null,
      "category": "due_date",
      "timestamp": "3 hours ago",
      "status": null,
    },
    {
      "type": "renewal",
      "service": "Youtube Premium",
      "logo": "assets/images/youtube.png",
      "message": "Next subscription will be charged tomorrow",
      "detail": null,
      "price": "49 THB",
      "category": "due_date",
      "timestamp": "Yesterday",
      "status": null,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 0) {
      return _allNotifications;
    } else if (_selectedTab == 1) {
      return _allNotifications
          .where((notif) => notif['category'] == 'my_request')
          .toList();
    } else if (_selectedTab == 2) {
      return _allNotifications
          .where((notif) => notif['category'] == 'incoming_request')
          .toList();
    } else if (_selectedTab == 3) {
      return _allNotifications
          .where((notif) => notif['category'] == 'check_slip')
          .toList();
    } else {
      return _allNotifications
          .where((notif) => notif['category'] == 'due_date')
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notification",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabSection(),
          const SizedBox(height: 20),
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                decoration: BoxDecoration(
                  color: _selectedTab == index
                      ? Colors.black
                      : const Color.fromARGB(255, 237, 237, 237),
                  border: Border.all(
                    color: _selectedTab == index
                        ? Colors.black
                        : const Color.fromARGB(255, 237, 237, 237),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: _selectedTab == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final type = notification['type'];

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE3E2E2), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(notification['logo']),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: const Color(0xFFF2F2F2),
                    width: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Content Middle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service name or sender
                    if (notification['service'] != null &&
                        type != 'payment_received')
                      Text(
                        notification['service'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (notification['sender'] != null)
                      Text(
                        notification['sender'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if ((notification['service'] != null &&
                            type != 'payment_received') ||
                        notification['sender'] != null)
                      const SizedBox(height: 4),

                    // Message
                    Text(
                      notification['message'],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),

                    // Detail (if exists)
                    if (notification['detail'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        notification['detail'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ],

                    // Timestamp
                    if (notification['timestamp'] != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        notification['timestamp'],
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              // Right Side Item (Status Badge OR Price)
              if (type == 'incoming_request' && notification['status'] != null)
                _buildStatusBadge(notification['status'])
              else if (notification['price'] != null)
                Text(
                  notification['price'],
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),

          // Action buttons for incoming requests
          if (type == 'incoming_request' && notification['status'] == null) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          notification['status'] = 'accept';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          notification['status'] = 'reject';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Reject",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Check Slip button (แก้ไขตรงนี้)
          if (type == 'payment_received') ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // --- ใช้ Navigator.push แทน pushNamed ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckSlipPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Check Slip",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusBgColor;
    Color statusTextColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case "accept":
        statusBgColor = const Color.fromARGB(52, 65, 163, 19);
        statusTextColor = const Color.fromARGB(255, 65, 163, 19);
        statusText = "Accepted";
        statusIcon = Icons.check;
        break;
      case "reject":
      default:
        statusBgColor = const Color.fromARGB(255, 255, 214, 214);
        statusTextColor = const Color.fromARGB(255, 177, 6, 15);
        statusText = "Rejected";
        statusIcon = Icons.close;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: statusBgColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16.0, color: statusTextColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(fontSize: 12.0, color: statusTextColor),
          ),
        ],
      ),
    );
  }
}
