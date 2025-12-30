import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  String? _selectedService;
  String? _selectedDurationUnit = "Months";
  String? _selectedBank;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  int _slotsOpen = 1;

  final List<Map<String, String>> _serviceOptions = [
    {"name": "Netflix", "image": "assets/images/netflix.png"},
    {"name": "Youtube", "image": "assets/images/youtube.png"},
    {"name": "Spotify", "image": "assets/images/spotify.png"},
    {"name": "Disney +", "image": "assets/images/disney+.png"},
  ];

  final List<String> _durationUnits = ["Months", "Years"];
  final List<String> _bankOptions = ["SCB", "Kbank", "Bangkok Bank", "Krungsri"];

  @override
  Widget build(BuildContext context) {
    Map<String, String>? selectedServiceData;
    if (_selectedService != null) {
      selectedServiceData = _serviceOptions.firstWhere(
        (element) => element['name'] == _selectedService,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0,
        title: const Text(
          "Create Subscription",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Section
              const Text(
                "Service",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15.0),
              _buildServiceDropdown(selectedServiceData),
              
              const SizedBox(height: 25.0),
              
              // Price Section
              const Text(
                "Price",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15.0),
              _buildPriceField(),
              
              const SizedBox(height: 25.0),
              
              // Duration Section
              const Text(
                "Duration",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDurationField(),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _buildDurationUnitDropdown(),
                  ),
                ],
              ),
              
              const SizedBox(height: 25.0),
              
              // Payment Info Section
              const Text(
                "Payment Info",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildNameField(),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _buildBankDropdown(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              _buildBankAccountField(),
              
              const SizedBox(height: 25.0),
              
              // Slots Open Section
              const Text(
                "Slots Open",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15.0),
              _buildSlotsCounter(),
              
              const SizedBox(height: 10.0),
              
              Center(
                child: Text(
                  "The group will disappear once all slots are filled",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              
              const SizedBox(height: 30.0),
              
              // Done Button
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle done action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDropdown(Map<String, String>? selectedServiceData) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 5),
            constraints: BoxConstraints.tightFor(
              width: constraints.maxWidth,
            ),
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
                _selectedService = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _serviceOptions.map((item) {
                return PopupMenuItem<String>(
                  value: item['name'],
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(item['image']!),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          item['name']!,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList();
            },
            child: Container(
              height: 47.0,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFFF5F5F5),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  if (_selectedService == null)
                    const Text(
                      "Service",
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                selectedServiceData!['image']!,
                              ),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          selectedServiceData['name']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xFF5C5E62),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceField() {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFFF5F5F5),
      ),
      child: TextField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Price",
          hintStyle: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16.0,
          ),
          suffixText: "THB",
          suffixStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildDurationField() {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFFF5F5F5),
      ),
      child: TextField(
        controller: _durationController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "Duration",
          hintStyle: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildDurationUnitDropdown() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 5),
            constraints: BoxConstraints.tightFor(
              width: constraints.maxWidth,
            ),
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
                _selectedDurationUnit = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _durationUnits.map((unit) {
                return PopupMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList();
            },
            child: Container(
              height: 47.0,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFFF5F5F5),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedDurationUnit ?? "Months",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xFF5C5E62),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFFF5F5F5),
      ),
      child: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: "Name",
          hintStyle: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildBankDropdown() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 5),
            constraints: BoxConstraints.tightFor(
              width: constraints.maxWidth,
            ),
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
                _selectedBank = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _bankOptions.map((bank) {
                return PopupMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList();
            },
            child: Container(
              height: 47.0,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFFF5F5F5),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedBank ?? "Bank",
                    style: TextStyle(
                      color: _selectedBank == null ? const Color(0xFF9E9E9E) : Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xFF5C5E62),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankAccountField() {
    return Container(
      height: 47.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFFF5F5F5),
      ),
      child: TextField(
        controller: _bankAccountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "Bank Account Number",
          hintStyle: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildSlotsCounter() {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.person,
            size: 60.0,
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (_slotsOpen > 1) {
                    setState(() {
                      _slotsOpen--;
                    });
                  }
                },
                icon: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Icon(Icons.remove),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "$_slotsOpen",
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _slotsOpen++;
                  });
                },
                icon: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _nameController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }
}