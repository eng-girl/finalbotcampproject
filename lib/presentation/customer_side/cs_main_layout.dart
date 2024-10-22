

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/bottom_nav_bar_cubit.dart';
import '../../bloc/state/bottom_nav_bar_state.dart';
import 'navigation_screens/cs_home_screen.dart';
import 'navigation_screens/cs_profile_screen.dart';
import 'navigation_screens/cs_stores_screen.dart';

class CSMainLayout extends StatefulWidget {
  const CSMainLayout({super.key});

  @override
  State<CSMainLayout> createState() => _CSMainLayoutState();
}

class _CSMainLayoutState extends State<CSMainLayout> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(

        body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
            builder: (context, state) {
              if (state.navbarItem == NavbarItem.home) {
                return const HomeScreen();
              } else if (state.navbarItem == NavbarItem.stores) {
                return const StoresScreen();
              } else if (state.navbarItem == NavbarItem.profile) {
                return const ProfileScreen();
              }
              return Container();
            }),


        bottomNavigationBar: BlocBuilder<BottomNavBarCubit,BottomNavBarState>(
          builder: (context, state){
          return BottomNavigationBar(


            currentIndex: state.index,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            iconSize:  screenWidth * 0.07,
            selectedLabelStyle:  TextStyle(
              fontSize: screenWidth * 0.041,
            ),
            unselectedLabelStyle:  TextStyle(
              fontSize: screenWidth * 0.041,
            ),

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'حسابي',
                icon: Icon(Icons.person_rounded),
              ),
              BottomNavigationBarItem(
                label: 'الرئيسية',
                icon: Icon(Icons.home_rounded),
              ),
              BottomNavigationBarItem(

                label: 'المتاجر',
                icon: Icon(
                  Icons.store_rounded,
                ),
              ),




            ],
            onTap: (index) {
              if (index == 2) {
                BlocProvider.of<BottomNavBarCubit>(context)
                    .getNavBarItem(NavbarItem.stores);
              } else if (index == 1) {
                BlocProvider.of<BottomNavBarCubit>(context)
                    .getNavBarItem(NavbarItem.home);
              } else if (index == 0) {
                BlocProvider.of<BottomNavBarCubit>(context)
                    .getNavBarItem(NavbarItem.profile);
              }
            },
          );



          }
        )


      ),
    );
  }
}
