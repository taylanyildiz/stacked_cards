import 'dart:ui';

import 'package:flutter/material.dart';

import 'perspective_items.dart';

class StackedListLayout extends StatefulWidget {
  const StackedListLayout({
    Key? key,
    required this.children,
    this.controller,
    this.onChangeItem,
    this.itemExtent,
    int? visualized,
    int? initial,
    EdgeInsetsGeometry? padding,
  })  : visualized = visualized ?? 7,
        initial = initial ?? children.length,
        padding = padding ?? const EdgeInsets.all(10.0),
        super(key: key);

  final List<Widget> children;
  final StackedListController? controller;
  final double? itemExtent;
  final int visualized;
  final int initial;
  final EdgeInsetsGeometry padding;
  final Function(int value)? onChangeItem;

  @override
  State<StackedListLayout> createState() => StackedLayoutState();
}

class StackedLayoutState extends State<StackedListLayout> {
  late PageController _pageController;
  double _page = 0.0;
  double _offset = 0.0;
  int _currentIndex = 0;
  double _pagePercent = 0.0;

  StackedListController? get _stackedListController => widget.controller;

  List<Widget> get _children => widget.children;
  int get _length => _children.length;

  double? get _itemExtent => widget.itemExtent;

  int get _visualized => widget.visualized;
  int get _initial => widget.initial;
  EdgeInsetsGeometry get _padding => widget.padding;

  @override
  void initState() {
    _currentIndex = _initial;
    _pageController =
        PageController(initialPage: _initial, viewportFraction: 1 / _visualized)
          ..addListener(_pageListener);
    super.initState();
  }

  void _pageListener() {
    _currentIndex = _pageController.page?.floor() ?? 0;
    _page = _pageController.page ?? 0.0;
    _offset = _pageController.offset;
    _pagePercent = (_page - _currentIndex).abs();
  }

  void _onPageChanged(int page) {
    widget.onChangeItem?.call(page);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildPageView,
        _buildGhostPageView,
        _buildShadow,
      ],
    );
  }

  Widget get _buildGhostPageView {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _length,
      physics: const BouncingScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemBuilder: (_, index) => const SizedBox(),
    );
  }

  Widget get _buildPageView {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return Padding(
            padding: _padding,
            child: LayoutBuilder(
              builder: ((context, constraints) {
                double height = constraints.maxHeight;
                return Stack(
                  fit: StackFit.expand,
                  children: _buildLayoutList(height),
                );
              }),
            ),
          );
        });
  }

  List<Widget> _buildLayoutList(double height) {
    double itemExtent = _itemExtent ?? height * .33;
    int generatedItems = _visualized - 1;
    final list = List.generate(generatedItems, (index) {
      int invertedIndex = (generatedItems - 2) - index;
      int increasedIndex = index + 1;
      double position = increasedIndex / generatedItems;
      double endPosition = index / generatedItems;
      if (_currentIndex > invertedIndex) {
        return PerspectiveItems(
          listenable: _pageController,
          child: _children[_currentIndex - (invertedIndex + 1)],
          height: itemExtent,
          factoryChange: _pagePercent,
          scale: lerpDouble(.5, 1.0, position),
          endScale: lerpDouble(.5, 1.0, endPosition),
          translateY: (height - itemExtent) * position,
          endTranslateY: (height - itemExtent) * endPosition,
        );
      }
      return const SizedBox();
    });
    if (_currentIndex < (_length - 1)) {
      list.add(PerspectiveItems(
        listenable: _pageController,
        child: _children[_currentIndex + 1],
        height: itemExtent,
        factoryChange: _pagePercent,
        translateY: (height + 40.0),
        endTranslateY: (height - itemExtent),
      ));
    }
    if (_currentIndex > (generatedItems - 1)) {
      list.insert(
        0,
        PerspectiveItems(
          listenable: _pageController,
          child: _children[_currentIndex - generatedItems],
          factoryChange: 1.0,
          height: itemExtent,
          translateY: (height + 40.0),
          endScale: .5,
        ),
      );
    }
    return list;
  }

  Widget get _buildShadow {
    return IgnorePointer(
      ignoring: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black38,
                  Colors.transparent,
                ],
                begin: FractionalOffset(0.5, 0.0),
                end: FractionalOffset(0.5, 1.0),
                stops: [0.1, 0.3],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StackedListController extends ChangeNotifier {
  //
}
