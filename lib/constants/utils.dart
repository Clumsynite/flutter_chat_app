import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:timeago/timeago.dart' as timeago;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showSnackBarWithAction(
  BuildContext context,
  String message,
  String label,
  VoidCallback onAction,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: label,
        onPressed: onAction,
      ),
      content: Text(message),
      duration: const Duration(milliseconds: 10000),
      // width: 280.0, // Width of the SnackBar.
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 8.0, // Inner padding for SnackBar content.
      // ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

String getFormattedDate(String isoDate) {
  return isoDate.isEmpty
      ? DateTime.now().toHumanString()
      : (DateTime.parse(isoDate).toHumanString());
}

DateTime getDateFromISO(String dateString) {
  return dateString.isEmpty ? DateTime.now() : DateTime.parse(dateString);
}

String getRelativeTime(String dateString) {
  return timeago.format(getDateFromISO(dateString));
}
