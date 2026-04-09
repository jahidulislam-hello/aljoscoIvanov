import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';

import '../../../core/appbar/custom_appbar.dart';



class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Privacy Policy'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionBody(
                    "1. Controller\n\n"
                        "The controller responsible for data processing in this App is:\n\n"
                        "freshBITE Ivanov\n"
                        "Zurlindenstrasse 303\n"
                        "8003 Zurich\n"
                        "Switzerland\n"
                        "E-Mail: info@freshbite.ch\n\n"

                        "2. Data Collected\n\n"
                        "When using the App, the following personal data may be collected and processed: \n\n"
                        "• Registration data (name, e-mail address, password) \n"
                        "• Subscription and payment information (via App Store / Google Play; payment data is processed exclusively there) \n"
                        "• Usage data within the App (e.g., created recipes, shopping lists, meal plans, saved preferences/filters)\n"
                        "• Notification tokens (for push notifications) \n"
                        "• Technical data (device type, operating system, log files, IP address)\n\n"

                        "3. Purpose of Data Processing\n\n"
                        "The data is used for the following purposes:\n\n"
                        "• Provision and functionality of the App \n"
                        "• Management of user accounts and subscriptions \n"
                        "• Synchronization of data (e.g., Family Accounts) \n"
                        "• Storage of personal preferences and filter settings \n"
                        "• Sending of push notifications, if voluntarily activated \n"
                        "• Improvement of the App and analysis of user behavior (in anonymized form) \n"
                        "• Communication with users (e.g., support requests, in-app notifications)\n\n"

                        "4. Disclosure of Data\n\n"
                        "• Payment processing is carried out exclusively via the respective App Stores (Apple / Google). freshbite has no access to payment details. \n"
                        "• Push notifications are delivered via external services (e.g., Apple Push Notification Service, Firebase Cloud Messaging). These receive only the technical data required for transmission (token). \n"
                        "• Personal data will only be shared with third parties if necessary for the performance of the contract or if required by law. \n"
                        "• No data will be shared with advertising networks or unauthorized third parties. \n\n"

                        "5. Data Storage and Security\n\n"
                        "• All personal data is protected in accordance with the legal requirements in Switzerland and the EU (GDPR). \n"
                        "• Data is stored only as long as necessary for the use of the App or to fulfill legal obligations. \n"
                        "• Appropriate technical and organizational measures are taken to protect data from loss, misuse, and unauthorized access. \n\n"

                        "6. Rights of Users\n\n"
                        "Users have the right at any time to: \n\n"
                        "• Request information about the data stored concerning them \n"
                        "• Request correction of inaccurate data\n"
                        "• Request deletion of data (“right to be forgotten”) \n"
                        "• Restrict or object to the processing of their data \n"
                        "• Restrict or object to the processing of their data \n"
                        "• Receive their data in a portable format (data portability) \n"
                        "Requests may be sent to info@freshbite.ch. \n\n"

                        "7. Deletion of Account\n\n"
                        "When a user account is deleted, all personal data will be permanently erased, unless legal retention obligations require otherwise.\n\n"

                        "8. Changes to the Privacy Policy\n\n"
                        "freshbite reserves the right to amend this Privacy Policy at any time. The current version available in the App shall apply. \n\n"

                        "9. Contact\n\n"
                        "For questions regarding data protection: \n\n"
                        "freshBITE Ivanov \n"
                        "Zurlindenstrasse 303 \n"
                        "8003 Zurich, Switzerland\n"
                        "E-Mail: info@freshbite.ch \n"
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