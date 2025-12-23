import 'dart:async';
import 'package:flutter/material.dart';

class SoundWaveVisualizer extends StatefulWidget {
  final bool isActive;
  final Stream<double>? amplitudeStream;

  const SoundWaveVisualizer({
    super.key,
    this.isActive = false,
    this.amplitudeStream,
  });

  @override
  State<SoundWaveVisualizer> createState() => _SoundWaveVisualizerState();
}

class _SoundWaveVisualizerState extends State<SoundWaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _waveAnimations;
  final List<double> _baseHeights = [0.3, 0.7, 0.4, 0.9, 0.2, 0.8, 0.5];
  StreamSubscription<double>? _amplitudeSubscription;
  final List<double> _currentAmplitudes = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _updateAnimations();
    
    if (widget.isActive) {
      _startAnimation();
    }
    
    // Listen to amplitude stream if provided
    if (widget.amplitudeStream != null) {
      _amplitudeSubscription = widget.amplitudeStream!.listen(_updateAmplitudes);
    }
  }

  @override
  void didUpdateWidget(SoundWaveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startAnimation();
      } else {
        _animationController.stop();
        _animationController.reset();
        _resetAmplitudes();
      }
    }
    
    if (widget.amplitudeStream != oldWidget.amplitudeStream) {
      _amplitudeSubscription?.cancel();
      if (widget.amplitudeStream != null) {
        _amplitudeSubscription = widget.amplitudeStream!.listen(_updateAmplitudes);
      }
    }
  }

  void _updateAmplitudes(double amplitude) {
    // Convert single amplitude to multiple bar heights with some variation
    final normalizedAmplitude = (amplitude * 10).clamp(0.0, 1.0);
    
    setState(() {
      for (int i = 0; i < _currentAmplitudes.length; i++) {
        final variation = (i * 0.1) % 0.3; // Different variation for each bar
        _currentAmplitudes[i] = (normalizedAmplitude * _baseHeights[i] + variation)
            .clamp(0.0, 1.0);
      }
    });
    
    _updateAnimations();
  }

  void _updateAnimations() {
    _waveAnimations = _currentAmplitudes
        .map((height) => Tween<double>(
              begin: 0.05,
              end: height,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            )))
        .toList();
  }

  void _resetAmplitudes() {
    setState(() {
      for (int i = 0; i < _currentAmplitudes.length; i++) {
        _currentAmplitudes[i] = _baseHeights[i];
      }
    });
    _updateAnimations();
  }

  void _startAnimation() {
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isActive ? Colors.black : Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sound wave bars
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(7, (index) {
              return AnimatedBuilder(
                animation: _waveAnimations[index],
                builder: (context, child) {
                  return Container(
                    width: 3,
                    height: 20 * _waveAnimations[index].value,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: widget.isActive 
                          ? Colors.black 
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(width: 8),
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.isActive ? Colors.red : Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}