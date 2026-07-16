import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPostBottomSheet extends StatefulWidget {
  const ReportPostBottomSheet({super.key});

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  String? selectedReason;

  final List<String> reasons = [
    "Spam",
    "Harassment or Bullying",
    "Hate Speech",
    "Violence",
    "Nudity or Sexual Content",
    "False Information",
    "Copyright Violation",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Report Post",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Why are you reporting this post?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              ...reasons.map(
                (reason) => RadioListTile<String>(
                  value: reason,
                  groupValue: selectedReason,
                  activeColor: Colors.orange,
                  title: Text(
                    reason,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: selectedReason == null
                      ? null
                      : () {

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Report submitted successfully.",
                              ),
                            ),
                          );
                        },
                  child: Text(
                    "Submit Report",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

            ],
          ),
        ),
      ),
    );
  }
}