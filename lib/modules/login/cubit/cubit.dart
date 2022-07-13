import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/shop_login_model.dart';
import 'states.dart';
import '../../../shared/network/remote/dio_helper.dart';

import '../../../shared/network/end_points.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  // Create an object from cubit
  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  // All logic in cubit
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
      url: loginEndpoint, // endpoint
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      // print(value.data);
      // print(value.data.runtimeType);
      loginModel = ShopLoginModel.fromJson(value.data);
      // print(loginModel.status);
      // print(loginModel.message);
      // print(loginModel.data?.token);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      debugPrint('Error=${error.toString()}');
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;
  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
}
