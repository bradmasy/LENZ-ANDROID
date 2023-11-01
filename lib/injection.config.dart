// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:photo_gallery/auth/services/AuthService.dart' as _i4;
import 'package:photo_gallery/auth/services/AuthServiceApi.dart' as _i5;
import 'package:photo_gallery/globals.dart' as _i3;
import 'package:photo_gallery/util/LocationUtil.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AppState>(_i3.AppState());
    gh.factory<_i4.AuthService>(() => _i5.AuthServiceAPI());
    gh.factory<_i6.LocationUtil>(() => _i6.LocationUtil());
    return this;
  }
}
