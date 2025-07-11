import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../partials/base_app_bar.dart';
import '../../core/constants/admob_banner_widget.dart';

class DeleteConfirmationScreen extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String? confirmText;
  final String? cancelText;

  const DeleteConfirmationScreen({
    Key? key,
    this.title,
    this.description,
    required this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: BaseAppBar(
        title: 'delete_confirm.title'.tr(),
        showLogo: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: 'delete_confirm.icon_warning'.tr(),
              child: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 64),
            ),
            const SizedBox(height: 24),
            Text(
              title ?? 'delete_confirm.title'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description ?? 'delete_confirm.description'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onCancel != null ? onCancel!() : Navigator.of(context).pop(false),
                    child: Text(cancelText ?? 'form.cancel'.tr()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (onConfirm != null) {
                        onConfirm();
                      } else {
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Text(confirmText ?? 'delete_confirm.confirm'.tr()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AdmobBannerWidget(),
          ],
        ),
      ),
    );
  }
} 