import 'package:evently_sat_online/core/resources/assets_manager.dart';
import 'package:evently_sat_online/core/routes_manager/routes_manager.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:evently_sat_online/model/user_model.dart';
import 'package:evently_sat_online/providers/lang_provider.dart';
import 'package:evently_sat_online/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    var themeProvider = Provider.of<ThemeProvider>(context);
    var langProvider = Provider.of<LangProvider>(context);
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(ImageAssets.profileImage, height: 104.h),
          Text(
           UserModel.currentUser!.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
           UserModel.currentUser!.email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 32.h),
          Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1.w,
              ),
              color: Theme.of(context).primaryColor,
            ),
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  appLocalizations.dark_mode,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Spacer(),
                Switch(
                  value: themeProvider.isDark,
                  onChanged: (isDarkEnabled) {

                    themeProvider.updateAppTheme(
                      isDarkEnabled ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Text(
                 langProvider.isEnglish? "English": "Arabic",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Spacer(),
                DropdownButton(
                  padding: EdgeInsets.zero,
                  underline: Container(),
                  items: ["English", "Arabic"]
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
                  onChanged: (newLang) {

                    langProvider.updateAppLang(newLang == "English" ? "en" : "ar");
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          InkWell(
            onTap: _logout,
            child: Container(
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1.w,
                ),
                color: Theme.of(context).primaryColor,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    appLocalizations.logout,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Spacer(),
                  Icon(Icons.logout, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout()async{

   await  FirebaseService.logout();

   Navigator.pushReplacementNamed(context, RoutesManager.login);
  }
}
