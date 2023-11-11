import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_suggestions/wordlist.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWithSuggestions extends StatefulWidget {
  final TextEditingController textFieldController;
  final String? hintText;
  final String? labelText;
  TextStyle? hintstyling;
  TextStyle? labelstyling;
  TextStyle? style;
  InputBorder? border;
  final int? maxLines;
  final double? fontSize;
  final EdgeInsets? contentPadding;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;

  TextFieldWithSuggestions({
    required this.textFieldController,
    this.hintText,
    this.labelText,
    this.hintstyling,
    this.style,
    this.labelstyling,
    this.border,
    this.maxLines,
    this.fontSize,
    this.contentPadding,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });

  @override
  _TextFieldWithSuggestionsState createState() =>
      _TextFieldWithSuggestionsState();
}

class _TextFieldWithSuggestionsState extends State<TextFieldWithSuggestions> {
  List<String> filteredSuggestions = [];
  List<String> allSuggestions = [];
  int batchIndex = 0;
  static const int batchSize = 10;
  Timer? suggestionTimer;
  WordList list = WordList();

  @override
  void initState() {
    super.initState();
    allSuggestions = list.wordList ?? [];
    widget.textFieldController.addListener(onTextFieldChanged);
  }

  @override
  void dispose() {
    widget.textFieldController.removeListener(onTextFieldChanged);
    suggestionTimer?.cancel();
    super.dispose();
  }

  void onTextFieldChanged() {
    suggestionTimer?.cancel();

    suggestionTimer = Timer(Duration(seconds: 1), () {
      String text = widget.textFieldController.text;
      List<String> words = text.split(' ');
      String lastWord = words.isNotEmpty ? words.last.toLowerCase() : '';

      if (lastWord.isNotEmpty) {
        filteredSuggestions = allSuggestions
            .where((word) => word.toLowerCase().startsWith(lastWord))
            .toList();
        batchIndex = 0;
      } else {
        filteredSuggestions.clear();
      }

      setState(() {});
    });
  }

  void loadNextBatch() {
    int nextBatchIndex = batchIndex + batchSize;
    if (nextBatchIndex < filteredSuggestions.length) {
      batchIndex = nextBatchIndex;
    } else {
      // If we're at the end, reset to the beginning
      batchIndex = 0;
    }
    setState(() {});
  }

  void loadPreviousBatch() {
    int previousBatchIndex = batchIndex - batchSize;
    if (previousBatchIndex >= 0) {
      batchIndex = previousBatchIndex;
    } else {
      // If we're at the beginning, go to the last batch
      int lastBatchIndex =
          (filteredSuggestions.length / batchSize).floor() * batchSize;
      batchIndex = lastBatchIndex;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          TextField(
            controller: widget.textFieldController,
            maxLines: widget.maxLines ?? 1,
            style: widget.style ??
                GoogleFonts.roboto(fontSize: widget.fontSize ?? 20),
            decoration: InputDecoration(
              hintText: widget.hintText ?? "Type Something...",
              labelText: widget.labelText,
              hintStyle: widget.hintstyling,
              labelStyle: widget.labelstyling,
              border: widget.border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ??
                        8.0), // Set rounded corner radius
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.black,
                      width: widget.borderWidth ?? 1.0,
                    ),
                  ),
              contentPadding:
                  widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
          if (filteredSuggestions.isNotEmpty)
            Column(
              children: [
                Container(
                  height: 150, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: batchSize,
                    itemBuilder: (context, index) {
                      int suggestionIndex = batchIndex + index;
                      if (suggestionIndex < filteredSuggestions.length) {
                        return ListTile(
                          title: Text(filteredSuggestions[suggestionIndex]),
                          onTap: () {
                            String text = widget.textFieldController.text;
                            List<String> words = text.split(' ');
                            words.removeLast(); // Remove the last word
                            words.add(filteredSuggestions[suggestionIndex]);
                            String updatedText = words.join(' ');
                            widget.textFieldController.text = updatedText;
                            widget.textFieldController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: widget.textFieldController.text.length,
                              ),
                            );
                            setState(() {
                              filteredSuggestions.clear();
                            });
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: batchIndex > 0 ? loadPreviousBatch : null,
                        icon: batchIndex > 0
                            ? Icon(Icons.arrow_back_ios)
                            : Icon(Icons.block)
                        // child: Text(batchIndex > 0 ? 'Back' : 'End'),
                        ),
                    IconButton(
                      onPressed:
                          batchIndex + batchSize < filteredSuggestions.length
                              ? loadNextBatch
                              : null,
                      icon: batchIndex + batchSize < filteredSuggestions.length
                          ? Icon(Icons.arrow_forward_ios)
                          : Icon(Icons.block),
                    ),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }
}
