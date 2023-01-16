class UserRegiserValidations {
  String? validateName(String _controllerValueText) {
    // at any time, we can get the text from _controller.value.text
    final text = _controllerValueText;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Boş olamaz';
    }
    if (text.length < 5) {
      return 'Çok kısa';
    } else {
      // return null if the text is valid
      return null;
    }
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email giriniz";
    } else {
      bool emailValid =
          RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
              .hasMatch(email);

      if (emailValid == true) {
        return null;
      } else {
        return "geçersiz email";
      }
    }
  }

  String? validatePasword(String pasword) {
    final text = pasword;
    if (text.isEmpty) {
      return 'Bir şifre belirleyin';
    }
    if (text.length < 7) {
      return 'En az 8 karekter olmalıdır';
    }
    return null;
  }

  String? validatePaswordAgain(String sifre1, String sifre2) {
    if (sifre1 != sifre2) {
      return "Şifreler aynı değil";
    } else {
      return null;
    }
  }
}
