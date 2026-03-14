import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_controller/create_recipes_controller.dart';
import 'package:freshbite/features/recepies/create_recipes/text_editor/rich_text_editor.dart';
import 'package:get/get.dart';



class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final RecipeController controller = RecipeController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Create Recipe',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h), // Top spacing to align content properly with app bar
                  _buildSectionTitle('Recipe name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: 'e.g "Spaghetti Bolognese"',
                    onChanged: controller.updateRecipeName,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Recipe images'),
                  const SizedBox(height: 8),
                  _buildImagePickers(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Description'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: 'e.g "Classic Italian pasta with rich tomato meat sauce"',
                    maxLines: 3,
                    onChanged: (v) => controller.description = v,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Servings'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: 'e.g. 4 servings',
                    onChanged: (v) => controller.servings = v,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Recipe Components'),
                  const SizedBox(height: 8),
                  _buildComponentChips(),
                  const SizedBox(height: 24),

                  _buildCookingMode(),
                  const SizedBox(height: 24),

                  _buildTimeInputs(),
                  const SizedBox(height: 24),

                  _buildInstructions(),
                  const SizedBox(height: 24),

                  _buildIngredients(),
                  const SizedBox(height: 24),

                  _buildNutritionalValues(),
                  const SizedBox(height: 24),

                  _buildAllergens(),
                  const SizedBox(height: 24),

                  _buildTags(),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: controller.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1C2D07),
                                ),
                              )
                            : CustomTextButton(
                                text: 'SAVE RECIPE',
                                onTap: () async {
                                  final success = await controller.saveRecipe();
                                  if (success && mounted) {
                                    Get.snackbar(
                                      'Success'.tr,
                                      'Recipe created successfully!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xFF1C2D07),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                    );
                                    Navigator.pop(context, true);
                                  } else if (mounted) {
                                    Get.snackbar(
                                      'Error'.tr,
                                      'Failed to create recipe. Please check all required fields.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xFFA63005),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextField(
      maxLines: maxLines,
      onChanged: onChanged,
      style: GoogleFonts.rubik(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.rubik(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildImagePickers() {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < 3 ? 8 : 0),
            child: GestureDetector(
              onTap: () => controller.pickImage(index),
              child: Container(
                height: 84.h,
                width: 78.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF868686), ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: controller.recipeImages[index] != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    controller.recipeImages[index]!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.imageIcon,
                      width: 32.w,
                      height: 32.h,
                      color: Colors.grey[400], // optional
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload Image',
                      style: GoogleFonts.rubik(
                          color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildComponentChips() {
    final components = {
      'Vegetable': 'assets/icons/vegetable.png',
      'Connector': 'assets/icons/drop.png',
      'Topping': 'assets/icons/topping.png',
      'Protein': 'assets/icons/protein.png',
      'Base': 'assets/icons/bow.png',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: components.entries.map((entry) {
        final comp = entry.key;
        final iconPath = entry.value;
        final isSelected = controller.selectedComponents.contains(comp);
        return GestureDetector(
          onTap: () => controller.toggleComponent(comp),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
              border: Border.all(
                color: isSelected ? const Color(0xFF2D5016) : const Color(0xFFC7C7C7),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Image.asset(
                    iconPath,
                    width: 16,
                    height: 16,
                    color: isSelected ? const Color(0xFF2D5016) : Colors.grey,
                  ),
                ),
                Text(
                  comp,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: isSelected ? const Color(0xFF2D5016) : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCookingMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Cooking Mode'),
            const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Everyday', 'Emergency', 'Meal Prep'].map((mode) {
            final isSelected = controller.selectedCookingMode == mode;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: mode != 'Meal Prep' ? 8 : 0),
                child: GestureDetector(
                  onTap: () => controller.setCookingMode(mode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2D5016) : const Color(0xFFC7C7C7),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      mode,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        color: isSelected ? const Color(0xFF2D5016) : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeInputs() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Time', style: GoogleFonts.rubik(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => controller.totalTime = v,
                decoration: InputDecoration(
                  hintText: 'e.g. 40 min',
                  hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Prep Time', style: GoogleFonts.rubik(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => controller.prepTime = v,
                decoration: InputDecoration(
                  hintText: 'e.g. 15 min',
                  hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cook Time', style: GoogleFonts.rubik(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => controller.cookTime = v,
                decoration: InputDecoration(
                  hintText: 'e.g. 45 min',
                  hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Instructions'),
        const SizedBox(height: 8),
        ...controller.instructions.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichTextEditor(
              index: entry.key,
              hint: 'e.g. Heat oil and sauté onions until translucent...',
              instruction: entry.value,
              onChanged: (text) => controller.updateInstruction(entry.key, text: text),
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: controller.addInstruction,
          child: Container(
            height: 40,
            width: 151.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1C2D07),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add another step',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final List<String> _categoryOptions = [
    'Dairy, Eggs & Plant-Based',
    'Meat & Seafood',
    'Fruits & Vegetables',
    'Grains & Bread',
    'Condiments & Spices',
    'Canned & Packaged',
    'Frozen Foods',
    'Beverages',
    'Snacks & Sweets',
    'Other'
  ];

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Ingredient Items'),
        const SizedBox(height: 8),
        ...controller.ingredients.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                // First Row - Name, Quantity, Unit, tsp, Delete
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'e.g. Spaghetti',
                          hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                          ),
                        ),
                        onChanged: (v) => controller.updateIngredient(entry.key, name: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g. 400',
                          hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                          ),
                        ),
                        onChanged: (v) => controller.updateIngredient(entry.key, quantity: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2D07),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Unit', style: GoogleFonts.rubik(color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text('tsp', style: GoogleFonts.rubik(color: const Color(0xFF868686), fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.removeIngredient(entry.key),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFA63005), size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Second Row - Category Dropdown, Quantity2, Unit, g/ml
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2D07),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: entry.value.category.isEmpty ? null : entry.value.category,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Select Category',
                                style: GoogleFonts.rubik(color: Colors.white, fontSize: 13),
                              ),
                            ),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                            ),
                            style: GoogleFonts.rubik(fontSize: 13, color: Colors.white),
                            selectedItemBuilder: (BuildContext context) {
                              return _categoryOptions.map((String value) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      value.length > 15 ? '${value.substring(0, 15)}...' : value,
                                      style: GoogleFonts.rubik(color: Colors.white, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items: _categoryOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.rubik(color: const Color(0xFF3A3A35), fontSize: 13),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.updateIngredient(entry.key, category: newValue);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g. 400',
                          hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                          ),
                        ),
                        onChanged: (v) => controller.updateIngredient(entry.key, quantity2: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2D07),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Unit', style: GoogleFonts.rubik(color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text('g/ml', style: GoogleFonts.rubik(color: const Color(0xFF868686), fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    // Placeholder for alignment with delete button above
                    const SizedBox(width: 22),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: controller.addIngredient,
          child: Container(
            height: 40,
            width: 151.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1C2D07),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add ingredient',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Nutritional Values for 1 serving'),
        const SizedBox(height: 8),
        ...controller.nutritionalValues.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: entry.value.name.isEmpty ? 'e.g. Calories' : entry.value.name,
                      hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                      ),
                    ),
                    onChanged: (v) => controller.updateNutritionalValue(entry.key, name: v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g. 650',
                      hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
                      ),
                    ),
                    onChanged: (v) => controller.updateNutritionalValue(entry.key, quantity: v),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2D07),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Unit', style: GoogleFonts.rubik(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text('kcal', style: GoogleFonts.rubik(color: const Color(0xFF868686), fontSize: 12)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.removeNutritionalValue(entry.key),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFA63005), size: 22),
                ),
              ],
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: controller.addNutritionalValue,
          child: Container(
            height: 40,
            width: 151.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1C2D07),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Nutritional Value',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergens() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Allergens'),
        const SizedBox(height: 8),
        TextField(
          maxLines: 2,
          onChanged: (v) => controller.allergens = v,
          decoration: InputDecoration(
            hintText: 'Enter allergens (comma separated)',
            hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Suggested: gluten, dairy, egg, peanut, soy, fish, shellfish, nuts',
          style: GoogleFonts.rubik(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Tags (Maximum 10)'),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => controller.tagsInput = v,
          decoration: InputDecoration(
            hintText: 'Add keywords (comma separated)',
            hintStyle: GoogleFonts.rubik(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC7C7C7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF2D5016), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Suggested: Meal type, Flavor Profile, Cuisine, Dietary, Occasion, Preparation',
          style: GoogleFonts.rubik(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}