import 'package:firstedu/core/error/app_exception.dart';
import 'package:firstedu/core/network/api_client.dart';
import 'package:firstedu/core/network/api_endpoint.dart';
import 'package:firstedu/utils/apptoster/errortoaster.dart';
import 'package:firstedu/view_models/communityprvider/communityprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Blockusersheet extends StatefulWidget {
  final String postId;
  const Blockusersheet({super.key, required this.postId});

  @override
  State<Blockusersheet> createState() => _BlockusersheetState();
}

class _BlockusersheetState extends State<Blockusersheet> {
  String? selectedReason;
  bool _isSubmitting = false;

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

  Future<void> _submitReport() async {
    if (selectedReason == null) return;

    setState(() => _isSubmitting = true);

    try {
      final apiClient = ApiClient();

      final response = await apiClient.post(
        '${ApiEndpoint.userForums}/${widget.postId}/report',
        data: {
          'reason': selectedReason,
        },
      );

      if (!context.mounted) return;

      Navigator.pop(context);

      AppToast.success(
        context,
        title: "Report Submitted",
        message: "Thank you for helping keep our community safe.",
      );

      context.read<CommunityProvider>().fetchPosts(context);
    } on AppException catch (e) {
      if (!context.mounted) return;
      AppToast.error(
        context,
        title: "Failed to Submit Report",
        message: e.message,
      );
    } catch (e) {
      if (!context.mounted) return;
      AppToast.error(
        context,
        title: "Error",
        message: "Something went wrong. Please try again.",
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: cap the sheet to a percentage of screen height so it can never
    // demand more room than the screen has — the previous version had a
    // MainAxisSize.min Column with no scroll view and no height limit, so
    // 8 RadioListTiles + title + subtitle + button could exceed the screen
    // (especially on smaller phones/landscape) and overflow with no way out.
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
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
              "Block Content",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Why are you Blocking this content?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ FIX: the reasons list is the part that grows unbounded —
            // Flexible + SingleChildScrollView lets it shrink and scroll
            // instead of pushing the total Column past screen height.
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: reasons
                      .map(
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
                      )
                      .toList(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (_isSubmitting || selectedReason == null)
                      ? null
                      : _submitReport,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Submit ",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}