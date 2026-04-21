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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool securePassword = true;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  late AppLocalizations appLocalizations = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(ImageAssets.evenltyLogo, color: ColorsManager.blue,),

                  Text(
                   appLocalizations.login_to_your_account,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 24.h),

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
                    suffixIcon:IconButton(onPressed: (){
                      setState(() {
                      securePassword = !securePassword; // f

                      });
                    }, icon: Icon(securePassword ? Icons.visibility_off : Icons.visibility)),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextButton(
                    title: appLocalizations.forget_password,
                    align: TextAlign.end,
                  ),

                  SizedBox(height: 47.h),
                  CustomElevatedButton(title: appLocalizations.login, onClick: _login,),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appLocalizations.dont_have_an_account,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      CustomTextButton(
                        title:appLocalizations.sing_up,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.register,
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
                    onPressed: _loginWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/image 6.png", height: 24.h,),
                        SizedBox(width: 8.w,),
                        Text("Login With Google", style: Theme.of(context).textTheme.displayLarge?.copyWith(color: ColorsManager.darkBlue),),
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


  void _login()async{
   // if(_formKey.currentState?.validate() == false)return ;
    try{
      DialogUtils.showLoading(context, dismissible: false);
    UserCredential credential =   await FirebaseService.login(email: _emailController.text, password: _passwordController.text);
     UserModel.currentUser = await FirebaseService.getUserFromFirStore(credential.user!.uid);
    DialogUtils.hideDialog(context);
      DialogUtils.showToastMessage(
          message: "User Logged-In Successfully", bgColor: Colors.green);
      Navigator.pushReplacementNamed(context, RoutesManager.homeScreen,);
    }on FirebaseAuthException catch(exception){
     DialogUtils.hideDialog(context);
     DialogUtils.showToastMessage(message: "Wrong email or password", bgColor: Colors.red);
    }catch(exception){
      DialogUtils.hideDialog(context);
      DialogUtils.showToastMessage(message: exception.toString(), bgColor: Colors.red);
    }
  }

  void _loginWithGoogle() async {
    try {
      DialogUtils.showLoading(context, dismissible: false);
      UserCredential? credential = await FirebaseService.signInWithGoogle();
      if (credential != null) {
        UserModel.currentUser = await FirebaseService.getUserFromFirStore(credential.user!.uid);
        DialogUtils.hideDialog(context);
        DialogUtils.showToastMessage(
            message: "User Logged-In Successfully", bgColor: Colors.green);
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
