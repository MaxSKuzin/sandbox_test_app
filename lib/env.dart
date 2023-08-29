import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'api_key')
  static const String apiKey = _Env.apiKey;
}
