enum FormType {login, register}

class EmailValidator {
  static String validate(String value){
    return (value.isEmpty || !value.contains('@')) ? 'Please enter a valid email' : null;
  }
}

class PasswordValidator {
  static String validate(String value){
    return (value.isEmpty || value.length < 8) ? 'Password must be at least 8 characters long' : null;
  }
}