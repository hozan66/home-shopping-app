import '../../modules/login/shop_login_screen.dart';
import '../components/components.dart';
import '../network/local/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

String? token;
