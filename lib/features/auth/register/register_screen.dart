import 'package:evently_sat_online/core/resources/assets_manager.dart';
import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/core/routes_manager/routes_manager.dart';
import 'package:evently_sat_online/core/ui_utils/dialog_utils.dart';
import 'package:evently_sat_online/core/utils/validator.dart';
import 'package:evently_sat_online/core/widgets/custom_elevated_button.dart';
import 'package:evently_sat_online/core/widgets/custom_text_button.dart';
import 'package:evently_sat_online/core/widgets/custom_text_form_field.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:evently_sat_online/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AppLocalizations appLocalizations = AppLocalizations.of(context)!;

  late TextEditingController _nameController;

  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  late TextEditingController _confirmPasswordController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool securePassword = true;
  bool secureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(ImageAssets.evenltyLogo),
              
                  Text(
                    appLocalizations.create_your_account,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 24.h),
              
                  CustomTextFormField(
                    validator: Validator.validateName,
                    controller: _nameController,
                    hintText: appLocalizations.enter_your_name,
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    validator: Validator.validateEmail,
                    controller: _emailController,
                    hintText: appLocalizations.enter_your_email,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  SizedBox(height: 16.h),
              
                  CustomTextFormField(
                    isSecure: securePassword,
                    validator: Validator.validatePassword,
                    controller: _passwordController,
                    hintText: appLocalizations.enter_your_password,
                    prefixIcon: Icon(Icons.lock_clock_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          securePassword = !securePassword;
                        });
                      },
                      icon: Icon(
                        securePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
              
                  CustomTextFormField(
                    isSecure: secureConfirmPassword,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Plz, confirm password";
                      }
                      if (input != _passwordController.text) {
                        return "Password doesn't match";
                      }
                      return null;
                    },
                    controller: _confirmPasswordController,
                    hintText: appLocalizations.confirm_your_password,
                    prefixIcon: Icon(Icons.lock_clock_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          secureConfirmPassword = !secureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        secureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomElevatedButton(
                    title: appLocalizations.sing_up,
                    onClick: _register,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${appLocalizations.already_have_an_account} ",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      CustomTextButton(
                        title: appLocalizations.login,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.login,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
              
                  Row(
                    children: [
                      Expanded(child: Divider(color: ColorsManager.blue, thickness: 1.h, indent: 40.w, endIndent: 10.w,)),
                      Text("OR", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: ColorsManager.blue),),
                      Expanded(child: Divider(color: ColorsManager.blue, thickness: 1.h, indent: 10.w, endIndent: 40.w,)),
                    ],
                  ),
              
                  SizedBox(height: 16.h),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: REdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      side: BorderSide(color: ColorsManager.white),
                    ),
                    onPressed: _signUpWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/image 6.png", height: 24.h,),
                        SizedBox(width: 8.w,),
                        Text("Sign Up With Google", style: Theme.of(context).textTheme.displayLarge?.copyWith(color: ColorsManager.darkBlue),),
                      ],
                    ),
                  ),
              

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    // if (_formKey.currentState?.validate() == false) return;
    try {
      DialogUtils.showLoading(context, dismissible: false);
     UserCredential credential = await FirebaseService.register(email: _emailController.text, password: _passwordController.text);
     DialogUtils.hideDialog(context);
     UserModel user = UserModel(id: credential.user!.uid, name: _nameController.text, email: _emailController.text, favouriteEventsIds: []);
     await FirebaseService.addUserToFireStore(user);
      DialogUtils.showToastMessage(
        message: "Successfully Registration",
        bgColor: Colors.green,
      );
     Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (exception) {
      DialogUtils.hideDialog(context);
      if (exception.code == 'weak-password') {
        DialogUtils.showToastMessage(
          message: 'The password provided is too weak.',
          bgColor: Colors.red,
        );
      } else if (exception.code == 'email-already-in-use') {
        DialogUtils.showToastMessage(
          message: 'The account already exists for that email.',
          bgColor: Colors.red,
        );
      }
    } catch (exception) {
      DialogUtils.hideDialog(context);
      DialogUtils.showToastMessage(
        message: 'Something went wrong.',
        bgColor: Colors.red,
      );
    }
  }

  void _signUpWithGoogle() async {
    try {
      DialogUtils.showLoading(context, dismissible: false);
      UserCredential? credential = await FirebaseService.signInWithGoogle();
      if (credential != null) {
        UserModel.currentUser = await FirebaseService.getUserFromFirStore(credential.user!.uid);
        DialogUtils.hideDialog(context);
        DialogUtils.showToastMessage(
            message: "Successfully Registration", bgColor: Colors.green);
        Navigator.pushReplacementNamed(context, RoutesManager.homeScreen,);
      } else {
        DialogUtils.hideDialog(context);
      }
    } catch (e) {
      DialogUtils.hideDialog(context);
      DialogUtils.showToastMessage(message: e.toString(), bgColor: Colors.red);
    }
  }
}
