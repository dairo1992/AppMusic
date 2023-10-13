import 'package:dio/dio.dart';

class Conexion {
  
  Dio getConexion() {
    return Dio(
        BaseOptions(baseUrl: "https://discoveryprovider3.audius.co/v1/"));
  }
  // Conexion()
  //     : dio = Dio(
  //           BaseOptions(baseUrl: "https://discoveryprovider3.audius.co/v1/"));
}
