import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './theme/app_themes.dart';

import './screens/booklist_screen.dart';
import './screens/add_book_screen.dart';
import './screens/add_club_screen.dart';
import './screens/chat_screen.dart';
import './screens/club_screen.dart';
import './screens/club_overview_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/user_details_screen.dart';
import './screens/add_member_screen.dart';

import './providers/book_archive.dart';
import './providers/club_list_provider.dart';
import './providers/auth.dart';
import './providers/member.dart';
import './providers/user_details.dart';
import './providers/club_members.dart';

import './widgets/club_list.dart';

class ScreenSize {
  static Size size;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BookClub());
}

class BookClub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ClubListProvider>(
          update: (ctx, auth, existingClubs) => ClubListProvider(auth.token,
              auth.userId, existingClubs == null ? [] : existingClubs.clubList),
          create: null,
        ),
        ChangeNotifierProxyProvider<Auth, UserDetails>(
          update: (ctx, auth, existingUser) => UserDetails(
              auth.token,
              auth.userId,
              existingUser == null
                  ? Member(id: auth.userId)
                  : existingUser.userDetails),
          create: null,
        ),
        ChangeNotifierProvider.value(
          value: ClubList(),
        ),
        ChangeNotifierProxyProvider<Auth, BookArchive>(
          update: (ctx, auth, existingBooks) => BookArchive(auth.token,
              auth.userId, existingBooks == null ? [] : existingBooks.bookList),
          create: null,
        ),
        ChangeNotifierProxyProvider<Auth, ClubMembers>(
          update: (ctx, auth, existingMembers) => ClubMembers(
              auth.token,
              auth.userId,
              existingMembers == null ? [] : existingMembers.memberList),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Book Club',
          theme: AppTheme.lightTheme,
          // theme: ThemeData.light().copyWith(primaryColor: green),
          // darkTheme: ThemeData.dark().copyWith(primaryColor: brown),
          // NOTE: Optional - use themeMode to specify the startup theme
          themeMode: ThemeMode.system,
          // pageTransitionsTheme: PageTransitionsTheme(builders: {
          //   TargetPlatform.android: CustomPageTransitionBuilder(),
          //   TargetPlatform.iOS: CustomPageTransitionBuilder(),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return OverviewScreen(userSnapshot);
                }
                return AuthScreen();
              }),

          // auth.isAuth
          //     ? OverviewScreen(auth.userId)
          //     : FutureBuilder(
          //         future: auth.tryAutoLogin(),
          //         builder: (ctx, authResultSnapShot) =>
          //             authResultSnapShot.connectionState ==
          //                     ConnectionState.waiting
          //                 ? SplashScreen()
          //                 : AuthScreen(),

          routes: <String, WidgetBuilder>{
            BookListScreen.routeName: (ctx) => BookListScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            AddBookScreen.routeName: (ctx) => AddBookScreen(),
            AddClubScreen.routeName: (ctx) => AddClubScreen(),
            AddMemberScreen.routeName: (ctx) => AddMemberScreen(),
            ClubScreen.routeName: (ctx) => ClubScreen(),
            ClubOverviewScreen.routeName: (ctx) =>
                ClubOverviewScreen(auth.userId),
            UserDetailsScreen.routeName: (ctx) => UserDetailsScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
          },
        ),
      ),
    );
  }
}

class OverviewScreen extends StatelessWidget {
  final userDetails;

  OverviewScreen(this.userDetails);

  @override
  Widget build(BuildContext context) {
    ScreenSize.size = MediaQuery.of(context).size;
    return ClubOverviewScreen(userDetails);
  }
}
