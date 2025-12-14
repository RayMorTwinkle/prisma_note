import 'package:flutter/material.dart';

class SoundWaveVisualizer extends StatefulWidget {
  const SoundWaveVisualizer({super.key});

  @override
  State<SoundWaveVisualizer> createState() => _SoundWaveVisualizerState();
}

class _SoundWaveVisualizerState extends State<SoundWaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _waveAnimations;
  final List<double> _waveHeights = [0.3, 0.7, 0.4, 0.9, 0.2, 0.8, 0.5];
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _waveAnimations = _waveHeights
        .map((height) => Tween<double>(
              begin: 0.1,
              end: height,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            )))
        .toList();
    
    _startAnimation();
  }

  void _startAnimation() {
    if (_isListening) {
      _animationController.repeat(reverse: true);
    }
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
    
    if (_isListening) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleListening,
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: _isListening ? Colors.black : Colors.grey[300]!,
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
                        color: _isListening 
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
                color: _isListening ? Colors.red : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}