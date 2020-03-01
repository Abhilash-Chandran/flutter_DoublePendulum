import 'package:flutter/material.dart';

typedef Callback = void Function(double newValue);

class SliderWithLabel extends StatefulWidget {
  final String widgetLabel;
  final int division;
  final double min;
  final double max;
  final Callback callBack;
  final int showNDecimal;
  final double initialValue;

  SliderWithLabel({
    this.widgetLabel,
    this.division,
    @required this.min,
    @required this.max,
    @required this.callBack,
    @required this.initialValue,
    this.showNDecimal = 1,
  });

  @override
  _SliderWithLabelState createState() => _SliderWithLabelState();
}

class _SliderWithLabelState extends State<SliderWithLabel> {
  double value;
  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(widget.widgetLabel + value.toStringAsFixed(widget.showNDecimal)),
          Slider(
              divisions: widget.division,
              value: value,
              min: widget.min,
              max: widget.max,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                  widget.callBack(newValue);
                });
              }),
        ],
      ),
    );
  }
}
