import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioRecorderService extends ChangeNotifier {
  static final AudioRecorderService _instance = AudioRecorderService._internal();
  factory AudioRecorderService() => _instance;
  AudioRecorderService._internal();

  bool _isRecording = false;
  bool _hasPermission = false;
  String? _currentFilePath;
  DateTime? _recordingStartTime;
  
  // Amplitude streaming for visualizer
  final StreamController<double> _amplitudeController = StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;
  Timer? _amplitudeTimer;
  
  // Record plugin instance
  final AudioRecorder _recorder = AudioRecorder();

  // Getters
  bool get isRecording => _isRecording;
  bool get hasPermission => _hasPermission;
  String? get currentFilePath => _currentFilePath;
  DateTime? get recordingStartTime => _recordingStartTime;

  // Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    try {
      final permission = await Permission.microphone.request();
      _hasPermission = permission == PermissionStatus.granted;
      
      if (!_hasPermission) {
        debugPrint('Microphone permission denied');
      }
      
      notifyListeners();
      return _hasPermission;
    } catch (e) {
      debugPrint('Error requesting microphone permission: $e');
      return false;
    }
  }

  // Check if recording is available
  Future<bool> isRecordingAvailable() async {
    try {
      final permissionStatus = await Permission.microphone.status;
      return permissionStatus.isGranted;
    } catch (e) {
      debugPrint('Error checking recording availability: $e');
      return false;
    }
  }

  // Start recording with real Record plugin
  Future<bool> startRecording() async {
    if (!await isRecordingAvailable()) {
      debugPrint('Recording not available');
      return false;
    }

    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'audio_note_$timestamp.m4a';
      
      // Get app directory for saving recordings
      final directory = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${directory.path}/recordings');
      
      // Create recordings directory if it doesn't exist
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }
      
      _currentFilePath = '${recordingsDir.path}/$filename';
      _recordingStartTime = DateTime.now();

      // Start real recording with Record plugin
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentFilePath!,
      );
      
      _isRecording = true;
      
      // Start generating simulated amplitude data for visualization
      _startAmplitudeSimulation();
      
      notifyListeners();
      
      debugPrint('Started recording: $_currentFilePath');
      return true;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _isRecording = false;
      _currentFilePath = null;
      _recordingStartTime = null;
      notifyListeners();
      return false;
    }
  }

  // Stop recording with real Record plugin
  Future<String?> stopRecording() async {
    if (!_isRecording) {
      debugPrint('No active recording to stop');
      return null;
    }

    try {
      // Stop amplitude simulation
      _stopAmplitudeSimulation();
      
      // Stop real recording with Record plugin
      await _recorder.stop();
      
      final filePath = _currentFilePath;
      
      // Reset state
      _isRecording = false;
      _currentFilePath = null;
      _recordingStartTime = null;
      
      notifyListeners();
      
      debugPrint('Stopped recording: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      
      // Reset state on error
      _isRecording = false;
      _currentFilePath = null;
      _recordingStartTime = null;
      _stopAmplitudeSimulation();
      
      notifyListeners();
      return null;
    }
  }

  // Cancel recording
  Future<void> cancelRecording() async {
    if (_isRecording && _currentFilePath != null) {
      try {
        // Stop recording without saving
        await _recorder.stop();
        
        // Delete the file if it exists
        final file = File(_currentFilePath!);
        if (await file.exists()) {
          await file.delete();
        }
        
        debugPrint('Cancelled recording and deleted file: $_currentFilePath');
      } catch (e) {
        debugPrint('Error cancelling recording: $e');
      }
    }

    // Stop amplitude simulation
    _stopAmplitudeSimulation();
    
    // Reset state
    _isRecording = false;
    _currentFilePath = null;
    _recordingStartTime = null;
    
    notifyListeners();
  }

  // Get recording duration
  Duration? getRecordingDuration() {
    if (_isRecording && _recordingStartTime != null) {
      return DateTime.now().difference(_recordingStartTime!);
    }
    return null;
  }

  // Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      debugPrint('Error checking file existence: $e');
      return false;
    }
  }

  // Amplitude simulation methods
  void _startAmplitudeSimulation() {
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRecording) {
        // Generate simulated amplitude data (0.0 to 1.0)
        final random = Random();
        final amplitude = random.nextDouble() * 0.8; // 0.0 to 0.8
        _amplitudeController.add(amplitude);
      } else {
        timer.cancel();
      }
    });
  }

  void _stopAmplitudeSimulation() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    // Add final zero amplitude to stop visualization
    _amplitudeController.add(0.0);
  }

  // Clean up resources
  @override
  void dispose() {
    _stopAmplitudeSimulation();
    _amplitudeController.close();
    if (_isRecording) {
      _isRecording = false;
      _currentFilePath = null;
      _recordingStartTime = null;
    }
    super.dispose();
  }
}