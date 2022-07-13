import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/shop_layout/cubit/cubit.dart';
import '../../layout/shop_layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateUserState) {
          if (state.userModel.status) {
            showToast(
              text: state.userModel.message ?? 'Null',
              state: ToastStates.success,
            );
          } else {
            showToast(
              text: state.userModel.message ?? 'Null',
              state: ToastStates.error,
            );
          }
        } else if (state is ShopErrorUpdateUserState) {
          showToast(
            text: state.error,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        final model = ShopCubit.get(context);

        return ConditionalBuilder(
          condition: (model.userModel != null),
          builder: (context) {
            nameController.text = model.userModel!.data!.name;
            emailController.text = model.userModel!.data!.email;
            phoneController.text = model.userModel!.data!.phone;

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if (State is ShopLoadingUpdateUserState)
                          const LinearProgressIndicator(),
                        const SizedBox(height: 20.0),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            }
                            return null;
                          },
                          label: 'Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(height: 20.0),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty ||
                                !EmailValidator.validate(value)) {
                              return 'Email must not be empty';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(height: 20.0),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(height: 20.0),
                        ConditionalBuilder(
                          condition: state is! ShopLoadingUpdateUserState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopCubit.get(context).updateUserData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'Update',
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 20.0),
                        defaultButton(
                          function: () {
                            signOut(context);
                          },
                          text: 'Logout',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
