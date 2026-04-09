import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';

import '../../../core/appbar/custom_appbar.dart';



class FrequentlyAskQuestion extends StatelessWidget {
  const FrequentlyAskQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Frequently Asked Questions'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionBody(
                    "1. What is the freshbite App?\n\n"
                        "A cooking and nutrition app designed to make cooking easier for people who want to lose weight. The app offers recipes with video instructions, the option to enter your own recipes, kitchen skills videos, a meal planner, and practical tools for creating shopping lists. The freshbite App is a conscious alternative to traditional calorie trackers, which often do not lead to sustainable results, and to typical cooking apps whose recipes are often unsuitable for weight loss.  \n\n"

                        "2. What account models are available?\n\n"
                        "• Free: Basic functions \n• Premium: Full access for one person\n• Family: Full access with sharing & synchronization\n• VIP: By invitation only from freshbite \n\n"

                        "3. What kind of recipes are included in the freshbite App? \n"
                        "The app mainly contains plant-based and mostly whole-food recipes. This type of diet has been shown to achieve very good results for weight loss – whether you call it plant-based, vegetarian, or Mediterranean. At freshbite, we also believe that this is where the greatest need for guidance exists. For most people, it’s easier to replace tofu with chicken breast in a recipe, or a cashew cream sauce with dairy cream, than the other way around. \n\n"

                        "4. Can I upload my own recipes?\n"
                        "Yes, you can add your own recipes including photos or links. Please only upload content that does not infringe on third-party rights. Your own recipes are saved under “Favorites” and are only visible to you. They can be used in the meal planner and for shopping lists just like all other recipes. Please note: Only the information you provide will be considered. For example, if you leave the nutritional information empty, it will not be included in the meal planner. \n\n"

                        "5. How does the meal planner work?\n"
                        "The meal planner has two views that distinguish between eating and cooking, but are linked: \n\n"
                        "• In Meal Plan, you see what you plan to eat and when. Here you can add recipes. This also sets when you intend to cook them.  \n"
                        "• In Prep, you see which recipes are scheduled to be cooked on which days. \n\n"
                        "This separation allows you to also use the planner for batch cooking. You can save and reuse meal plans based on your recipes. Saved plans can also be printed. In the Family Account, the planner can be shared and synchronized. \n\n"

                        "6. How reliable is the nutritional information in the meal planner?\n"
                        "In the “Meal Plan” view you will find the “Nutritional Values” section at the bottom. These always refer to the selected day. The nutritional values of all planned recipes are summed up for one portion each. The data is based, wherever possible, on the official Swiss Nutrient Database. \n\n"

                        "7. How do I best use the meal planner to lose weight?\n"
                        "The meal planner gives you two ways to orient yourself: \n\n"
                        "\t 1.Classical via nutritional values: You can see how many calories your planned meals contain. However, you must know your individual energy needs yourself – the app does not provide this information.  \n\n"
                        "\t 2. The freshbite meal building blocks (recommended): There are five components:\n\n"
                        "• Base (starchy foods)  \n• Vegetables \n• Protein source \n• Connection (e.g., sauce) \n• Topping (e.g., seeds or nuts)\n\n"
                        "\t  While “Connection” and “Topping” add flavor, the other three ensure balance. In the planner you can see which components are already covered. This helps you build meals and check for balance.\n\n"
                        "Since all recipes in freshbite are suitable for weight loss, you don’t need to count calories. Instead, focus on covering as many of the five building blocks as possible with each meal. \n\n"

                        "8. Why am I not losing weight with the freshbite App? \n"
                        "Weight loss depends on many factors. In addition to diet composition, eating behavior (e.g., eating speed, hunger and satiety signals) and lifestyle factors such as activity, medication, smoking, alcohol, sleep, and stress are important. Hormonal or genetic factors can also play a role. If you cannot lose weight despite great effort and this causes you distress, a consultation with a qualified nutrition professional is recommended to identify causes and solutions. \n\n"

                        "9. How do shopping lists work?\n"
                        "You can create shopping lists in three ways: \n\n"
                        "\t 1. Directly from a recipe using the button inside the recipe. \n"
                        "\t 2. Automatically from the recipes you’ve planned in the meal planner or Prep list.  \n"
                        "\t 3. Manually in the “Shopping” menu, independent of recipes or the planner.\n\n"
                        "All lists can be edited and assigned to a specific day. In the Family Account, lists can be shared and synchronized.\n"

                        "10. Can professionals recommend the app to their clients?\n"
                        "Yes. The app was also designed for professionals. freshbite deliberately does not promote its own nutrition counseling or the FRESH Method within the app. This ensures professionals can use the app with clients without seeing it as competition. The app is an ideal complement to nutrition counseling, as individual factors such as eating behavior can then be addressed together. \n\n"

                        "11. Are there notifications?\n"
                        "Yes. If you wish, the app will remind you via push notification of your Prep lists or shopping lists. This feature can be enabled or disabled at any time in your device settings. \n\n"

                        "12. How can I cancel my subscription? \n"
                        "Through the App Store or Google Play Store. Cancellation is possible at any time and takes effect at the end of the current billing period. \n\n"

                        "13. How is my data protected?\n"
                        "Your data is only processed for the use of the app and not shared with unauthorized third parties. Details are explained in the Privacy Policy. \n\n"

                        "14. What happens if I delete my account?\n"
                        "All personal data will be permanently erased, unless legal retention requirements apply. \n\n"

                        "15. Where can I get support?\n\n"
                        "You can contact us anytime by e-mail: info@freshbite.ch\n"
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class SectionBody extends StatelessWidget {
  final String text;

  const SectionBody(this.text, {super.key});

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 29, right: 29),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}