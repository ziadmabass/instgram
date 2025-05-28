import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/screen/change_theme_screen.dart';
import 'package:testfirebase/screen/lang.dart';
import 'package:testfirebase/screen/saved_posts.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SavedPostsScreen()),
        ),
            leading: const Icon(Icons.bookmark_outline_rounded),
            title: Text('saved_posts'.tr()),
          ),
          const SizedBox(height: 20,),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Lang()));
            },
            leading: const Icon(Icons.abc),
            title: Text('lang'.tr()),
          ),
          const SizedBox(height: 20,),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChangeThemeScreen()));
            },
            leading: const Icon(Icons.color_lens),
            title: Text('theme'.tr()),
          ),
        ],
      ),
    );
  }
}