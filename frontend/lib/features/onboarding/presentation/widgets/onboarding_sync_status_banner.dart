import 'package:flutter/material.dart';
import 'package:frontend/core/constants/submission_status.dart';

class OnboardingSyncStatusBanner extends StatelessWidget {
  const OnboardingSyncStatusBanner({
    required this.status,
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final SubmissionStatus status;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (status == SubmissionStatus.idle) {
      return const SizedBox.shrink();
    }

    if (status == SubmissionStatus.submitting) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: LinearProgressIndicator(),
      );
    }

    if (status == SubmissionStatus.success) {
      return Card(
        color: Colors.green.shade50,
        child: const ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Synced successfully'),
          subtitle: Text('Profile and goal were saved to the server.'),
        ),
      );
    }

    return Card(
      color: Colors.red.shade50,
      child: ListTile(
        leading: const Icon(Icons.error_outline, color: Colors.red),
        title: const Text('Sync failed'),
        subtitle: Text(errorMessage ?? 'Something went wrong.'),
        trailing: TextButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ),
    );
  }
}
