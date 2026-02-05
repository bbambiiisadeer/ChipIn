import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _selectedFilter = 0;
  String _selectedDuration = "months";

  final List<String> _filters = [
    "All",
    "Netflix",
    "Spotify",
    "Youtube",
    "True Id",
  ];

  final List<String> _durationOptions = ["Days", "Months", "Years"];

  final List<Map<String, dynamic>> _marketplaceItems = [
    {
      "name": "Netflix Premium",
      "host": "bambiiiisadeer",
      "price": "105",
      "duration": "1 months",
      "logo": "assets/images/netflix.png",
      "category": "Netflix",
    },
    {
      "name": "Spotify Premium",
      "host": "poonbcw",
      "price": "42",
      "duration": "1 months",
      "logo": "assets/images/spotify.png",
      "category": "Spotify",
    },
    {
      "name": "Disney+",
      "host": "amour",
      "price": "49",
      "duration": "7 days",
      "logo": "assets/images/disney.png",
      "category": "Disney",
    },
    {
      "name": "Youtube Premium",
      "host": "poonbcw",
      "price": "39",
      "duration": "1 months",
      "logo": "assets/images/youtube.png",
      "category": "Youtube",
    },
    {
      "name": "Netflix Premium",
      "host": "user123",
      "price": "105",
      "duration": "1 months",
      "logo": "assets/images/netflix.png",
      "category": "Netflix",
    },
    {
      "name": "Spotify Premium",
      "host": "musiclover",
      "price": "42",
      "duration": "1 months",
      "logo": "assets/images/spotify.png",
      "category": "Spotify",
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    var items = _marketplaceItems;

    // Filter by category
    if (_selectedFilter != 0) {
      String selectedCategory = _filters[_selectedFilter];
      items = items
          .where((item) => item['category'] == selectedCategory)
          .toList();
    }

    // Filter by duration
    items = items
        .where((item) => item['duration'].contains(_selectedDuration))
        .toList();

    return items;
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
                        child: _buildDurationDropdown(),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDurationDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Duration",
          style: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        const SizedBox(width: 10),
        LayoutBuilder(
          builder: (context, constraints) {
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
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
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
                      child: Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedDuration,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Color(0xFF5C5E62),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMarketplaceGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.67,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildMarketplaceCard(item);
      },
    );
  }

  Widget _buildMarketplaceCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          Container(
            width: 63.0,
            height: 63.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(item['logo']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            item['name'],
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
          ),
          const SizedBox(height: 4),
          Text(
            "By ${item['host']}",
            style: const TextStyle(
              fontSize: 12.0,
              color: Color.fromARGB(255, 92, 94, 98),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${item['price']} THB",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
          ),
          const SizedBox(height: 4),
          Text(
            item['duration'],
            style: const TextStyle(fontSize: 14.0, color: Colors.black),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Handle see more action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "See more",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
