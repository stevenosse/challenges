import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/simple_rating_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const SimpleRatingApp());
}
