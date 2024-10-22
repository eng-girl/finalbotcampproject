
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../bloc/cubit/auth_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/listTileForProfile.dart';
import '../../../widgets/themeButton.dart';
import '../customer_orderes_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String? profileImageUrl;

  const ProfileScreen({Key? key, this.profileImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screemHeight = MediaQuery.of(context).size.height;
    final user = BlocProvider.of<AuthCubit>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Text(
            'أهلاً، ${user?.username}',
            style: TextStyle(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screemHeight *0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical:screemHeight * 0.015,
                      horizontal: screenWidth * 0.08,
                    ),
                    child: CircleAvatar(
                      radius:
                          screenWidth * 0.12, // You can adjust the size here
                      backgroundImage:
                          profileImageUrl != null && profileImageUrl!.isNotEmpty
                              ? NetworkImage(
                                  profileImageUrl!) // Load image from URL
                              : null, // No child if image is available
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.cardsBackgroundDark
                          : AppColors.lightGrey, // Placeholder if no image
                      child: profileImageUrl == null || profileImageUrl!.isEmpty
                          ?  Icon(Icons.person,
                              size: screenWidth *0.12, color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkText
                            : AppColors.darkText,) // Default icon
                          : null, // Background color for placeholder
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${user?.username}' ,style: TextStyle(
                        fontSize: screenWidth * 0.05,
                      ),),
                      Text('${user?.email}' ,style: const TextStyle(
                        color: AppColors.darkGrey
                      ),)
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screemHeight*0.01),
              child: ListTileForProfile(
                ontap: () {},
                title: 'الوضع الليلي',
                trailing: const ThemeSwitchButton(),
                leadingIcon: const Icon(Iconsax.moon ,color: AppColors.primary,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTileForProfile(
                ontap: () {},
                title: 'تعديل الحساب',
                trailing: const Text(''),
                leadingIcon: const Icon(Iconsax.profile_circle,color: AppColors.primary,),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screemHeight*0.01),
              child: ListTileForProfile(
                ontap: () {},
                title: 'عنواني',
                trailing: const Text(''),
                leadingIcon: const Icon(Icons.location_on_outlined,color: AppColors.primary,),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screemHeight*0.01),
              child: ListTileForProfile(
                ontap: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerOrders(
                    ),
                  ),
                );},
                title: 'طلباتي',

                 trailing: const Text(''),
                leadingIcon: const Icon(Iconsax.box,color: AppColors.primary,),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screemHeight*0.01),
              child: ListTileForProfile(
                ontap: () {
                  context.read<AuthCubit>().logout();
                },
                title: 'تسجيل خروج', trailing: const Text(''),
                leadingIcon: const Icon(Icons.logout,color: AppColors.red,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
