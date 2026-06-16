String capitalize(String text) {
  String capitalized = text;

  if (text.isNotEmpty) {
    capitalized = text[0].toUpperCase() + text.substring(1);
  }
  return capitalized;
}
