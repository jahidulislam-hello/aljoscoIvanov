import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';

import '../../../core/appbar/custom_appbar.dart';



class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'About Freshbite'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionBody(
                  "1. What is FreshBite?\n"
                      "FreshBite is a platform that connects businesses with qualified, on-demand professionals for temporary or part-time work. Our app makes it easy for businesses to find professionals when they need extra help or to cover staff shortages.\n\n"
                      "2. How does FreshBite work for employers?\n"
                      "Employers can sign up, browse available professionals, and book them for specific time slots. Employers can also mark professionals as favorites to easily select from their preferred list for future bookings.\n\n"
                      "3. How does FreshBite work for service providers?\n"
                      "Service providers create a profile detailing their qualifications and availability. Once approved, they can offer their services during their available times. Service providers do not book jobs but make themselves available to be booked by employers.\n\n"
                      "4. How do payments work?\n"
                      "Payments are handled directly through the app. Employers are charged when a booking is confirmed, and funds are held in escrow until both parties confirm the completion of the service. The service provider will then receive their payment minus the platform fee.\n\n"
                      "5. What if there is a dispute between an employer and a service provider?\n"
                      "Shpitze offers a dispute resolution process in case any issues arise between an employer and a service provider. However, we encourage both parties to communicate and resolve issues directly when possible.\n\n"
                      "6. Is Shpitze responsible for verifying the qualifications of service providers?\n"
                      "Shpitze conducts a verification process to the extent possible, but ultimate responsibility for ensuring the qualifications and suitability of service providers lies with the employers. We encourage employers to perform their own due diligence before making a booking.\n\n"
                      "7. What industries does Shpitze serve?\n"
                      "Shpitze connects professionals with employers across various industries for temporary or part-time work. The platform is designed to be flexible and scalable, meeting the needs of multiple sectors.\n\n"
                      "8. How do I contact Shpitze for support?\n"
                      "For support, you can reach out to us via the 'Contact Us' section within the app or email us at contact@shpitze.com. Our team will respond as soon as possible.\n\n"
                      "9. What is the difference between Instant Booking and Request to Book?\n"
                      "Instant Booking allows you to secure a service provider immediately. Once you confirm the booking, it's automatically scheduled and confirmed without needing further approval from the provider.\n\n"
                      "Request to Book gives the service provider the option to accept or decline the booking. After submitting your request, the provider will review the details and confirm whether they can accommodate your booking. This method is ideal for non-urgent needs where more control over scheduling is preferred.",
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