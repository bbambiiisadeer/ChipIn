import 'package:flutter/material.dart';

class AddReviewPage extends StatefulWidget {
  final Map<String, dynamic> subscription;

  const AddReviewPage({super.key, required this.subscription});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    // TODO: Implement review submission logic
    if (_rating > 0) {
      // Handle review submission
      Navigator.pop(context);
    } else {
      // Show error - rating required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
          ),
          title: Text(
            widget.subscription['name'] ?? 'Netflix',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
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
                const SizedBox(height: 10.0),
                // User info section
                Row(
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
                        'B',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'bambiiisadeer',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'This post will be shared publicly on the host\'s profile',
                          style: TextStyle(fontSize: 11.3, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                // Star rating section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          size: 30.0,
                          color: index < _rating
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30.0),
                // Review text field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Tell the experience you received',
                      hintStyle: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF9E9E9E),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 30.0),
                // Post button
                SizedBox(
                  height: 47.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStateProperty.all(0),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
