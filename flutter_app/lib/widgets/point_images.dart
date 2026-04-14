import 'package:flutter/material.dart';

class PointImagesCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final double height;

  const PointImagesCarousel({
    super.key,
    required this.imagePaths,
    this.height = 300,
  });

  @override
  State<PointImagesCarousel> createState() => _PointImagesCarouselState();
}

class _PointImagesCarouselState extends State<PointImagesCarousel> {
  late final PageController _imageController;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      width: double.infinity,
      height: widget.height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: widget.height,
          color: Colors.black12,
          child: const Center(
            child: Icon(Icons.image, size: 50, color: Colors.black54),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) return const SizedBox.shrink();

    if (widget.imagePaths.length == 1) {
      return _buildImage(widget.imagePaths.first);
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _imageController,
            physics: const PageScrollPhysics(),
            itemCount: widget.imagePaths.length,
            onPageChanged: (index) => setState(() => _currentImage = index),
            itemBuilder: (context, index) => _buildImage(widget.imagePaths[index]),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imagePaths.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              width: _currentImage == index ? 24 : 12,
              decoration: BoxDecoration(
                color: _currentImage == index ? Colors.black : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}