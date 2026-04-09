import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';

import '../../../core/appbar/custom_appbar.dart';



class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Terms and Conditions'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionBody(
                    "1. Scope of Application\n\n"
                        "These Terms & Conditions (“T&C”) govern the use of the freshbite App (“App”) by registered users (“Users”).\n"
                        "The App is operated by:\n\n"
                        "freshBITE Ivanov, Zurlindenstrasse 303, 8003 Zurich, Switzerland\n"
                        "(hereinafter referred to as “freshbite”).\n\n"
                        "By registering and using the App, Users accept these T&C.\n\n"

                        "2. Services of the App\n\n"
                        "The App in particular provides the following functions:\n"
                        "• Access to cooking recipes, cooking videos, and a how-to video library\n"
                        "• Meal planner with portion adjustment, daily overview, and nutritional information\n"
                        "• Creation of automatic or individual shopping lists\n"
                        "• Storage of personal preferences (e.g., filters for recipe searches)\n"
                        "• Push notifications (optional), e.g., reminders of meal planner entries or shopping lists \n"
                        "• Possibility to create and upload own recipes (including photos and links) \n"
                        "• Data synchronization (for Family Accounts) \n\n"
                        "freshbite reserves the right to expand, restrict, or modify features at any time.\n\n"

                        "3. Account Models\n\n"
                        "• Free Account: Limited functionality\n"
                        "• Premium Account: Full access for one person\n"
                        "• Family Account: Full access for one person plus the option to invite additional users and synchronize data \n"
                        "• VIP Account:  Free full access, granted only by freshbite\n\n"
                        "Subscriptions are subject to charges unless they are Free or VIP Accounts. Prices and payment terms are based on the information provided in the App Store (Apple/Google).\n\n"

                        "4. Registration and User Obligations\n\n"
                        "• During registration, Users must provide complete and accurate information. \n"
                        "• Login credentials must be kept confidential and not shared with third parties. \n"
                        "• Users who upload their own recipes, photos, or links confirm that they hold the necessary rights and do not infringe on copyrights or other rights of third parties.\n"
                        "• It is prohibited to upload illegal, offensive, discriminatory, or harmful content to the App. \n"
                        "• Users may enable or disable push notifications at any time in their device settings.\n\n"
                        "freshbite reserves the right to remove content or suspend accounts in case of violations. \n\n"

                        "5. Disclaimer of Liability\n\n"
                        "• The contents of the App (recipes, nutritional information, videos, etc.) are provided for general informational and educational purposes only. They do not constitute medical or nutritional advice and are not a substitute for consulting a physician or qualifiedprofessional.\n"
                        "• Despite careful preparation, freshbite assumes no liability for the accuracy, completeness, or timeliness of the content. \n"
                        "• Use of the App is at the User’s own risk. freshbite shall not be liable for damages resulting from improper use, intolerances, allergies, or external links. \n\n"


                        "6. Term and Termination\n\n"
                        "• All subscriptions (Premium, Family) automatically renew on a monthly basis unless cancelled in time via the App Store (Apple/Google). \n"
                        "• Subscriptions can be cancelled at any time in the account settings of the respective App Store and will end at the close of the current billing period. \n"
                        "• Users are not entitled to a prorated refund of fees already paid. \n\n"

                        "7. Intellectual Property\n\n"
                        "All contents of the App (texts, images, recipes, videos, graphics, logos) are protected by copyright and are the property of freshBITE Ivanov, unless otherwise indicated.Without express written consent from freshBITE Ivanov, contents may not be copied, reproduced, modified, or distributed.\n"
                        "The names freshbite® and FRESH Methode® are registered trademarks and legally protected. \n\n"

                        "8. Data Protection\n\n"
                        "The protection of personal data is important to freshbite. Details are set out in the Privacy Policy, which forms an integral part of these T&C. \n\n"

                        "9. Final Provisions\n\n"
                        "• Swiss law shall apply exclusively, excluding conflict-of-law rules. \n"
                        "• The place of jurisdiction for all disputes arising from or in connection with the use of the App is Zurich, Switzerland, unless mandatory law provides otherwise. \n"
                        "• Should individual provisions of these T&C be invalid, the validity of the remainingprovisions shall not be affected.\n"
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