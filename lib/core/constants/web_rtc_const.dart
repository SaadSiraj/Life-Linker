abstract final class WebRtcConstants {
  WebRtcConstants._();

  static const List<Map<String, dynamic>> iceServers = [
    {
      'urls': [
        'stun:stun1.l.google.com:19302',
        'stun:stun2.l.google.com:19302',
        'stun:stun3.l.google.com:19302',
        'stun:stun4.l.google.com:19302',
      ],
    },
  ];

  static const Map<String, dynamic> rtcConfiguration = {
    'iceServers': iceServers,
    'sdpSemantics': 'unified-plan',
  };

  static const Map<String, dynamic> offerSdpConstraints = {
    'mandatory': {'OfferToReceiveAudio': false, 'OfferToReceiveVideo': true},
    'optional': [],
  };

  static const Map<String, dynamic> mediaConstraints = {
    'audio': false,
    'video': {
      'mandatory': {
        'minWidth': '640',
        'minHeight': '480',
        'minFrameRate': '24',
      },
      'facingMode': 'environment',
      'optional': [],
    },
  };
}
