import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_controller/create_recipes_controller.dart';
import 'package:freshbite/features/recepies/create_recipes/text_editor/rich_text_editor.dart';



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
    return Scaffold(
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
                        child: CustomTextButton(
                          text: 'SAVE RECIPE',
                          onTap: () {},
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
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
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                      style: TextStyle(
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
    final components = ['Vegetables', 'Connector', 'Topping', 'Protein', 'Breakfast'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: components.map((comp) {
        final isSelected = controller.selectedComponents.contains(comp);
        return GestureDetector(
          onTap: () => controller.toggleComponent(comp),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
              border: Border.all(
                color: isSelected ? const Color(0xFF2D5016) : const Color(0xFFE0E0E0),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: isSelected ? const Color(0xFF2D5016) : Colors.grey,
                  ),
                ),
                Text(
                  comp,
                  style: TextStyle(
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
                        color: isSelected ? const Color(0xFF2D5016) : const Color(0xFFE0E0E0),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      mode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
              const Text('Total Time', style: TextStyle(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => controller.totalTime = v,
                decoration: InputDecoration(
                  hintText: 'e.g. 40 min',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
              const Text('Prep Time', style: TextStyle(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => controller.prepTime = v,
                decoration: InputDecoration(
                  hintText: 'e.g. 15 min',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
              const Text('Cook Time', style: TextStyle(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => controller.cookTime = v,
                decoration: InputDecoration(
                  hintText: 'e.g. 45 min',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF1C2D07), width: 1.5),
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
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Add another step',
                  style: TextStyle(
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

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Ingredient Items'),
        const SizedBox(height: 8),
        ...controller.ingredients.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'e.g. Spaghetti',
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                    color: const Color(0xFF2D5016),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Unit', style: TextStyle(color: Colors.white, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('tsp', style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.removeIngredient(entry.key),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
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
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Add ingredient',
                  style: TextStyle(
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
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                    color: const Color(0xFF2D5016),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Unit', style: TextStyle(color: Colors.white, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('kcal', style: TextStyle(color: Colors.orange, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.removeNutritionalValue(entry.key),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
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
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Add Nutritional Value',
                  style: TextStyle(
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
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}