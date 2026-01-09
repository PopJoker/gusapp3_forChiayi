import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum TutorType { video, document, markdown }
enum VideoSource { network, asset, file }

class TutorItem extends StatefulWidget {
  final String title;
  final String description; // 簡短文字描述
  final String? videoPath; // 如果是影片才需要
  final VideoSource? source; // 如果是影片才需要
  final String? documentUrl; // 如果是文件才需要
  final String? markdownContent; // 如果是 Markdown 教學才需要
  final TutorType type;

  const TutorItem({
    super.key,
    required this.title,
    required this.description,
    this.videoPath,
    this.source,
    this.documentUrl,
    this.markdownContent,
    this.type = TutorType.video,
  });

  @override
  State<TutorItem> createState() => _TutorItemState();
}

class _TutorItemState extends State<TutorItem> {
  VideoPlayerController? _controller;
  bool _isExpanded = false;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == TutorType.video &&
        widget.videoPath != null &&
        widget.source != null) {
      _initializeController();
    }
  }

  void _initializeController() {
    switch (widget.source!) {
      case VideoSource.network:
        _controller = VideoPlayerController.network(widget.videoPath!);
        break;
      case VideoSource.asset:
        _controller = VideoPlayerController.asset(widget.videoPath!);
        break;
      case VideoSource.file:
        _controller = VideoPlayerController.file(File(widget.videoPath!));
        break;
    }

    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isControllerInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (widget.type == TutorType.video && _controller != null) {
      content = AspectRatio(
        aspectRatio: _isControllerInitialized
            ? _controller!.value.aspectRatio
            : 16 / 9,
        child: _isControllerInitialized
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller!),
                  _ControlsOverlay(controller: _controller!),
                  VideoProgressIndicator(_controller!, allowScrubbing: true),
                ],
              )
            : Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
      );
    } else if (widget.type == TutorType.document) {
      content = ElevatedButton(
        onPressed: () {
          // 文件打開功能自行實作
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('文件打開功能可自行實作')),
          );
        },
        child: const Text("打開文件"),
      );
    } else if (widget.type == TutorType.markdown && widget.markdownContent != null) {
      content = SizedBox(
        height: 300, // 可自行調整高度
        child: Markdown(
          data: widget.markdownContent!,
          selectable: true,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
              .copyWith(p: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ExpansionTile(
        title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(widget.description, style: Theme.of(context).textTheme.bodyMedium),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
              if (!_isExpanded) _controller?.pause();
            });
          },
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [content],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  const _ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Center(
        child: controller.value.isPlaying
            ? const SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 60),
              ),
      ),
    );
  }
}
