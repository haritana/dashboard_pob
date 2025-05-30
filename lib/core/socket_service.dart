import 'package:dashboard_pob/const/constanta.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:developer';

class SocketService {
  static io.Socket? socket;

  static void init() {
    socket ??= io.io(urlServer, <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    socket!.onConnect((_) => log('🔗 Connected to WebSocket'));
    socket!.onDisconnect((_) => log('❌ Disconnected from WebSocket'));
  }

  static void on(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  static void emit(String event, [dynamic data]) {
    socket?.emit(event, data);
  }

  static void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
