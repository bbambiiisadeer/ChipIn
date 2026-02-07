import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _selectedFilter = 0;
  String _selectedDuration = "All";
  String _selectedSort = "Rating";

  final List<String> _filters = [
    "All",
    "Netflix",
    "Spotify",
    "Youtube",
    "Disney+",
  ];

  final List<String> _durationOptions = ["All", "Days", "Months", "Years"];
  final List<String> _sortOptions = ["Rating", "Price", "Duration"];

  List<Map<String, dynamic>> _marketplaceItems = [];

  void _showSuccessModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 30),

              // Success icon
              Container(
                width: 55.0,
                height: 55.0,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),

              // Success text
              const Text(
                "Success !",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              // Description
              const Text(
                "Your request has been sent,",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              const Text(
                "Please wait for the host to approve.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Done",
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
        );
      },
    );
  }

  void _showSubscriptionRequestModal(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final TextEditingController emailController = TextEditingController();

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
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Logo and Title
                Row(
                  children: [
                    Container(
                      width: 37.0,
                      height: 37.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(item['logo']),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 242, 242, 242),
                          width: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Expanded จะดัน Widget ถัดไปให้ไปสุดขอบขวา
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // แนะนำ: ตัดคำถ้าชื่อยาวเกิน
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to reviews page
                      },
                      // เพิ่ม style ตรงนี้
                      style: TextButton.styleFrom(
                        alignment:
                            Alignment.centerRight, // จัดข้อความในปุ่มให้ชิดขวา
                        padding: EdgeInsets.zero, // ลบระยะห่างรอบๆ ปุ่มออก
                        minimumSize: Size
                            .zero, // ให้ปุ่มเล็กที่สุดเท่าที่ข้อความกินพื้นที่
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // ลดพื้นที่การกดให้กระชับ
                      ),
                      child: const Text(
                        "See reviews",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Info rows
                _buildInfoRow("By", item['host']),
                const Divider(height: 1),
                _buildInfoRow("Price", "${item['price']} THB"),
                const Divider(height: 1),
                _buildInfoRow("Duration", item['duration']),
                const SizedBox(height: 20),

                // Service Email section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Service Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Send Request button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Handle send request
                      if (emailController.text.isNotEmpty) {
                        // Close the current modal first
                        Navigator.pop(context);
                        // Show success modal
                        _showSuccessModal(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Send Request",
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 92, 94, 98),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    // Mock data
    _marketplaceItems = [
      {
        "name": "Netflix Premium",
        "host": "bambiiiisadeer",
        "price": "125",
        "duration": "1 months",
        "logo": "assets/images/netflix.png",
        "category": "Netflix",
        "rating": 5.0,
        "timestamp": DateTime.now().subtract(const Duration(days: 20)),
      },
      {
        "name": "Spotify Premium",
        "host": "poonbcw",
        "price": "42",
        "duration": "1 months",
        "logo": "assets/images/spotify.png",
        "category": "Spotify",
        "rating": 4.8,
        "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        "name": "Disney+",
        "host": "amour",
        "price": "49",
        "duration": "7 days",
        "logo": "assets/images/disney+.png",
        "category": "Disney",
        "rating": 4.2,
        "timestamp": DateTime.now().subtract(const Duration(days: 15)),
      },
      {
        "name": "Youtube Premium",
        "host": "poonbcw",
        "price": "39",
        "duration": "1 months",
        "logo": "assets/images/youtube.png",
        "category": "Youtube",
        "rating": 4.7,
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "name": "Netflix Premium",
        "host": "user123",
        "price": "105",
        "duration": "1 months",
        "logo": "assets/images/netflix.png",
        "category": "Netflix",
        "rating": 4.3,
        "timestamp": DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        "name": "Spotify Premium",
        "host": "musiclover",
        "price": "42",
        "duration": "1 months",
        "logo": "assets/images/spotify.png",
        "category": "Spotify",
        "rating": 4.9,
        "timestamp": DateTime.now(),
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredItems {
    var items = List<Map<String, dynamic>>.from(_marketplaceItems);

    // Filter by category
    if (_selectedFilter != 0) {
      String selectedCategory = _filters[_selectedFilter];
      items = items
          .where((item) => item['category'] == selectedCategory)
          .toList();
    }

    // Filter by duration
    if (_selectedDuration != "All") {
      items = items
          .where(
            (item) => item['duration'].toLowerCase().contains(
              _selectedDuration.toLowerCase(),
            ),
          )
          .toList();
    }

    // ถ้าเลือก All (ไม่ได้กรอง category) ให้เรียงตาม timestamp ก่อน
    if (_selectedFilter == 0) {
      items.sort((a, b) {
        DateTime timeA = a['timestamp'] as DateTime;
        DateTime timeB = b['timestamp'] as DateTime;
        return timeB.compareTo(timeA); // ล่าสุดก่อน
      });
    } else {
      // ถ้าเลือก category เฉพาะแล้ว ถึงจะใช้ sort options
      switch (_selectedSort) {
        case "Rating":
          // เรียงจากมากไปน้อย (สูงสุดก่อน)
          items.sort((a, b) {
            double ratingA = (a['rating'] as num?)?.toDouble() ?? 0.0;
            double ratingB = (b['rating'] as num?)?.toDouble() ?? 0.0;
            return ratingB.compareTo(ratingA);
          });
          break;
        case "Price":
          // เรียงจากน้อยไปมาก (ถูกก่อน)
          items.sort((a, b) {
            int priceA = int.tryParse(a['price'] ?? '0') ?? 0;
            int priceB = int.tryParse(b['price'] ?? '0') ?? 0;
            return priceA.compareTo(priceB);
          });
          break;
        case "Duration":
          // เรียงจากน้อยไปมาก (สั้นก่อน)
          items.sort((a, b) {
            int durationA = _parseDuration(a['duration'] ?? '0 days');
            int durationB = _parseDuration(b['duration'] ?? '0 days');
            return durationA.compareTo(durationB);
          });
          break;
      }
    }

    return items;
  }

  int _parseDuration(String duration) {
    final parts = duration.split(' ');
    if (parts.length < 2) return 0;

    int value = int.tryParse(parts[0]) ?? 0;
    String unit = parts[1].toLowerCase();

    if (unit.contains('month')) {
      return value * 30;
    } else if (unit.contains('year')) {
      return value * 365;
    } else if (unit.contains('day')) {
      return value;
    }
    return 0;
  }

  // ฟังก์ชันสำหรับรีเซ็ต sort และ duration
  void _resetFilters() {
    setState(() {
      _selectedSort = "Rating";
      _selectedDuration = "All";
    });
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
          "Marketplace",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          const SizedBox(height: 20),
          Expanded(child: _buildMarketplaceGrid()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        // Category filters row
        SizedBox(
          height: 40.0,
          child: _selectedFilter == 0
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15.0),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = index;
                            // ถ้ากดเลือก category อื่นที่ไม่ใช่ All ให้รีเซ็ต filters
                            if (index != 0) {
                              _resetFilters();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(
                            color: index == 0 ? Colors.black : Colors.white,
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Center(
                            child: Text(
                              _filters[index],
                              style: TextStyle(
                                color: index == 0 ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = 0;
                            // กด X กลับไป All ให้รีเซ็ต filters
                            _resetFilters();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  _filters[_selectedFilter],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Row(
                          children: [
                            _buildSortButton(),
                            const SizedBox(width: 10),
                            _buildFilterButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        position: PopupMenuPosition.under,
        offset: const Offset(0, 5),
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: const Color.fromARGB(255, 237, 237, 237),
            width: 1,
          ),
        ),
        popUpAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
        ),
        onSelected: (String value) {
          setState(() {
            _selectedSort = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return _sortOptions.map((sort) {
            return PopupMenuItem<String>(
              value: sort,
              child: Row(
                children: [
                  Text(
                    sort,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (sort == _selectedSort) ...[
                    const Spacer(),
                    const Icon(Icons.check, size: 18, color: Colors.black),
                  ],
                ],
              ),
            );
          }).toList();
        },
        child: Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.swap_vert, color: Color(0xFF5C5E62), size: 20),
              const SizedBox(width: 5),
              const Text(
                "Sort",
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        position: PopupMenuPosition.under,
        offset: const Offset(0, 5),
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: const Color.fromARGB(255, 237, 237, 237),
            width: 1,
          ),
        ),
        popUpAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
        ),
        onSelected: (String value) {
          setState(() {
            _selectedDuration = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return _durationOptions.map((duration) {
            return PopupMenuItem<String>(
              value: duration,
              child: Row(
                children: [
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (duration == _selectedDuration) ...[
                    const Spacer(),
                    const Icon(Icons.check, size: 18, color: Colors.black),
                  ],
                ],
              ),
            );
          }).toList();
        },
        child: Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 237, 237),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer_outlined,
                color: Color(0xFF5C5E62),
                size: 20,
              ),
              const SizedBox(width: 5),
              const Text(
                "Duration",
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketplaceGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.83,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildMarketplaceCard(item);
      },
    );
  }

  Widget _buildMarketplaceCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        _showSubscriptionRequestModal(context, item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color.fromARGB(255, 227, 226, 226),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 63.0,
                  height: 63.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(item['logo']),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: const Color.fromARGB(255, 242, 242, 242),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                item['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${item['price']} THB",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['duration'],
                style: const TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFB700)),
                  const SizedBox(width: 4),
                  Text(
                    "${item['rating']}",
                    style: const TextStyle(fontSize: 12.0, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
