import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final double value;
  final Function(double) onChanged;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _radius;

  @override
  void initState() {
    super.initState();
    _radius = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _radius,
      min: 0,
      max: 5000,
      divisions: 10,
      onChanged: (double value) {
        setState(() {
          _radius = value;
        });
        widget.onChanged(value);
      },
      activeColor: Color(0xFFF5C518),
    );
  }
}
