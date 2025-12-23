import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/audio_recorder_service.dart';
import '../providers/timeline_provider.dart';
import 'sound_wave_visualizer.dart';

class FloatingActionWidget extends StatefulWidget {
  const FloatingActionWidget({super.key});

  @override
  State<FloatingActionWidget> createState() => _FloatingActionWidgetState();
}

class _FloatingActionWidgetState extends State<FloatingActionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  // Recording state
  bool _isRecording = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final audioService = Provider.of<AudioRecorderService>(context, listen: false);
    final hasPermission = await audioService.requestMicrophonePermission();
    setState(() {
      _hasPermission = hasPermission;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapToType() {
    if (_isRecording) {
      _stopRecording();
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const QuickInputSheet(),
    );
  }

  Future<void> _onLongPressToRecord() async {
    if (_isRecording) return;
    
    final audioService = Provider.of<AudioRecorderService>(context, listen: false);
    
    setState(() {});

    // Start recording
    final success = await audioService.startRecording();
    
    if (mounted) {
      if (success) {
        setState(() {
          _isRecording = true;
        });
        
        // Show recording overlay
        _showRecordingOverlay();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasPermission ? 'Failed to start recording' : 'Microphone permission required',
              style: GoogleFonts.inter(),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    
    final audioService = Provider.of<AudioRecorderService>(context, listen: false);
    
    // Stop recording
    final filePath = await audioService.stopRecording();
    
    // Update state immediately
    setState(() {
      _isRecording = false;
    });
    
    // Hide recording overlay
    if (mounted) {
      Navigator.of(context).pop();
    }
    
    // Add to timeline if recording was successful
    if (filePath != null && mounted) {
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.addAudioRecording(filePath);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Voice memo saved!',
              style: GoogleFonts.inter(),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _onLongPressEnd() async {
    // No longer needed - recording stops on tap
  }

  void _showRecordingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RecordingOverlay(
        amplitudeStream: Provider.of<AudioRecorderService>(context, listen: false).amplitudeStream,
        onCancel: () {
          if (!mounted) return;
          
          _stopRecording();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapToType,
      onLongPress: _onLongPressToRecord,
      onLongPressEnd: (_) => _onLongPressEnd(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.black,
                    Colors.grey[900]!,
                  ],
                  stops: [
                    0.0,
                    0.8,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuickInputSheet extends StatefulWidget {
  const QuickInputSheet({super.key});

  @override
  State<QuickInputSheet> createState() => _QuickInputSheetState();
}

class _QuickInputSheetState extends State<QuickInputSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitInput() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      // TODO: Process the input text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added: $text'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.black,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: null,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Type your note, task, or reminder...',
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: (_) => _submitInput(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Voice input feature
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voice input coming soon!'),
                      backgroundColor: Colors.black,
                    ),
                  );
                },
                icon: const Icon(Icons.mic, size: 20),
                label: Text(
                  'Voice',
                  style: GoogleFonts.inter(fontSize: 14),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
              ),
              ElevatedButton(
                onPressed: _submitInput,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Add',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class RecordingOverlay extends StatefulWidget {
  final VoidCallback onCancel;
  final Stream<double>? amplitudeStream;

  const RecordingOverlay({
    super.key,
    required this.onCancel,
    this.amplitudeStream,
  });

  @override
  State<RecordingOverlay> createState() => _RecordingOverlayState();
}

class _RecordingOverlayState extends State<RecordingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GestureDetector(
        onTap: widget.onCancel,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Recording...',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              SoundWaveVisualizer(
                isActive: true,
                amplitudeStream: widget.amplitudeStream,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to stop',
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.stop, size: 20),
                label: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}