import 'package:flutter/material.dart';
import 'createnewgroup.dart' as pages;
import 'groupdetails.dart';
import 'profile.dart';
import 'marketplace.dart';
import 'hostgroupdetails.dart';
import 'notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _filterIndex = 0;
  int _bottomNavIndex = 0;

  final List<String> _menuItems = ["All", "Host", "Member"];

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.home_sharp, "label": "Home"},
    {"icon": Icons.shopping_cart_sharp, "label": "Market"},
    {"icon": Icons.notifications, "label": "Notification"},
    {"icon": Icons.person_sharp, "label": "Profile"},
  ];

  final List<Map<String, dynamic>> _subscriptions = [
    {
      "name": "Netflix Premium",
      "price": "105",
      "logo": "assets/images/netflix.png",
      "endDate": "25 Dec.",
      "status": "Unpaid",
      "members": [
        {'name': 'poonbcw'},
        {'name': 'bambiiisadeer'},
        {'name': 'amour'},
      ],
      "paymentInfo": {
        'name': 'Poon Boonchoowit',
        'bank': 'KBank',
        'accountNumber': '123-4-56789-1',
      },
    },
    {
      "name": "Youtube Premium",
      "price": "49",
      "logo": "assets/images/youtube.png",
      "endDate": "25 Dec.",
      "status": "Paid",
      "members": [
        {'name': 'poonbcw'},
        {'name': 'user2'},
      ],
      "paymentInfo": {
        'name': 'Poon Boonchoowit',
        'bank': 'SCB',
        'accountNumber': '987-6-54321-0',
      },
    },
    {
      "name": "Youtube Premium",
      "price": "49",
      "logo": "assets/images/youtube.png",
      "endDate": "-",
      "status": "Pending",
      "members": [],
      "paymentInfo": null,
    },
  ];

  void _showAddSubscriptionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Add Subscription",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter Invite Code",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: "e.g. DRB-7394",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              minimumSize: const Size(80, 47),
                            ),
                            child: const Text(
                              "Join",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey[400], thickness: 1),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[400], thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // ปิด modal ก่อน

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const pages.CreateNewGroupPage(),
                        ),
                      );

                      if (!context.mounted) return;

                      if (result != null) {
                        final newGroup = Map<String, dynamic>.from(result);
                        newGroup['status'] = "";
                        newGroup['members'] = [];
                        newGroup['paymentInfo'] = {};

                        setState(() {
                          _subscriptions.add(newGroup);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Create New Group",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to get the current page based on bottom nav index
  Widget _getCurrentPage() {
    switch (_bottomNavIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return MarketplacePage();
      case 2:
        return NotificationPage();
      case 3:
        return const ProfilePage();
      default:
        return _buildHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _bottomNavIndex == 0
          ? AppBar(
              centerTitle: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Hi, Poon",
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              actions: [
                // เพิ่มปุ่มทดสอบตรงนี้
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const HostGroupDetailsPage(subscription: {}),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      body: _getCurrentPage(),

      floatingActionButton: Visibility(
        visible: _bottomNavIndex == 0,
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        child: FloatingActionButton(
          onPressed: () {
            _showAddSubscriptionModal(context);
          },
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          elevation: 2,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 57.0,
            padding: EdgeInsets.fromLTRB(
              _bottomNavIndex == 0 ? 5.0 : 25.0,
              5.5,
              _bottomNavIndex == 3 ? 5.0 : 25.0,
              5.0,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 30, 30, 30),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_navItems.length, (index) {
                bool isSelected = _bottomNavIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _bottomNavIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 53.0,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 62, 63, 66)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: isSelected
                        ? const EdgeInsets.symmetric(horizontal: 20.0)
                        : const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_navItems[index]['icon'], color: Colors.white),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              width: isSelected ? null : 0.0,
                              child: Padding(
                                padding: isSelected
                                    ? const EdgeInsets.only(
                                        left: 6.0,
                                        bottom: 2.0,
                                      )
                                    : EdgeInsets.zero,
                                child: Text(
                                  _navItems[index]['label'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // 1. กำหนด Query พื้นฐานไปที่คอลเลกชัน 'groups'
    Query groupQuery = FirebaseFirestore.instance.collection('groups');

    // 2. ปรับแต่ง Query ตาม Filter Index
    if (_filterIndex == 0) {
      // [All] แสดงกลุ่มที่เราเป็นสมาชิก (รวมถึงกลุ่มที่เราเป็น Host และใส่ชื่อตัวเองใน members แล้ว)
      groupQuery = groupQuery.where('members', arrayContains: currentUserId);
    } else if (_filterIndex == 1) {
      // [Host] แสดงเฉพาะกลุ่มที่เราเป็นคนสร้าง
      groupQuery = groupQuery.where('createdBy', isEqualTo: currentUserId);
    } else if (_filterIndex == 2) {
      // [Member] แสดงกลุ่มที่เราเป็นสมาชิก "แต่ไม่ใช่คนสร้าง"
      // หมายเหตุ: Firestore ไม่อนุญาตให้ใช้ != กับ arrayContains ใน Query เดียวกันแบบตรงๆ
      // จึงแนะนำให้ใช้ filter 'members' แล้วไปเช็คเงื่อนไข UI หรือใช้การกรองเบื้องต้นดังนี้:
      groupQuery = groupQuery.where('members', arrayContains: currentUserId);
    }

    return ListView(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100),
      children: [
        _buildTotalDueCard(),
        const SizedBox(height: 30.0),
        const Text(
          "Your Subscription",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20.0),
        _buildFilterBar(),
        const SizedBox(height: 15.0),

        StreamBuilder<QuerySnapshot>(
          // ใส่ orderBy เพื่อให้กลุ่มที่สร้างล่าสุดขึ้นก่อน
          stream: groupQuery.orderBy('createdAt', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("No subscriptions found"),
                ),
              );
            }

            // กรองข้อมูลเพิ่มเติมสำหรับกรณี Member (เพื่อไม่ให้ซ้ำกับ Host)
            var docs = snapshot.data!.docs;
            if (_filterIndex == 2) {
              docs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['createdBy'] != currentUserId;
              }).toList();
            }

            if (docs.isEmpty) {
              return const Center(child: Text("No subscriptions found"));
            }

            return Column(
              children: docs.map((DocumentSnapshot document) {
                Map<String, dynamic> sub =
                    document.data()! as Map<String, dynamic>;

                // Logic กำหนดสถานะสี Paid/Unpaid
                String statusToShow;
                if (sub['createdBy'] == currentUserId) {
                  statusToShow = "Paid"; // เราเป็น Host เห็นเป็น Paid เสมอ
                } else {
                  statusToShow = sub['status'] ?? "Unpaid";
                }

                // จัดการเรื่องวันที่
                String displayDate = "-";
                if (sub['endDate'] != null) {
                  DateTime date = (sub['endDate'] as Timestamp).toDate();
                  List<String> months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec",
                  ];
                  displayDate = "${date.day} ${months[date.month - 1]}.";
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              sub['createdBy'] == currentUserId
                              ? HostGroupDetailsPage(subscription: sub)
                              : GroupDetailsPage(subscription: sub),
                        ),
                      );
                    },
                    child: SubscriptionCard(
                      name: sub['serviceName'] ?? "Unknown",
                      price: sub['price'].toString(),
                      logoPath: sub['logo'] ?? "assets/images/netflix.png",
                      endDate: displayDate,
                      status: statusToShow,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTotalDueCard() {
    return Container(
      height: 110.0,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 237, 237),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text("Total due"),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: const [
                  Text(
                    "0.00",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 40.0,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "THB",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 47.0,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 237, 237),
        borderRadius: BorderRadius.circular(24.0),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: List.generate(_menuItems.length, (index) {
          bool isSelected = _filterIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _filterIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Center(
                  child: Text(
                    _menuItems[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.black
                          : const Color.fromARGB(255, 92, 94, 98),
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String name;
  final String price;
  final String logoPath;
  final String endDate;
  final String status;

  const SubscriptionCard({
    super.key,
    required this.name,
    required this.price,
    required this.logoPath,
    required this.endDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;
    bool hasStatus = status.isNotEmpty;
    String statusText = "• $status";

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

    Widget mainCardContent = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 242, 242, 242),
              width: 1.0,
            ),
            image: DecorationImage(image: AssetImage(logoPath)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    "$price THB",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              status == "Unpaid" ? const Spacer() : const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "End Date: $endDate",
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  const Spacer(),
                  if (hasStatus)
                    Container(
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 2.0,
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    if (status == "Unpaid") {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237),
          border: Border.all(
            color: const Color.fromARGB(255, 237, 237, 237),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(15.0),
              child: IntrinsicHeight(child: mainCardContent),
            ),
            Transform.translate(
              offset: const Offset(0, -5),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled_rounded,
                      size: 16.0,
                      color: Color.fromARGB(255, 92, 94, 98),
                    ),
                    const SizedBox(width: 6.0),
                    const Text(
                      "Please pay within 12 h 05 m",
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 94, 98),
                        fontSize: 12.0,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Pay now",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(15.0),
        height: 84.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color.fromARGB(255, 227, 227, 227),
            width: 1.0,
          ),
        ),
        child: mainCardContent,
      );
    }
  }
}
