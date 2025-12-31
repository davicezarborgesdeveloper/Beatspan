import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar variáveis de ambiente do arquivo .env
  await dotenv.load(fileName: '.env');

  systemChromeConfigure();
  await initAppModule();
  runApp(MyApp());
}
