abstract class Validator{
  static String? validateName(String? name){
    if(name == null || name.trim().isEmpty){
      return "Plz, enter your name";
    }
    return null;
  }
 static String? validateEmail(String? email){
   RegExp emailRegex =  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if(email == null){
      return "Plz, enter email";
    }
    if(!emailRegex.hasMatch(email)){
      return "Email bad format";
    }
    return null;
  }
 static  String? validatePassword(String? password){
    RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if(password == null || password.trim().isEmpty){
      return "Plz, enter password";
    }
    if(!passwordRegex.hasMatch(password)){
      return "Weak password";
    }
    return null;
  }
}