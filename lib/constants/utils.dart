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
