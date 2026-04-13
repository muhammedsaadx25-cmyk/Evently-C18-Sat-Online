import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/core/routes_manager/routes_manager.dart';
import 'package:evently_sat_online/features/home/tabs/favourite_tab/favourite_tab.dart';
import 'package:evently_sat_online/features/home/tabs/home_tab/home_tab.dart';
import 'package:evently_sat_online/features/home/tabs/profile/profile_tab.dart';
import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppLocalizations appLocalizations;

  List<Widget> tabs = [HomeTab(), FavouriteTab(), ProfileTab()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(


        onPressed: (){
          Navigator.pushNamed(context, RoutesManager.createEvent);
        }, child: Icon(Icons.add, ),),
      body: tabs[currentIndex],
      bottomNavigationBar:_buildBottomNavBar(),
    );
  }


  BottomNavigationBar  _buildBottomNavBar(){
    return BottomNavigationBar(


        currentIndex: currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(currentIndex == 0 ? Icons.home_filled : Icons.home_outlined), label: appLocalizations.home),
          BottomNavigationBarItem(icon: Icon(currentIndex == 1 ? Icons.favorite : Icons.favorite_border), label: appLocalizations.favourite),
          BottomNavigationBarItem(icon: Icon(currentIndex == 2 ? Icons.person : Icons.person_2_outlined), label: appLocalizations.profile),
        ]);
  }

  void _onTap(int newIndex){
    setState(() {
      currentIndex = newIndex;
    });
  }
}
