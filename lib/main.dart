import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'layout/shop_layout/shop_layout.dart';
import 'modules/login/shop_login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/constants/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/themes.dart';

import 'layout/shop_layout/cubit/cubit.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async {
  // If main() method becomes future(async) will do this step
  // To make sure that future's statements execute before runApp() method
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  debugPrint('$onBoarding');
  Widget? widget;
  token = CacheHelper.getData(key: 'token');
  debugPrint('token=$token');

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(MyApp(
        onBoarding: onBoarding,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool? onBoarding;
  final Widget? startWidget;

  const MyApp({Key? key, this.onBoarding, this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // ShopCubit(). is an object from ShopCubit class
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop App',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
// themeMode: ThemeMode.system,
        home: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return Container(
                child: startWidget,
              );
            } else {
              return buildNoInternetWidget(context);
            }
          },
          child: showLoadingIndicator(),
        ),
      ),
    );
  }

  Widget buildNoInternetWidget(context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              Text(
                'Can\'t Connect... check the internet',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 20.0),
              Image.asset('assets/images/no_internet.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
