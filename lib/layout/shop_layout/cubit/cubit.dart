import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states.dart';
import '../../../models/home_model.dart';
import '../../../modules/favorites/favorites_screen.dart';
import '../../../modules/products/products_screen.dart';
import '../../../modules/settings/settings_screen.dart';
import '../../../shared/network/end_points.dart';

import '../../../models/categories_model.dart';
import '../../../models/change_favorites_model.dart';
import '../../../models/favorites_model.dart';
import '../../../models/shop_login_model.dart';
import '../../../modules/categories/categories_screen.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(url: homeEndpoint, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // debugPrint(homeModel?.data.banners[0].image);
      // debugPrint('${homeModel?.status}');

      for (var element in homeModel!.data.products) {
        favorites.addAll({element.id: element.inFavorites});
      }

      debugPrint(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategories() {
    DioHelper.getData(url: categoriesEndpoint, token: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: favoritesEndpoint,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      // print('Error=${error.toString()}');

      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: favoritesEndpoint,
      token: token,
    ).then((value) {
      // print('Test For My Error1');
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      // print('Test For My Error3');
      debugPrint(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;
  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: profileEndpoint,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      debugPrint(userModel!.data!.name);

      emit(ShopSuccessUserDataState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: updateProfileEndpoint,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      debugPrint(userModel!.data!.name);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorUpdateUserState(error.toString()));
    });
  }
}
