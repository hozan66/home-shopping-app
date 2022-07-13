import 'package:flutter_bloc/flutter_bloc.dart';
import 'states.dart';

import '../../../models/search_model.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  // Create an object from cubit
  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: searchEndpoint,
      data: {'text': text},
      token: token,
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      // print(error.toString());
      emit(SearchErrorState());
    });
  }

  void changeFavorites(String text) {
    search(text);
  }
}
