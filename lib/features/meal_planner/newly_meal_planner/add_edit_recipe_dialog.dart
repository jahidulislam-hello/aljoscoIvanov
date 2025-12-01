import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/model.dart';


class AddEditRecipeDialog extends StatefulWidget {
  final NewMealModel initial;
  final bool isEditing;
  const AddEditRecipeDialog({Key? key, required this.initial, this.isEditing = false}) : super(key: key);

  @override
  State<AddEditRecipeDialog> createState() => _AddEditRecipeDialogState();
}

class _AddEditRecipeDialogState extends State<AddEditRecipeDialog> {
  late TextEditingController titleCtrl;
  late TextEditingController subtitleCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initial.title);
    subtitleCtrl = TextEditingController(text: widget.initial.subtitle);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    subtitleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.isEditing ? 'Edit Recipe' : 'Add Recipe', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Title')),
            SizedBox(height: 8.h),
            TextField(controller: subtitleCtrl, decoration: InputDecoration(labelText: 'Subtitle')),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    final updated = widget.initial.copyWith(title: titleCtrl.text.trim(), subtitle: subtitleCtrl.text.trim());
                    Navigator.pop(context, updated);
                  },
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
