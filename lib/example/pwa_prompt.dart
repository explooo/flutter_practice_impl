export 'pwa_prompt_stub.dart'
    if (dart.library.js) 'pwa_prompt_web.dart'
    if (dart.library.io) 'pwa_prompt_mobile.dart';
