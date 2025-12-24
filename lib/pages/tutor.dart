import 'package:flutter/material.dart';
import '../widget/tutor_card.dart';
import '../l10n/l10n.dart'; // <-- S.dart

class TutorPage extends StatelessWidget {
  const TutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TutorItem(
          title: S.of(context)!.tutorBindTitle,
          description: S.of(context)!.tutorBindDesc,
          markdownContent: S.of(context)!.tutorBindContent,
          type: TutorType.markdown,
        ),
        TutorItem(
          title: S.of(context)!.tutorListTitle,
          description: S.of(context)!.tutorListDesc,
          markdownContent: S.of(context)!.tutorListContent,
          type: TutorType.markdown,
        ),
        TutorItem(
          title: S.of(context)!.tutorDeviceTitle,
          description: S.of(context)!.tutorDeviceDesc,
          markdownContent: S.of(context)!.tutorDeviceContent,
          type: TutorType.markdown,
        ),
        TutorItem(
          title: S.of(context)!.tutorHistoryTitle,
          description: S.of(context)!.tutorHistoryDesc,
          markdownContent: S.of(context)!.tutorHistoryContent,
          type: TutorType.markdown,
        ),
      ],
    );
  }
}
