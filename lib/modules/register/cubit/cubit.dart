import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states.dart';
import '../../../shared/network/remote/dio_helper.dart';

import '../../../models/shop_login_model.dart';
import '../../../shared/network/end_points.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  // Create an object from cubit
  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel registerModel;

  // All logic in cubit
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());

    DioHelper.postData(
      url: registerEndpoint, // endpoint
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      debugPrint(value.data.toString());
      registerModel = ShopLoginModel.fromJson(value.data);

      emit(ShopRegisterSuccessState(registerModel));
    }).catchError((error) {
      debugPrint('Error=${error.toString()}');
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;
  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
