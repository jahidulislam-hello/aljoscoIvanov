import 'package:flutter/material.dart';


class AddToCollectionScreen extends StatefulWidget {
  const AddToCollectionScreen({super.key});

  @override
  State<AddToCollectionScreen> createState() => _AddToCollectionScreenState();
}

class _AddToCollectionScreenState extends State<AddToCollectionScreen> {
  String selectedCollection = 'Birthday Specials';

  final List<Map<String, String>> collections = [
    {
      'title': 'Favorites',
      'image': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=200&h=200&fit=crop',
    },
    {
      'title': 'Birthday Specials',
      'image': 'https://images.unsplash.com/photo-1535141123063-3bb466ae7b3f?w=200&h=200&fit=crop',
    },
    {
      'title': 'Anniversary Dinner',
      'image': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=200&h=200&fit=crop',
    },
  ];

  void _showCreateCollectionPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFF1D3108), size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Collection Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D3108),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter collection name',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: const Color(0xFFF7F8F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle creation logic
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D3108),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Collection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First item (Favorites)
                    _buildCollectionItem(collections[0]),

                    const SizedBox(height: 24),

                    // Create New Collection Button
                    GestureDetector(
                      onTap: _showCreateCollectionPopup,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1D3108),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Create New Collection',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3108),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Add To Collection',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3108),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Other items
                    _buildCollectionItem(collections[1]),
                    const SizedBox(height: 16),
                    _buildCollectionItem(collections[2]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionItem(Map<String, String> item) {
    bool isSelected = selectedCollection == item['title'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCollection = item['title']!;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFDFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D3108),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1D3108) : Colors.black,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1D3108),
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}