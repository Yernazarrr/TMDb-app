import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:themdb_app/resources/resources.dart';

void main() {
  test('app_images assets test', () {
    expect(File(AppImages.theDarkKnight).existsSync(), isTrue);
    expect(File(AppImages.theDarkKnightBackgroundImg).existsSync(), isTrue);
    expect(File(AppImages.theDarkKnightPoster).existsSync(), isTrue);
  });
}
