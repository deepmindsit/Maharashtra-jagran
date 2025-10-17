import 'package:maharashtrajagran/di/injection.config.dart';
import '../utils/exported_path.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
