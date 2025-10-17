// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:maharashtrajagran/common/notification_controller.dart' as _i136;
import 'package:maharashtrajagran/common/update_app.dart' as _i250;
import 'package:maharashtrajagran/network/api_service.dart' as _i836;
import 'package:maharashtrajagran/network/register_module.dart' as _i127;
import 'package:maharashtrajagran/view/bookmark/controller/bookmark_controller.dart'
    as _i327;
import 'package:maharashtrajagran/view/home/controller/home_controller.dart'
    as _i511;
import 'package:maharashtrajagran/view/home/controller/news_controller.dart'
    as _i256;
import 'package:maharashtrajagran/view/home/controller/search_controller.dart'
    as _i356;
import 'package:maharashtrajagran/view/home/controller/update_firebase_token.dart'
    as _i71;
import 'package:maharashtrajagran/view/navigator/controller/navigation_controller.dart'
    as _i801;
import 'package:maharashtrajagran/view/onboarding/controller/forget_password_controller.dart'
    as _i197;
import 'package:maharashtrajagran/view/onboarding/controller/onboarding_controller.dart'
    as _i962;
import 'package:maharashtrajagran/view/profile/controller/profile_controller.dart'
    as _i475;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i136.NotificationController>(
      () => _i136.NotificationController(),
    );
    gh.lazySingleton<_i250.UpdateController>(() => _i250.UpdateController());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i327.BookmarkController>(
      () => _i327.BookmarkController(),
    );
    gh.lazySingleton<_i511.HomeController>(() => _i511.HomeController());
    gh.lazySingleton<_i256.NewsController>(() => _i256.NewsController());
    gh.lazySingleton<_i356.SearchDataController>(
      () => _i356.SearchDataController(),
    );
    gh.lazySingleton<_i71.FirebaseTokenController>(
      () => _i71.FirebaseTokenController(),
    );
    gh.lazySingleton<_i801.NavigationController>(
      () => _i801.NavigationController(),
    );
    gh.lazySingleton<_i197.ForgetPasswordController>(
      () => _i197.ForgetPasswordController(),
    );
    gh.lazySingleton<_i962.OnboardingController>(
      () => _i962.OnboardingController(),
    );
    gh.lazySingleton<_i475.ProfileController>(() => _i475.ProfileController());
    gh.factory<_i836.ApiService>(() => _i836.ApiService(gh<_i361.Dio>()));
    return this;
  }
}

class _$RegisterModule extends _i127.RegisterModule {}
