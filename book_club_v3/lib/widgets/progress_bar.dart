import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProgressBar extends StatelessWidget {
  final double bookPercentage;
  final bool isAdmin;

  ProgressBar(this.isAdmin, [this.bookPercentage = 0.0]);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    startAngle: 270,
                    endAngle: 270,
                    radiusFactor: 1.2,
                    showLabels: false,
                    showTicks: false,
                    useRangeColorForAxis: true,
                    showAxisLine: false,

                    // axisLineStyle: AxisLineStyle(
                    //   thickness: 0.15,
                    //   color: Colors.blueGrey,
                    //   thicknessUnit: GaugeSizeUnit.factor,
                    // ),

                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 100,
                          color: Theme.of(context).cardColor)
                    ],
                    pointers: <RangePointer>[
                      RangePointer(
                        value: bookPercentage,
                        gradient: const SweepGradient(colors: <Color>[
                          Color(0xFF783CB8),
                          Color(0xFFFF3D27),
                        ], stops: <double>[
                          0.25,
                          0.75
                        ]),
                        enableAnimation: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
