import 'dart:ui';

import 'package:flutter/material.dart';

abstract class TranstionableWidget extends AnimatedWidget {
  const TranstionableWidget({
    Key? key,
    required Listenable listenable,
    required this.height,
    required this.factoryChange,
    double? scale,
    double? endScale,
    double? translateY,
    double? endTranslateY,
  })  : scale = scale ?? 1.0,
        endScale = endScale ?? 1.0,
        translateY = translateY ?? 0.0,
        endTranslateY = endTranslateY ?? 0.0,
        super(key: key, listenable: listenable);

  final double height;

  final double factoryChange;

  final double scale;

  final double endScale;

  final double translateY;

  final double endTranslateY;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..scale(lerpDouble(scale, endScale, factoryChange))
          ..translate(
            0.0,
            lerpDouble(translateY, endTranslateY, factoryChange)!,
            0.0,
          ),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: builder(context),
          ),
        ),
      ),
    );
  }

  @protected
  Widget builder(BuildContext context);
}

class PerspectiveItems extends TranstionableWidget {
  const PerspectiveItems({
    Key? key,
    required Listenable listenable,
    required double height,
    required double factoryChange,
    required this.child,
    double? scale,
    double? endScale,
    double? translateY,
    double? endTranslateY,
  }) : super(
          key: key,
          listenable: listenable,
          height: height,
          factoryChange: factoryChange,
          scale: scale,
          endScale: endScale,
          translateY: translateY,
          endTranslateY: endTranslateY,
        );

  final Widget child;

  @override
  Widget builder(BuildContext context) => child;
}
