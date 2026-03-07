import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/audio_recorder_service.dart';
import '../providers/timeline_provider.dart';
import 'sheets/quick_input_sheet.dart';
import 'recording_overlay.dart';
import '../constants/app_colors.dart';

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
      backgroundColor: AppColors.surface,
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

    final success = await audioService.startRecording();
    
    if (mounted) {
      if (success) {
        setState(() {
          _isRecording = true;
        });
        
        _showRecordingOverlay();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasPermission ? 'Failed to start recording' : 'Microphone permission required',
              style: GoogleFonts.inter(),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    
    final audioService = Provider.of<AudioRecorderService>(context, listen: false);
    
    final filePath = await audioService.stopRecording();
    
    setState(() {
      _isRecording = false;
    });
    
    if (mounted) {
      Navigator.of(context).pop();
    }
    
    if (filePath != null && mounted) {
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.addAudioRecording(filePath);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Voice memo saved!',
              style: GoogleFonts.inter(),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _onLongPressEnd() async {
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
                    AppColors.primary,
                    AppColors.grey900,
                  ],
                  stops: const [
                    0.0,
                    0.8,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.onPrimary,
                size: 32,
              ),
            ),
          );
        },
      ),
    );
  }
}
