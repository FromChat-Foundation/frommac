import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'call_store.dart';

class CallOverlay extends ConsumerWidget {
  const CallOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callStoreProvider);
    final l10n = AppLocalizations.of(context);
    if (call.phase == CallPhase.idle) return const SizedBox.shrink();

    return Material(
      color: Colors.black54,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: switch (call.phase) {
                CallPhase.incoming => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        call.peerName ?? 'Call',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(l10n.call_incoming_subtitle),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () =>
                                ref.read(callStoreProvider.notifier).decline(),
                            child: Text(l10n.call_decline),
                          ),
                          const SizedBox(width: 16),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () =>
                                ref.read(callStoreProvider.notifier).accept(),
                            child: Text(l10n.call_accept),
                          ),
                        ],
                      ),
                    ],
                  ),
                CallPhase.connecting => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(l10n.call_status_connecting),
                    ],
                  ),
                CallPhase.failed => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.call_failed_title),
                      if (call.error != null) Text(call.error!),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            ref.read(callStoreProvider.notifier).endLocal(),
                        child: Text(l10n.call_dismiss),
                      ),
                    ],
                  ),
                CallPhase.inCall => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        call.peerName ?? l10n.call_status_in_call,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(l10n.call_status_in_call),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                            tooltip: l10n.cd_call_mic,
                            onPressed: () =>
                                ref.read(callStoreProvider.notifier).toggleMic(),
                            icon: Icon(
                              call.micEnabled ? Icons.mic : Icons.mic_off,
                            ),
                          ),
                          IconButton.filledTonal(
                            tooltip: l10n.cd_call_camera,
                            onPressed: () => ref
                                .read(callStoreProvider.notifier)
                                .toggleCamera(),
                            icon: Icon(
                              call.cameraEnabled
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                            ),
                          ),
                          IconButton.filledTonal(
                            tooltip: l10n.cd_call_screenshare,
                            onPressed: () => ref
                                .read(callStoreProvider.notifier)
                                .toggleScreenShare(),
                            icon: Icon(
                              call.screenShareEnabled
                                  ? Icons.stop_screen_share
                                  : Icons.screen_share,
                            ),
                          ),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            tooltip: l10n.cd_call_end,
                            onPressed: () =>
                                ref.read(callStoreProvider.notifier).hangup(),
                            icon: const Icon(Icons.call_end),
                          ),
                        ],
                      ),
                    ],
                  ),
                CallPhase.idle => const SizedBox.shrink(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
