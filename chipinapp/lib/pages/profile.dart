import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

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

  final AuthService _authService = AuthService();
  UserModel? _user; // สำหรับเก็บข้อมูลผู้ใช้
  bool _isFetching = true; // สำหรับแสดงตัวหมุนตอนโหลดข้อมูล

  @override
  void initState() {
    super.initState();
    // เพิ่ม listener เพื่ออัปเดต UI ทุกครั้งที่มีการพิมพ์
    _loadUserData(); // เรียกดึงข้อมูลเมื่อเปิดหน้านี้
    _usernameController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      String uid = currentUser.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          // ดึงข้อมูลแมนนวลมาใส่ Controller เพื่อความชัวร์ (แก้ปัญหา Null)
          _usernameController.text = data['username'] ?? 'User';

          // สร้าง UserModel ขึ้นมาใหม่โดยอิงชื่อฟิลด์จาก AuthService เป๊ะๆ
          _user = UserModel(
            id: data['uid'] ?? uid,
            username: data['username'] ?? 'User',
            email: data['email'] ?? '',
            authProvider:
                data['auth_provider'] ??
                'email', // ชื่อฟิลด์ต้องตรงกับ AuthService
            averageRating: (data['average_rating'] ?? 0.0).toDouble(),
            createdAt: data['created_at'] != null
                ? (data['created_at'] as Timestamp).toDate()
                : DateTime.now(),
          );

          _isFetching = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      if (mounted) setState(() => _isFetching = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  void _toggleEditMode() async {
    // เพิ่ม async
    if (_isEditingUsername) {
      // กำลังจะกดบันทึก (จากไอคอน Check)
      String newName = _usernameController.text.trim();

      if (newName.isNotEmpty && newName != _user?.username) {
        try {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'username': newName,
          }); // อัปเดตชื่อใน Firestore

          print("Username updated successfully!");
        } catch (e) {
          print("Failed to update username: $e");
          // ถ้าบันทึกไม่สำเร็จ อาจจะดึงค่าเก่ากลับมาใส่ controller
          _usernameController.text = _user?.username ?? "";
        }
      }

      setState(() {
        _isEditingUsername = false;
        _usernameFocusNode.unfocus();
      });
    } else {
      // เข้าสู่โหมดแก้ไข (ไอคอน Edit)
      setState(() {
        _isEditingUsername = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _usernameFocusNode.requestFocus();
      });
    }
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
      body: _isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            ) // แสดงตัวโหลดถ้ายังดึงไม่เสร็จ
          : Padding(
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
                            : "U",
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
                  Text(
                    _user?.email ?? "Loading...",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                          comment:
                              "rakpoonpoonchophaikanomrakpoonrakpongkaiduay",
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
                      onPressed: () async {
                        // 1. ปิด Dialog
                        Navigator.of(context).pop();

                        // 2. เรียกฟังก์ชัน Logout จาก Service
                        await _authService.logout();

                        // 3. ย้ายผู้ใช้กลับไปที่หน้า Login และล้าง Stack หน้าจอทั้งหมด
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/signin',
                            (route) => false,
                          );
                        }
                      },
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
