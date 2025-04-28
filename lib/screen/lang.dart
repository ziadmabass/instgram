import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Lang extends StatefulWidget {
  const Lang({super.key});

  @override
  State<Lang> createState() => _LangState();
}

class _LangState extends State<Lang> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ListTile(
            leading: const Icon(Icons.abc),
            title: Text('change_language'.tr()),
            trailing: Switch(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: isDarkMode, // or whatever boolean you use
              onChanged: (value) {
                if (context.locale == const Locale('en')) {
                  context.setLocale(const Locale('ar'));
                } else {
                  context.setLocale(const Locale('en'));
                }
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
            // IconButton(
            //   onPressed: () {
            //     if(context.locale == const Locale('en')){
            //       context.setLocale(const Locale('ar'));}else{
            //       context.setLocale(const Locale('en'));}
            //   },
            //   icon: const Icon(Icons.change_circle_rounded),
            // ),
          ),
        ],
      ),
    );
  }
}