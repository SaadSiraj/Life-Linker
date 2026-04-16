import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_button.dart' show CustomButton;

void showConfirmationDialoge({
  String? title,
  String? subTitle,
  required String confirmLable,
  required BuildContext context,
  required Future<void> Function() onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return _ConfirmationDialog(
        title: title,
        subTitle: subTitle,
        onConfirm: onConfirm,
        confirmLabel: confirmLable,
      );
    },
  );
}

class _ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String confirmLabel;
  final Future<void> Function() onConfirm;

  const _ConfirmationDialog({
    this.title,
    this.subTitle,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  State<_ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<_ConfirmationDialog> {
  bool isLoading = false;

  Future<void> _handleConfirm() async {
    setState(() => isLoading = true);
    try {
      await widget.onConfirm();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'Delete This Item?'),
      content: Text(widget.subTitle ?? 'Are you sure you want to delete this?'),
      actions: [
        if (!isLoading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
          ),
        CustomButton(
          text: widget.confirmLabel,
          onTap: _handleConfirm,
          buttonColor: Colors.red,

          width: 100,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
