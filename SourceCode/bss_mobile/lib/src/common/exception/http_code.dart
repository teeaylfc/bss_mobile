import 'package:bss_mobile/src/common/exception/http_error_event.dart';
import 'package:event_bus/event_bus.dart';

class HttpCode {
  static const NETWORK_ERROR = -1;

  static const NETWORK_TIMEOUT = -2;

  static const NETWORK_JSON_EXCEPTION = -3;

  static const SUCCESS = 200;

  static EventBus eventBus = EventBus();

  static errorHandleFunction(code, message, noTip) {
    if (noTip != null) {
      return message;
    }
    eventBus.fire(HttpErrorEvent(code, message));
    return message;
  }
}
