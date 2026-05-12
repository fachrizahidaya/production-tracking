import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

String normalizeHtmlContent(dynamic htmlString) {
  if (htmlString == null) return '';

  if (htmlString is List) {
    return htmlString.map((item) => item?.toString() ?? '').join(' ');
  }

  if (htmlString is! String) {
    return htmlString.toString();
  }

  return htmlString;
}

bool isHtmlBlank(dynamic htmlString) {
  return htmlToPlainText(htmlString).trim().isEmpty;
}

String htmlToPlainText(dynamic htmlString) {
  final htmlContent = normalizeHtmlContent(htmlString);
  if (htmlContent.trim().isEmpty) return '';

  final document = html_parser.parse(htmlContent);
  return _HtmlPlainTextFormatter().format(document.body);
}

Widget formattedHtmlContent(
  dynamic htmlString, {
  TextStyle? textStyle,
}) {
  final htmlContent = normalizeHtmlContent(htmlString);
  final baseStyle = textStyle ?? const TextStyle(fontSize: 14, height: 1.5);

  if (htmlContent.trim().isEmpty || isHtmlBlank(htmlContent)) {
    return const SizedBox.shrink();
  }

  return Html(
    data: htmlContent,
    shrinkWrap: true,
    style: {
      '*': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      'body': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      'p': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.only(bottom: 8),
      ),
      'ol': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.only(left: 18, bottom: 8),
      ),
      'ul': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.only(left: 18, bottom: 8),
      ),
      'li': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.only(bottom: 4),
      ),
      'h1': Style.fromTextStyle(baseStyle).copyWith(
        fontSize: FontSize((baseStyle.fontSize ?? 14) + 8),
        fontWeight: FontWeight.w700,
        margin: Margins.only(bottom: 10),
      ),
      'h2': Style.fromTextStyle(baseStyle).copyWith(
        fontSize: FontSize((baseStyle.fontSize ?? 14) + 5),
        fontWeight: FontWeight.w700,
        margin: Margins.only(bottom: 8),
      ),
      'h3': Style.fromTextStyle(baseStyle).copyWith(
        fontSize: FontSize((baseStyle.fontSize ?? 14) + 3),
        fontWeight: FontWeight.w600,
        margin: Margins.only(bottom: 6),
      ),
      'blockquote': Style.fromTextStyle(baseStyle).copyWith(
        margin: Margins.only(left: 12, bottom: 8),
        padding: HtmlPaddings.only(left: 10),
        border: const Border(
          left: BorderSide(color: Colors.black26, width: 3),
        ),
      ),
      '.ql-align-left': Style(textAlign: TextAlign.left),
      '.ql-align-center': Style(textAlign: TextAlign.center),
      '.ql-align-right': Style(textAlign: TextAlign.right),
      '.ql-align-justify': Style(textAlign: TextAlign.justify),
      for (var level = 1; level <= 8; level++)
        '.ql-indent-$level': Style(
          margin: Margins.only(left: 24.0 * level),
        ),
    },
  );
}

class _ListContext {
  int index = 0;
  final bool ordered;

  _ListContext({
    required this.ordered,
  });
}

class _HtmlPlainTextFormatter {
  final StringBuffer _buffer = StringBuffer();
  final List<_ListContext> _listStack = [];

  bool _insideListItem = false;

  String format(dom.Node? node) {
    if (node == null) return '';

    _visitChildren(node.nodes);

    return _buffer
        .toString()
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  void _visit(dom.Node node) {
    if (node is dom.Text) {
      _writeText(node.text);
      return;
    }

    if (node is! dom.Element) return;

    final tagName = node.localName?.toLowerCase() ?? '';

    if (tagName == 'script' || tagName == 'style') return;

    switch (tagName) {
      case 'br':
        _writeNewLine();
        break;
      case 'ol':
      case 'ul':
        _writeBlockGap();
        _listStack.add(_ListContext(ordered: tagName == 'ol'));
        _visitChildren(node.nodes);
        _listStack.removeLast();
        _writeBlockGap();
        break;
      case 'li':
        _writeListItem(node);
        break;
      case 'p':
      case 'div':
      case 'section':
      case 'article':
      case 'header':
      case 'footer':
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
      case 'blockquote':
        _writeBlock(node);
        break;
      case 'tr':
        _visitChildren(node.nodes);
        _writeNewLine();
        break;
      case 'td':
      case 'th':
        _visitChildren(node.nodes);
        _writeText(' ');
        break;
      default:
        _visitChildren(node.nodes);
    }
  }

  void _visitChildren(List<dom.Node> nodes) {
    for (final child in nodes) {
      _visit(child);
    }
  }

  void _writeBlock(dom.Element node) {
    if (_insideListItem) {
      _visitChildren(node.nodes);
      return;
    }

    _writeBlockGap();
    _visitChildren(node.nodes);
    _writeBlockGap();
  }

  void _writeListItem(dom.Element node) {
    final context =
        _listStack.isEmpty ? _ListContext(ordered: false) : _listStack.last;

    if (context.ordered) context.index += 1;

    _writeNewLine();

    final indentLevel = (_listStack.length - 1).clamp(0, 6).toInt();
    final indent = '  ' * indentLevel;
    final marker = context.ordered ? '${context.index}. ' : '- ';
    _buffer.write('$indent$marker');

    final previousInsideListItem = _insideListItem;
    _insideListItem = true;
    _visitChildren(node.nodes);
    _insideListItem = previousInsideListItem;

    _writeNewLine();
  }

  void _writeText(String text) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.trim().isEmpty) return;

    if (_buffer.isNotEmpty &&
        !_endsWithWhitespace() &&
        !normalized.startsWith(' ')) {
      _buffer.write(' ');
    }

    _buffer.write(normalized.trim());
  }

  void _writeNewLine() {
    if (_buffer.isEmpty || _buffer.toString().endsWith('\n')) return;
    _buffer.write('\n');
  }

  bool _endsWithWhitespace() {
    if (_buffer.isEmpty) return false;
    final text = _buffer.toString();
    return RegExp(r'\s').hasMatch(text.substring(text.length - 1));
  }

  void _writeBlockGap() {
    if (_buffer.isEmpty) return;

    final text = _buffer.toString();
    if (text.endsWith('\n\n')) return;
    if (text.endsWith('\n')) {
      _buffer.write('\n');
    } else {
      _buffer.write('\n\n');
    }
  }
}
