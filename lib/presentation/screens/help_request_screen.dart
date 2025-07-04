import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/help_request_cubit.dart';
import '../widgets/help_request_card.dart';
import '../widgets/comment_widget.dart';
import '../themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';
import '../../injection_container.dart';
import '../blocs/comment_cubit.dart';

class HelpRequestScreen extends StatelessWidget {
  final int requestId;
  const HelpRequestScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HelpRequestCubit(sl())..getById(requestId)),
        BlocProvider(create: (_) => CommentCubit(sl())..getByHelpRequestId(requestId)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('help_requests.detail_title'.tr()),
        ),
        body: BlocBuilder<HelpRequestCubit, HelpRequestState>(
          builder: (context, state) {
            if (state is HelpRequestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HelpRequestError) {
              return Center(child: Text('help_requests.error'.tr() + '\n' + state.error));
            } else if (state is HelpRequestDetailLoaded && state.helpRequest != null) {
              final req = state.helpRequest!;
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final emergencyColor = _emergencyColor(req.emergencyLevel, context);
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                children: [
                  // Başlık ve aciliyet
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: colorScheme.surface,
                        backgroundImage: (req.imageUrl != null && req.imageUrl!.isNotEmpty)
                            ? NetworkImage(req.imageUrl!)
                            : null,
                        child: (req.imageUrl == null || req.imageUrl!.isEmpty)
                            ? Icon(Icons.volunteer_activism, color: emergencyColor, size: 36)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Chip(
                                  label: Text(req.emergencyLevel),
                                  backgroundColor: emergencyColor.withOpacity(0.13),
                                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                                    color: emergencyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  side: BorderSide(color: emergencyColor.withOpacity(0.45)),
                                  visualDensity: VisualDensity.compact,
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(req.status),
                                  backgroundColor: req.status.toLowerCase() == 'open'
                                      ? AppColors.petsoliveSuccess.withOpacity(0.13)
                                      : AppColors.bsGray300.withOpacity(0.18),
                                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                                    color: req.status.toLowerCase() == 'open'
                                        ? AppColors.petsoliveSuccess
                                        : AppColors.bsGray700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  side: BorderSide(
                                    color: (req.status.toLowerCase() == 'open'
                                        ? AppColors.petsoliveSuccess
                                        : AppColors.bsGray400).withOpacity(0.45),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              req.title,
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat('dd.MM.yyyy HH:mm').format(req.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Görsel
                  if (req.imageUrl != null && req.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        req.imageUrl!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (req.imageUrl != null && req.imageUrl!.isNotEmpty)
                    const SizedBox(height: 18),
                  // Açıklama
                  Text(
                    req.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  // Konum ve iletişim
                  Row(
                    children: [
                      Icon(Icons.location_on, color: colorScheme.primary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(req.location, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.person, color: colorScheme.secondary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(req.contactName ?? req.userName, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.phone, color: colorScheme.secondary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(req.contactPhone ?? '-', style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email, color: colorScheme.secondary.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(req.contactEmail ?? '-', style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  // Yorumlar başlığı
                  Text('help_requests.comments'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (commentState is CommentError) {
                        return Center(child: Text('help_requests.comments_failed'.tr() + ': ' + commentState.error));
                      } else if (commentState is CommentLoaded) {
                        if (commentState.comments.isEmpty) {
                          return Text('help_requests.no_comments'.tr());
                        }
                        return Column(
                          children: commentState.comments.map((c) => CommentWidget(
                            userName: c.userId.toString(),
                            date: DateFormat('dd.MM.yyyy HH:mm').format(c.createdAt),
                            comment: c.content,
                          )).toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 18),
                  // Yorum ekle alanı
                  Text('help_requests.add_comment'.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _CommentInput(),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _emergencyColor(String level, BuildContext context) {
    switch (level.toLowerCase()) {
      case 'high':
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveDanger.withOpacity(0.85)
            : AppColors.petsoliveDanger;
      case 'medium':
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveWarning.withOpacity(0.85)
            : AppColors.petsoliveWarning;
      case 'low':
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.petsoliveSuccess.withOpacity(0.85)
            : AppColors.petsoliveSuccess;
      default:
        return Theme.of(context).colorScheme.primary.withOpacity(0.7);
    }
  }
}

class _CommentInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'help_requests.write_comment'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            minLines: 1,
            maxLines: 3,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.send),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
} 