import 'package:flutter/material.dart';

class Tearmsandcondition extends StatelessWidget {
  const Tearmsandcondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trvlus")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeading("✈️ Trvlus – Terms & Conditions"),
            _buildSubHeading("1. General"),
            _buildText(
                "• These Terms & Conditions govern your use of our flight booking services.\n• By booking through our platform, you agree to be bound by these terms."),
            _buildSubHeading("2. Booking Policy"),
            _buildText(
                "• All bookings are subject to availability and confirmation by the airline.\n• Prices may change at the time of booking due to airline fare updates.\n• You are responsible for entering accurate passenger details (name, age, ID proof, etc.)."),
            _buildSubHeading("3. Payment"),
            _buildText(
                "• Full payment must be made at the time of booking.\n• We accept credit/debit cards, UPI, wallets, and net banking.\n• Any payment failure will result in unsuccessful booking."),
            _buildSubHeading("4. Cancellations & Refunds"),
            _buildText(
                "• Cancellation/refund rules are as per the airline’s policy.\n• Our service fees are non-refundable.\n• Refunds, if applicable, will be processed within 7–15 business days."),
            _buildSubHeading("5. Rescheduling"),
            _buildText(
                "• Date/route changes are subject to airline rules and additional charges."),
            _buildSubHeading("6. Check-in & Boarding"),
            _buildText(
                "• Passengers must carry valid government-issued ID and booking confirmation.\n• Arrive at the airport at least 2 hours before departure for domestic flights and 3 hours for international flights."),
            _buildSubHeading("7. Limitation of Liability"),
            _buildText(
                "• We act as an intermediary between you and the airline.\n• We are not responsible for delays, cancellations, baggage loss, or any airline service issues."),
            _buildSubHeading("8. Governing Law"),
            _buildText("• These terms are governed by the laws of India."),
            const SizedBox(height: 20),
            _buildHeading("🔒 Privacy Policy"),
            _buildSubHeading("1. Information We Collect"),
            _buildText(
                "• Personal details: name, phone number, email, ID proof.\n• Payment details (securely processed via third-party gateways).\n• Travel preferences and booking history."),
            _buildSubHeading("2. How We Use Your Information"),
            _buildText(
                "• To process bookings and payments.\n• To send booking confirmations, updates, and alerts.\n• To provide customer support.\n• To improve services and user experience."),
            _buildSubHeading("3. Data Sharing"),
            _buildText(
                "• We share information with airlines, payment gateways, and service providers only as necessary.\n• We do not sell or rent your personal information."),
            _buildSubHeading("4. Security"),
            _buildText(
                "• We use encryption and secure servers to protect user data.\n• However, no system is 100% secure; users accept associated risks."),
            _buildSubHeading("5. Cookies & Tracking"),
            _buildText(
                "• We use cookies to personalize user experience and improve services."),
            _buildSubHeading("6. User Rights"),
            _buildText(
                "• You may request correction or deletion of your personal data.\n• You can unsubscribe from promotional emails anytime."),
            _buildSubHeading("7. Changes to Policy"),
            _buildText(
                "• We may update this Privacy Policy from time to time.\n• Continued use of our services means acceptance of the updated policy."),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSubHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style:
            const TextStyle(fontSize: 14, height: 1.5, color: Colors.black54),
      ),
    );
  }
}
