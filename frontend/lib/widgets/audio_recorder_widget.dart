import 'package:flutter/material.dart';
import 'package:record/record.dart';

/// Audio recorder widget with breathing animation
class AudioRecorderWidget extends StatefulWidget {
  final Function(String base64Audio) onRecordingComplete;
  
  const AudioRecorderWidget({
    super.key,
    required this.onRecordingComplete,
  });
  
  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _recorder.dispose();
    super.dispose();
  }
  
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      final path = await _recorder.stop();
      
      if (path != null) {
        // Read the audio file and convert to base64
        // Note: This is a simplified version. In production, you'd handle this properly
        setState(() {
          _isRecording = false;
          _recordingPath = path;
        });
        
        // For now, just pass the path as a placeholder
        // In production, you'd read the file and encode it
        widget.onRecordingComplete(path);
      }
    } else {
      // Start recording
      if (await _recorder.hasPermission()) {
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: '/tmp/clarity_recording.m4a', // Temporary path
        );
        
        setState(() {
          _isRecording = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission denied'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        
        // Breathing animation circle
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final scale = _isRecording
                ? 1.0 + (_animationController.value * 0.3)
                : 1.0;
            
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        Text(
          _isRecording ? 'Tap to stop recording' : 'Tap to start recording',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        
        const SizedBox(height: 24),
        
        ElevatedButton.icon(
          onPressed: _toggleRecording,
          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
          label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
        ),
        
        if (_recordingPath != null && !_isRecording) ...[
          const SizedBox(height: 16),
          Text(
            'Recording saved',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.green,
            ),
          ),
        ],
      ],
    );
  }
}
