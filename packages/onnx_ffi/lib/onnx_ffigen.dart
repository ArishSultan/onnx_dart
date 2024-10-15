import 'dart:io';

void listFilesInDirectory(String directoryPath) async {
  final directory = Directory(directoryPath);

  if (await directory.exists()) {
    await for (var entity in directory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        print('File: ${entity.path}');
      }
    }
  } else {
    print('Directory does not exist.');
  }
}
