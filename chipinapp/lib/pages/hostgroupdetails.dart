import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class HostGroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> subscription;

  const HostGroupDetailsPage({super.key, required this.subscription});

  @override
  State<HostGroupDetailsPage> createState() => _HostGroupDetailsPageState();
}

class _HostGroupDetailsPageState extends State<HostGroupDetailsPage> {
  bool _isCopied = false;
  bool _showInMarket = false;
  late String _inviteCode;

  @override
  void initState() {
    super.initState();
    _inviteCode = _generateInviteCode();

    // Use mock data if subscription is empty
    final data = widget.subscription.isEmpty
        ? {'showInMarket': false}
        : widget.subscription;
    _showInMarket = data['showInMarket'] ?? false;
  }

  String _generateInviteCode() {
    final random = Random();

    // สุ่มตัวอักษร 3 ตัว (A-Z)
    String letters = '';
    for (int i = 0; i < 3; i++) {
      letters += String.fromCharCode(random.nextInt(26) + 65); // A-Z
    }

    // สุ่มตัวเลข 4 ตัว (0-9)
    String numbers = '';
    for (int i = 0; i < 4; i++) {
      numbers += random.nextInt(10).toString();
    }

    return '$letters-$numbers';
  }

  void _handleCopy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _isCopied = true;
    });

    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 165.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delete Subscription',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Are you sure you want to delete this subscription?',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous page
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mock data
    final Map<String, dynamic> subscriptionData = widget.subscription.isEmpty
        ? {
            'name': 'Netflix Premium',
            'logo': 'assets/images/netflix.png',
            'price': '105',
            'showInMarket': false,
            'members': [
              {'name': 'poonbcw', 'status': 'Paid', 'isMe': true},
              {'name': 'bambiiisadeer', 'status': 'Paid'},
              {'name': 'amour', 'status': 'Unpaid'},
              {'name': 'lengsab', 'status': 'Pending'},
            ],
          }
        : widget.subscription;

    final List<dynamic> members =
        subscriptionData['members'] ??
        [
          {'name': 'poonbcw', 'status': 'Paid', 'isMe': true},
          {'name': 'bambiiisadeer', 'status': 'Paid'},
          {'name': 'amour', 'status': 'Unpaid'},
          {'name': 'lengsab', 'status': 'Pending'},
        ];

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          title: const Text(
            "Subscription Detail",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outlined, color: Colors.black),
              onPressed: _showDeleteConfirmationDialog,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and price
                Row(
                  children: [
                    Container(
                      width: 37.0,
                      height: 37.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(subscriptionData['logo'] ?? ''),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {},
                        ),
                        color: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      subscriptionData['name'] ?? 'Unknown Service',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${subscriptionData['price'] ?? '0'} THB",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Invite Code Section
                const Text(
                  "Invite Code",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _inviteCode,
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () => _handleCopy(_inviteCode),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isCopied ? Icons.check : Icons.copy,
                          size: 18.0,
                          color: const Color.fromARGB(255, 92, 94, 98),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Show in Market Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Show in Market",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),

                    Transform.scale(
                      scale: 0.70,
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: _showInMarket,
                        onChanged: (value) {
                          setState(() {
                            _showInMarket = value;
                          });
                        },
                        activeTrackColor: const Color.fromARGB(255, 92, 94, 98),
                        inactiveTrackColor: Colors.grey.shade400,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
                          states,
                        ) {
                          // ใช้ container ว่างเพื่อควบคุมขนาด
                          return const Icon(
                            Icons.circle,
                            size: 10.0, // ปรับขนาดวงกลมตรงนี้
                            color: Colors.white,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Members Section
                const Text(
                  "Member",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15.0),
                ...members.map((member) {
                  String name = member['name'] ?? '';
                  String status = member['status'] ?? 'Unpaid';
                  bool isMe = member['isMe'] ?? false;
                  String initial = name.isNotEmpty
                      ? name[0].toUpperCase()
                      : '?';
                  return _buildMemberItem(initial, name, status, isMe);
                }),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberItem(
    String initial,
    String name,
    String status,
    bool isMe,
  ) {
    Color statusBgColor;
    Color statusTextColor;

    switch (status) {
      case "Paid":
        statusBgColor = const Color.fromARGB(52, 65, 163, 19);
        statusTextColor = const Color.fromARGB(255, 65, 163, 19);
        break;
      case "Pending":
        statusBgColor = const Color.fromARGB(54, 255, 183, 0);
        statusTextColor = const Color.fromARGB(255, 255, 183, 0);
        break;
      case "Unpaid":
      default:
        statusBgColor = const Color.fromARGB(255, 255, 214, 214);
        statusTextColor = const Color.fromARGB(255, 177, 6, 15);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 37.0,
            height: 37.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 92, 94, 98),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              isMe ? "$name (Me)" : name,
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
            ),
          ),
          // ไม่แสดง status badge ถ้าเป็นคน (Me)
          if (!isMe)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                "• $status",
                style: TextStyle(
                  fontSize: 12.0,
                  color: statusTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
