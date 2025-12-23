import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/timeline_item.dart';

class TimelineProvider extends ChangeNotifier {
  final List<TimelineItem> _timelineItems = [];
  final Uuid _uuid;

  TimelineProvider({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  // Getters
  List<TimelineItem> get timelineItems => List.unmodifiable(_timelineItems);
  List<TimelineItem> get audioRecordings => _timelineItems
      .where((item) => item.type == TimelineType.voiceMemo)
      .toList();

  // Add a new timeline item
  void addTimelineItem(TimelineItem item) {
    _timelineItems.insert(0, item); // Add to the beginning (newest first)
    notifyListeners();
  }

  // Add audio recording
  void addAudioRecording(String filePath, {String? title, String? summary}) {
    final audioItem = TimelineItem(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      title: title ?? 'Voice Memo',
      summary: summary,
      type: TimelineType.voiceMemo,
      metadata: {
        'filePath': filePath,
        'fileName': _getFileNameFromPath(filePath),
        'duration': _getRecordingDuration(filePath),
        'size': _getFileSize(filePath),
        'format': _getFileExtension(filePath),
      },
    );
    
    addTimelineItem(audioItem);
  }

  // Remove timeline item
  void removeTimelineItem(String id) {
    final index = _timelineItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      // If it's an audio recording, delete the file
      final item = _timelineItems[index];
      if (item.type == TimelineType.voiceMemo && item.metadata != null) {
        _deleteAudioFile(item.metadata!['filePath'] as String?);
      }
      
      _timelineItems.removeAt(index);
      notifyListeners();
    }
  }

  // Update timeline item
  void updateTimelineItem(String id, TimelineItem updatedItem) {
    final index = _timelineItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _timelineItems[index] = updatedItem;
      notifyListeners();
    }
  }

  // Toggle favorite status
  void toggleFavorite(String id) {
    final index = _timelineItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _timelineItems[index];
      _timelineItems[index] = item.copyWith(isFavorite: !item.isFavorite);
      notifyListeners();
    }
  }

  // Get timeline item by ID
  TimelineItem? getTimelineItemById(String id) {
    try {
      return _timelineItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter timeline items by type
  List<TimelineItem> getItemsByType(TimelineType type) {
    return _timelineItems.where((item) => item.type == type).toList();
  }

  // Search timeline items
  List<TimelineItem> searchItems(String query) {
    if (query.isEmpty) return List.from(_timelineItems);
    
    return _timelineItems.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
             (item.summary?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Sort timeline items
  void sortTimelineItems({bool descending = true}) {
    _timelineItems.sort((a, b) {
      final comparison = a.timestamp.compareTo(b.timestamp);
      return descending ? -comparison : comparison;
    });
    notifyListeners();
  }

  // Get total count of audio recordings
  int get audioRecordingsCount => _timelineItems
      .where((item) => item.type == TimelineType.voiceMemo)
      .length;

  // Clear all timeline items
  void clearAllItems() {
    // Delete all audio files first
    for (final item in _timelineItems) {
      if (item.type == TimelineType.voiceMemo && item.metadata != null) {
        _deleteAudioFile(item.metadata!['filePath'] as String?);
      }
    }
    
    _timelineItems.clear();
    notifyListeners();
  }

  // Helper methods
  String _getFileNameFromPath(String filePath) {
    return filePath.split('/').last;
  }

  String _getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  int _getFileSize(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        return file.lengthSync();
      }
    } catch (e) {
      debugPrint('Error getting file size: $e');
    }
    return 0;
  }

  String _getRecordingDuration(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        file.statSync();
        // For now, return a placeholder duration
        // In real implementation, you'd parse the audio file for actual duration
        return '00:00'; // Placeholder
      }
    } catch (e) {
      debugPrint('Error getting recording duration: $e');
    }
    return '00:00';
  }

  void _deleteAudioFile(String? filePath) async {
    if (filePath != null && filePath.isNotEmpty) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Deleted audio file: $filePath');
        }
      } catch (e) {
        debugPrint('Error deleting audio file: $e');
      }
    }
  }

  // Export timeline data (for future use)
  Map<String, dynamic> exportData() {
    return {
      'items': _timelineItems.map((item) => {
        'id': item.id,
        'timestamp': item.timestamp.toIso8601String(),
        'title': item.title,
        'summary': item.summary,
        'type': item.type.toString(),
        'participants': item.participants,
        'generatedToDos': item.generatedToDos,
        'isFavorite': item.isFavorite,
        'metadata': item.metadata,
      }).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  // Import timeline data (for future use)
  void importData(Map<String, dynamic> data) {
    try {
      final items = data['items'] as List;
      _timelineItems.clear();
      
      for (final itemData in items) {
        final item = TimelineItem(
          id: itemData['id'],
          timestamp: DateTime.parse(itemData['timestamp']),
          title: itemData['title'],
          summary: itemData['summary'],
          type: TimelineType.values.firstWhere(
            (e) => e.toString() == itemData['type'],
          ),
          participants: List<String>.from(itemData['participants'] ?? []),
          generatedToDos: List<String>.from(itemData['generatedToDos'] ?? []),
          isFavorite: itemData['isFavorite'] ?? false,
          metadata: itemData['metadata'],
        );
        _timelineItems.add(item);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error importing data: $e');
    }
  }
}