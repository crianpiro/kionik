String validarCorreo(String email) {

  RegExp emailRegExp = new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');

  if (email.length == 0) {
    return "Este campo es necesario";
  } else if (!emailRegExp.hasMatch(email)) {
    return "No coincide con el formato de correo.";
  } else {
    return null;
  }
}