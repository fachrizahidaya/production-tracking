import 'package:html/parser.dart' as html_parser;

String htmlToPlainText(dynamic htmlString) {
  if (htmlString == null) return '';

  if (htmlString is List) {
    return htmlString.join(" ");
  }

  if (htmlString is! String) {
    return htmlString.toString();
  }

  final document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}
