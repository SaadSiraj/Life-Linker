import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/view/edit%20person/components/section_card.dart';
import 'package:provider/provider.dart';

class RegisteredFacesCard extends StatelessWidget {
  const RegisteredFacesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        final embeddings = provider.person.faceEmbeddingIds;

        return EditPersonSectionCard(
          title: 'Registered Faces  (${embeddings.length})',
          icon: Icons.face_retouching_natural,
          iconColor: AppColors.successDark,
          iconBg: AppColors.successLight,
          child: Column(
            children: embeddings.asMap().entries.map((entry) {
              final idx = entry.key;
              final embId = entry.value;
              return _FaceEmbeddingRow(
                index: idx,
                embeddingId: embId,
                isFirst: idx == 0,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _FaceEmbeddingRow extends StatelessWidget {
  final int index;
  final String embeddingId;
  final bool isFirst;

  const _FaceEmbeddingRow({
    required this.index,
    required this.embeddingId,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isFirst)
          const Divider(height: 1, color: AppColors.dividerLight),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: Row(
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.face_retouching_natural,
                  size: 20.h,
                  color: AppColors.successDark,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Face Sample ${index + 1}',
                      size: 13,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    AppText(
                      'ID: ${embeddingId.length > 10 ? '${embeddingId.substring(0, 10)}…' : embeddingId}',
                      size: 10,
                      color: AppColors.iconGrey,
                    ),
                  ],
                ),
              ),
              _DeleteEmbeddingButton(embeddingId: embeddingId),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeleteEmbeddingButton extends StatelessWidget {
  final String embeddingId;

  const _DeleteEmbeddingButton({required this.embeddingId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmDelete(context),
      child: Container(
        width: 32.h,
        height: 32.h,
        decoration: BoxDecoration(
          color: AppColors.alertLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: 16.h,
          color: AppColors.alert,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: AppText(
          'Remove Face Sample',
          size: 15,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        content: AppText(
          'This face sample will be removed from the recognition model.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(
              'Cancel',
              size: 13,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: AppText(
              'Remove',
              size: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    context.read<EditPersonProvider>().deleteFaceEmbedding(
          embeddingId: embeddingId,
          onSuccess: () {},
          onError: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AppText(
                    'Failed to remove face. Try again.',
                    size: 13,
                    color: Colors.white,
                  ),
                  backgroundColor: AppColors.alert,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        );
  }
}