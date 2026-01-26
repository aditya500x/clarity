import 'package:flutter/material.dart';
import '../config/constants.dart';
import 'audio_recorder_widget.dart';
import 'image_picker_widget.dart';

/// Tab-based input widget with Text, Audio, and Image tabs
class TabInputWidget extends StatefulWidget {
  final Function(String inputData, String inputMethod) onSubmit;
  final String textHint;
  final String textLabel;
  final int maxLines;
  
  const TabInputWidget({
    super.key,
    required this.onSubmit,
    this.textHint = 'Enter text here...',
    this.textLabel = 'Enter text',
    this.maxLines = 4,
  });
  
  @override
  State<TabInputWidget> createState() => _TabInputWidgetState();
}

class _TabInputWidgetState extends State<TabInputWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  String? _audioData;
  String? _imageData;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    final currentIndex = _tabController.index;
    
    if (currentIndex == 0) {
      // Text tab
      final text = _textController.text.trim();
      if (text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter some text')),
        );
        return;
      }
      widget.onSubmit(text, AppConstants.inputMethodText);
    } else if (currentIndex == 1) {
      // Audio tab
      if (_audioData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please record audio first')),
        );
        return;
      }
      widget.onSubmit(_audioData!, AppConstants.inputMethodAudio);
    } else if (currentIndex == 2) {
      // Image tab
      if (_imageData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image first')),
        );
        return;
      }
      widget.onSubmit(_imageData!, AppConstants.inputMethodImage);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            tabs: const [
              Tab(text: 'Text', icon: Icon(Icons.text_fields)),
              Tab(text: 'Audio', icon: Icon(Icons.mic)),
              Tab(text: 'Image', icon: Icon(Icons.image)),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Text tab
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: widget.textLabel,
                      hintText: widget.textHint,
                    ),
                    maxLines: widget.maxLines,
                  ),
                ],
              ),
              
              // Audio tab
              AudioRecorderWidget(
                onRecordingComplete: (audioData) {
                  setState(() {
                    _audioData = audioData;
                  });
                },
              ),
              
              // Image tab
              ImagePickerWidget(
                onImageSelected: (imageData) {
                  setState(() {
                    _imageData = imageData;
                  });
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Submit button
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
