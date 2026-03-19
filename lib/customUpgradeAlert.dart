// ignore_for_file: file_names

import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class CustomUpgradeAlert extends UpgradeAlert {
  CustomUpgradeAlert({
    Key? key,
    Upgrader? upgrader,
    Widget? child,
  }) : super(
          key: key,
          upgrader: upgrader,
          child: child,
          barrierDismissible: false,
          showIgnore: false,
          showLater: false,
          showReleaseNotes: false,
          showPrompt: false,
        );

  @override
  UpgradeAlertState createState() => CustomUpgradeAlertState();
}

class CustomUpgradeAlertState extends UpgradeAlertState {
  @override
  void showTheDialog({
    Key? key,
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool barrierDismissible,
    required UpgraderMessages messages,
  }) {
    if (!context.mounted) return;

    widget.upgrader.saveLastAlerted();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/image/Logo108.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title ?? 'Update Available',
                          style: bodyTextMiniMedium(
                            null,
                            AppColors.fontDark,
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    message,
                    style: bodyTextMinNormal(
                      null,
                      AppColors.fontGrey,
                      FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryCustom,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: () => onUserUpdated(dialogContext, false),
                        child: Text(
                          messages.message(UpgraderMessage.buttonTitleUpdate) ??
                              'Update Now',
                          style: buttonTextMinNormal(
                            null,
                            AppColors.primaryCustom,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
