import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBottomSheet extends StatelessWidget {
  final String recipeTitle;
  const MessageBottomSheet({Key? key, required this.recipeTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Messages — $recipeTitle', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            // dummy messages list
            SizedBox(
              height: 220.h,
              child: ListView(
                children: [
                  ListTile(leading: CircleAvatar(child: Text('O')), title: Text('Olivia'), subtitle: Text('This is dinner recipe please make it class day.')),
                  ListTile(leading: CircleAvatar(child: Text('U')), title: Text('User'), subtitle: Text('Ok, we will.')),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: 'Write a message'))),
                SizedBox(width: 8.w),
                ElevatedButton(onPressed: () {}, child: const Icon(Icons.send)),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
