import 'package:flutter/material.dart';
import 'package:freshbite/features/recepies/recipes_search/recipe_search_model.dart';
import 'package:freshbite/features/recepies/recipes_search/collection_service.dart';
import 'package:freshbite/features/recepies/recipes_search/models/collection_model.dart';
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
  String? selectedCollectionId;
  String? selectedCollectionName;
  bool isLoading = false;
  bool isFetchingCollections = true;
  List<CollectionModel> collections = [];
  final TextEditingController _collectionNameController = TextEditingController();

  void _showCreateCollectionPopup() {
    _collectionNameController.clear();
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
                  controller: _collectionNameController,
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
                    onPressed: _createCollection,
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

  Future<void> _createCollection() async {
    final collectionName = _collectionNameController.text.trim();
    if (collectionName.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please enter a collection name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    Navigator.pop(context); // Close the dialog

    setState(() {
      isLoading = true;
    });

    try {
      final newCollection = await CollectionService.createCollection(collectionName);

      if (newCollection != null && mounted) {
        setState(() {
          collections.add(newCollection);
          selectedCollectionId = newCollection.id;
          selectedCollectionName = newCollection.collectionName;
        });

        Get.snackbar(
          'Success'.tr,
          'Collection created successfully',
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
          'Failed to create collection',
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

  Future<void> _saveRecipeToCollection() async {
    if (selectedCollectionId == null) {
      Get.snackbar(
        'Error'.tr,
        'Please select a collection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await CollectionService.addRecipeToCollection(
        recipeId: widget.recipe.id,
        collectionId: selectedCollectionId!,
      );

      if (success && mounted) {
        Navigator.pop(context, true);
        Get.snackbar(
          'Success'.tr,
          'Recipe added to $selectedCollectionName',
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

  Future<void> _fetchCollections() async {
    setState(() {
      isFetchingCollections = true;
    });

    try {
      final fetchedCollections = await CollectionService.getCollections();
      if (mounted) {
        setState(() {
          collections = fetchedCollections;
          if (collections.isNotEmpty) {
            selectedCollectionId = collections.first.id;
            selectedCollectionName = collections.first.collectionName;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error'.tr,
          'Failed to load collections',
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
          isFetchingCollections = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCollections();
  }

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
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
                // Loading state
                if (isFetchingCollections)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFF1D3108),
                      ),
                    ),
                  )
                else ...[
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

                  // Collections list
                  if (collections.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'No collections yet. Create one!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        final collection = collections[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: index < collections.length - 1 ? 16 : 0),
                          child: _buildCollectionItem(collection),
                        );
                      },
                    ),

                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading || collections.isEmpty ? null : _saveRecipeToCollection,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(CollectionModel collection) {
    bool isSelected = selectedCollectionId == collection.id;
    String imageUrl = collection.recipes.isNotEmpty && collection.recipes.first.images.isNotEmpty
        ? collection.recipes.first.images.first
        : 'https://images.unsplash.com/photo-1473093226795-af9932fe5856?w=200&h=200&fit=crop';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCollectionId = collection.id;
          selectedCollectionName = collection.collectionName;
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
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.restaurant, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                collection.collectionName,
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