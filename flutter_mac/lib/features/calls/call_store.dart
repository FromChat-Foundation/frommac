import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers.dart';

enum CallPhase { idle, connecting, incoming, inCall, failed }

class CallState {
  const CallState({
    this.phase = CallPhase.idle,
    this.peerUserId,
    this.peerName,
    this.roomName,
    this.error,
    this.micEnabled = true,
    this.cameraEnabled = false,
    this.screenShareEnabled = false,
    this.room,
  });

  final CallPhase phase;
  final int? peerUserId;
  final String? peerName;
  final String? roomName;
  final String? error;
  final bool micEnabled;
  final bool cameraEnabled;
  final bool screenShareEnabled;
  final Room? room;

  CallState copyWith({
    CallPhase? phase,
    int? peerUserId,
    String? peerName,
    String? roomName,
    String? error,
    bool? micEnabled,
    bool? cameraEnabled,
    bool? screenShareEnabled,
    Room? room,
    bool clearError = false,
    bool clearRoom = false,
  }) =>
      CallState(
        phase: phase ?? this.phase,
        peerUserId: peerUserId ?? this.peerUserId,
        peerName: peerName ?? this.peerName,
        roomName: roomName ?? this.roomName,
        error: clearError ? null : (error ?? this.error),
        micEnabled: micEnabled ?? this.micEnabled,
        cameraEnabled: cameraEnabled ?? this.cameraEnabled,
        screenShareEnabled: screenShareEnabled ?? this.screenShareEnabled,
        room: clearRoom ? null : (room ?? this.room),
      );
}

class CallStore extends StateNotifier<CallState> {
  CallStore(this._ref) : super(const CallState());

  final Ref _ref;
  final _uuid = const Uuid();

  void onSignaling(Map<String, dynamic> data) {
    final kind = data['kind'] as String?;
    final roomName = data['roomName'] as String?;
    final fromUserId = data['fromUserId'] as int?;
    final fromUsername = data['fromUsername'] as String?;

    if (kind == null && roomName != null && fromUserId != null) {
      state = CallState(
        phase: CallPhase.incoming,
        peerUserId: fromUserId,
        peerName: fromUsername,
        roomName: roomName,
      );
      return;
    }
    switch (kind) {
      case 'decline':
      case 'end':
      case 'cancel':
        endLocal();
      case 'accept':
        break;
    }
  }

  Future<void> startCall({
    required int peerUserId,
    String? peerName,
  }) async {
    if (!_ref.read(serverConfigProvider).callsEnabled) return;
    state = CallState(
      phase: CallPhase.connecting,
      peerUserId: peerUserId,
      peerName: peerName,
      roomName: 'call-${_uuid.v4()}',
    );
    try {
      final api = _ref.read(apiClientProvider);
      final tokenRes = await api.liveKitToken(
        peerUserId: peerUserId,
        roomName: state.roomName,
      );
      final token = tokenRes['token'] as String?;
      final roomName = tokenRes['room_name'] as String? ?? state.roomName!;
      if (token == null) throw StateError('No LiveKit token');
      _ref.read(webSocketProvider).callSignaling({
        'toUserId': peerUserId,
        'roomName': roomName,
      });
      await _connectRoom(token, roomName);
      state = state.copyWith(phase: CallPhase.inCall, roomName: roomName);
    } catch (e) {
      state = state.copyWith(phase: CallPhase.failed, error: '$e');
    }
  }

  Future<void> accept() async {
    final peer = state.peerUserId;
    final roomName = state.roomName;
    if (peer == null || roomName == null) return;
    state = state.copyWith(phase: CallPhase.connecting);
    try {
      final api = _ref.read(apiClientProvider);
      final tokenRes = await api.liveKitToken(
        peerUserId: peer,
        roomName: roomName,
      );
      final token = tokenRes['token'] as String?;
      if (token == null) throw StateError('No LiveKit token');
      _ref.read(webSocketProvider).callSignaling({
        'toUserId': peer,
        'kind': 'accept',
        'roomName': roomName,
      });
      await _connectRoom(token, roomName);
      state = state.copyWith(phase: CallPhase.inCall);
    } catch (e) {
      state = state.copyWith(phase: CallPhase.failed, error: '$e');
    }
  }

  Future<void> decline() async {
    final peer = state.peerUserId;
    if (peer != null) {
      _ref.read(webSocketProvider).callSignaling({
        'toUserId': peer,
        'kind': 'decline',
        'roomName': state.roomName,
      });
    }
    await endLocal();
  }

  Future<void> hangup() async {
    final peer = state.peerUserId;
    if (peer != null) {
      _ref.read(webSocketProvider).callSignaling({
        'toUserId': peer,
        'kind': 'end',
        'roomName': state.roomName,
      });
    }
    await endLocal();
  }

  Future<void> endLocal() async {
    try {
      await state.room?.disconnect();
      await state.room?.dispose();
    } catch (_) {}
    state = const CallState();
  }

  Future<void> _connectRoom(String token, String roomName) async {
    final url = _ref.read(serverConfigProvider).liveKitSignalingWsUrl;
    final room = Room();
    await room.connect(url, token);
    await room.localParticipant?.setMicrophoneEnabled(true);
    state = state.copyWith(room: room, micEnabled: true);
  }

  Future<void> toggleMic() async {
    final next = !state.micEnabled;
    await state.room?.localParticipant?.setMicrophoneEnabled(next);
    state = state.copyWith(micEnabled: next);
  }

  Future<void> toggleCamera() async {
    final next = !state.cameraEnabled;
    await state.room?.localParticipant?.setCameraEnabled(next);
    state = state.copyWith(cameraEnabled: next);
  }

  Future<void> toggleScreenShare() async {
    final next = !state.screenShareEnabled;
    try {
      await state.room?.localParticipant?.setScreenShareEnabled(next);
      state = state.copyWith(screenShareEnabled: next);
    } catch (_) {
      // Screen share may require extra macOS entitlements.
    }
  }
}

final callStoreProvider =
    StateNotifierProvider<CallStore, CallState>((ref) => CallStore(ref));
