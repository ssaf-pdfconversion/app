import 'package:flutter/material.dart';
import 'package:mobile_application/documentos/descargar.dart';
import 'package:mobile_application/documentos/documentos.dart';
import 'package:mobile_application/usuarios/login.dart';
import 'package:get/get.dart';
import 'package:mobile_application/menu/menu.dart';
import 'package:mobile_application/metricas/metricas.dart';
import 'package:mobile_application/urls/descargar_urls.dart';
import 'package:mobile_application/urls/urls.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/menu', page: () => Menu()),
        GetPage(name: '/documentos', page: () => Documentos()),
        GetPage(name: '/urls', page: () =>Urls()),
        GetPage(name: '/descargarDocs', page: ( ) => Descargar()),
        GetPage(name: '/descargarUrls', page: ( ) => DescargarUrls()),
        GetPage(name: '/metricas', page: () => Metricas()),
      ],
    ),
  );
}



