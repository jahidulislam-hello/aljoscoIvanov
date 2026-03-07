import 'package:flutter/material.dart';
import 'package:freshbite/features/recepies/recipes_search/recipe_search_model.dart';
import 'package:freshbite/features/recepies/recipes_search/recipes_search_service.dart';
import 'package:get/get.dart';

class AddToCollectionScreen extends StatelessWidget {
  final RecipeRecipeSearchModel recipe;
  
  const AddToCollectionScreen({super.key, required this.recipe});

  /// Show as a bottom sheet popup
  static Future<bool?> show(BuildContext context, RecipeRecipeSearchModel recipe) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddToCollectionScreen(recipe: recipe);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AddToCollectionContent(recipe: recipe);
  }
}

class _AddToCollectionContent extends StatefulWidget {
  final RecipeRecipeSearchModel recipe;
  
  const _AddToCollectionContent({required this.recipe});

  @override
  State<_AddToCollectionContent> createState() => _AddToCollectionScreenState();
}

class _AddToCollectionScreenState extends State<_AddToCollectionContent> {
  String selectedCollection = 'Favorites';
  bool isLoading = false;

  final List<Map<String, String>> collections = [
    {
      'title': 'Favorites',
      'image': 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=200&h=200&fit=crop',
    },
    {
      'title': 'Birthday Specials',
      'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=200&h=200&fit=crop',
    },
    {
      'title': 'Anniversary Dinner',
      'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200&h=200&fit=crop',
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

  Future<void> _saveRecipeToCollection() async {
    setState(() {
      isLoading = true;
    });

    try {
      final success = await RecipesSearchService.saveRecipeToCollection(
        widget.recipe.id,
        selectedCollection,
      );

      if (success && mounted) {
        Navigator.pop(context, true);
        Get.snackbar(
          'Success'.tr,
          'Recipe added to $selectedCollection',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1D3108),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      } else if (mounted) {
        Get.snackbar(
          'Error'.tr,
          'Failed to save recipe',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error'.tr,
          'An error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveRecipeToCollection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D3108),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save to Collection',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
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