class IceCandidateModel {
  final String candidate;
  final String sdpMid;
  final int sdpMLineIndex;

  const IceCandidateModel({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
  });

  factory IceCandidateModel.fromMap(Map<String, dynamic> map) {
    return IceCandidateModel(
      candidate: map['candidate'] ?? '',
      sdpMid: map['sdpMid'] ?? '',
      sdpMLineIndex: map['sdpMLineIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex': sdpMLineIndex,
    };
  }
}
