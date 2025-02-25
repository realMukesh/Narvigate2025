import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routes/my_constant.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final bool softWrap;

  const CustomTextView({
    Key? key,
    required this.text,
    this.color = colorSecondary,
    this.fontSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.w500,
    this.softWrap = true,
    this.maxLines,
    this.textOverflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines ?? 500,
        softWrap: softWrap,
        overflow: textOverflow ?? TextOverflow.ellipsis,
        style: GoogleFonts.getFont(MyConstant.currentFont,
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize.fSize,
            decorationColor: color,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.lineThrough
                    : TextDecoration.none));
  }
}

class CustomTextDescView extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int? maxLines;
  final bool softWrap;

  const CustomTextDescView({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.bold,
    this.softWrap = true,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines ?? 500,
        softWrap: softWrap,
        style: GoogleFonts.getFont(MyConstant.currentFont,
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize.fSize,
            height: 2,
            decorationColor: color,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.lineThrough
                    : TextDecoration.none));
  }
}

class CustomReadMoreText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int? maxLines;
  final bool softWrap;

  const CustomReadMoreText({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.bold,
    this.softWrap = true,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimMode: TrimMode.Line,
      trimLines: maxLines ?? 4,
      colorClickableText: accentColor,
      trimCollapsedText: 'Read more',
      trimExpandedText: ' Read less',
      lessStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff0052D9)),
      textAlign: TextAlign.start,
      style: GoogleFonts.getFont(MyConstant.currentFont,
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.fSize,
          decorationColor: color,
          decoration: underline
              ? TextDecoration.underline
              : centerUnderline
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
      moreStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff0052D9)),
    );
  }
}

class HighlightUrlText extends StatefulWidget {
  final String text;
  final Color color;
  final TextStyle? style;
  final TextAlign textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool underline;
  final int? maxLines;
  final int trimLines;

  HighlightUrlText({
    required this.text,
    required this.color,
    this.style,
    this.textAlign = TextAlign.start,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.underline = false,
    this.trimLines = 4,
  });

  @override
  _HighlightUrlTextState createState() => _HighlightUrlTextState();
}

class _HighlightUrlTextState extends State<HighlightUrlText> {
  bool _isExpanded = false;

  // Regular expression for matching URLs
  final RegExp _urlPattern = RegExp(
    r'(https?|ftp)://[^\s/$.?#].[^\s]*',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    String displayText = _isExpanded
        ? widget.text
        : _getTrimmedText(widget.text, widget.trimLines);
    bool moreThenLines =
        isMoreThanFourLines(widget.text, TextStyle(fontSize: widget.fontSize));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: widget.textAlign,
          text: TextSpan(
            children: _buildTextWithLinks(displayText),
            style:GoogleFonts.getFont(MyConstant.currentFont,
              color: widget.color,
              fontWeight: widget.fontWeight,
              fontSize: widget.fontSize,
              decorationColor: widget.color,
              decoration: widget.underline
                  ? TextDecoration.underline
                  : TextDecoration.none,),
          ),
        ),
        // _buildReadMoreLess()
        moreThenLines ? _buildReadMoreLess() : const SizedBox(),
      ],
    );
  }

  // Method to build the text with clickable URLs
  List<TextSpan> _buildTextWithLinks(String text) {
    final matches = _urlPattern.allMatches(text);
    List<TextSpan> textSpans = [];
    int start = 0;

    for (final match in matches) {
      if (start < match.start) {
        textSpans.add(TextSpan(
          text: text.substring(start, match.start),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ));
      }

      textSpans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Open the URL when clicked
            _launchURL(match.group(0)!);
          },
      ));

      start = match.end;
    }

    // Add remaining text after the last URL
    if (start < text.length) {
      textSpans.add(TextSpan(
        text: text.substring(start),
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ));
    }

    return textSpans;
  }

  // Method to trim the text
  String _getTrimmedText(String text, int maxLines) {
    final words = text.split(' ');
    int totalChars = 0;
    String trimmedText = '';
    for (int i = 0; i < words.length; i++) {
      totalChars += words[i].length + 1; // Add 1 for space
      if (totalChars > 100 * maxLines) {
        // Rough estimate of chars per line
        trimmedText += '...';
        break;
      }
      trimmedText += '${words[i]} ';
    }
    return trimmedText.trim();
  }

  // Method to launch the URL using the url_launcher package
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }

  // Method to build the Read More / Read Less button
  Widget _buildReadMoreLess() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Text(
        _isExpanded ? 'Read less' : 'Read more',
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: gradientBegin),
      ),
    );
  }

  bool isMoreThanFourLines(String text, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 4,
    )..layout(maxWidth: double.infinity);

    // Compare the number of lines rendered with the maximum lines
    return textPainter.height > style.fontSize! * 4;
  }
}

class TextLineCheck extends StatelessWidget {
  final String text;
  final TextStyle style;

  TextLineCheck({required this.text, required this.style});

  bool isMoreThanFourLines(String text, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 4,
    )..layout(maxWidth: double.infinity);

    // Compare the number of lines rendered with the maximum lines
    return textPainter.height > style.fontSize! * 4;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: style,
        ),
        const SizedBox(height: 20),
        Text(
          isMoreThanFourLines(text, style)
              ? 'More than 4 lines'
              : 'Less than 4 lines',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class AutoCustomTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final int maxLines;
  final FontWeight fontWeight;
  final double height;

  const AutoCustomTextView({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.fontWeight = FontWeight.normal,
    this.height = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        textAlign: textAlign,
        maxLines: maxLines,
        minFontSize: fontSize,
        maxFontSize: double.infinity,
        style: GoogleFonts.getFont(MyConstant.currentFont,
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize.fSize,
            height: height,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.lineThrough
                    : TextDecoration.none));
  }
}
