import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditingUsername = false;
  final TextEditingController _usernameController = TextEditingController(
    text: "poonbcw",
  );
  final FocusNode _usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // เพิ่ม listener เพื่ออัปเดต UI ทุกครั้งที่มีการพิมพ์
    _usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditingUsername) {
        // Save mode - บันทึกชื่อใหม่
        _isEditingUsername = false;
        _usernameFocusNode.unfocus();
      } else {
        // Edit mode - เข้าสู่โหมดแก้ไข
        _isEditingUsername = true;
        // รอให้ build เสร็จก่อนแล้วค่อย focus
        Future.delayed(const Duration(milliseconds: 100), () {
          _usernameFocusNode.requestFocus();
          // เลือกทั้งหมด
          _usernameController.selection = TextSelection.fromPosition(
            TextPosition(offset: _usernameController.text.length),
          );
        });
      }
    });
  }

  Widget _buildReviewItem({
    required String initial,
    required String username,
    required String date,
    required int rating,
    required String comment,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 227, 227, 227),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              // Avatar
              Container(
                width: 37.0,
                height: 37.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 237, 237, 237),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 92, 94, 98),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Username and date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username),
                  Text(date, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Star rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 20,
                color: index < rating
                    ? const Color(0xFFFFC107)
                    : const Color(0xFFD9D9D9),
              );
            }),
          ),
          const SizedBox(height: 12),
          // Comment
          Text(
            comment,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
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
          "Profile",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            // Profile Picture
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 237, 237, 237),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _usernameController.text.isNotEmpty
                      ? _usernameController.text[0].toUpperCase()
                      : "P",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 92, 94, 98),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Username with edit/save icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isEditingUsername
                    ? IntrinsicWidth(
                        child: TextField(
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onSubmitted: (value) {
                            _toggleEditMode();
                          },
                        ),
                      )
                    : Text(
                        _usernameController.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _toggleEditMode,
                  child: Icon(
                    _isEditingUsername ? Icons.check : Icons.edit,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Email
            const Text(
              "poonbcw@mail.com",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            // Rating Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side: Star icons and (0)
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          Icons.star,
                          size: 24,
                          color: Color(0xFFD9D9D9),
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                    const Text(
                      "(0)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Right side: no reviews
                const Text(
                  "no reviews",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 92, 94, 98),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Reviews Section - Scrollable
            Expanded(
              child: ListView(
                children: [
                  _buildReviewItem(
                    initial: "B",
                    username: "bambiilsadeer",
                    date: "Feb 1, 2025",
                    rating: 4,
                    comment:
                        "iloveyounababiinolekongchanbabiinarakteesudnailokloierakbabiinaka",
                  ),
                  const SizedBox(height: 12),
                  _buildReviewItem(
                    initial: "A",
                    username: "amourmawauau",
                    date: "Jan 31, 2025",
                    rating: 3,
                    comment: "rakpoonpoonchophaikanomrakpoonrakpongkaiduay",
                  ),
                  const SizedBox(height: 12),
                  _buildReviewItem(
                    initial: "N",
                    username: "nunnapat",
                    date: "Jan 12, 2025",
                    rating: 3,
                    comment: "rerd rerd rerd konkainoomyaimak",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันปิดเมื่อกดนอกกล่อง (ถ้าต้องการ)
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.zero, // รีเซ็ต padding เพื่อควบคุมความสูง
          content: SizedBox(
            height: 153.0, // กำหนดความสูงของกล่อง
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
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you sure you want to logout?',
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
                        splashFactory: NoSplash.splashFactory, // ลบ animation
                        overlayColor: Colors.transparent, // ลบสีเมื่อกด
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
                        Navigator.of(context).pop();
                        // TODO: Implement actual logout logic
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory, // ลบ animation
                        overlayColor: Colors.transparent, // ลบสีเมื่อกด
                      ),
                      child: const Text(
                        'Logout',
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
}
