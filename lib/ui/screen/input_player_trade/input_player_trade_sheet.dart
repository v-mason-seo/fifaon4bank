import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class InputPlayerTradeSheet extends StatefulWidget {
  InputPlayerTradeSheetState createState() => InputPlayerTradeSheetState();
}


class InputPlayerTradeSheetState extends State<InputPlayerTradeSheet> {

  static const mapsBlue = Color(0xFF4185F3);
  static const textStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'sans-serif-medium',
    fontSize: 15,
  );

  ValueNotifier<SheetState> sheetState = ValueNotifier(SheetState.inital());
  SheetState get state => sheetState.value;
  set state(SheetState value) => sheetState.value = value;

  BuildContext context;
  SheetController controller;

  bool get isExpanded => state?.isExpanded ?? false;
  bool get isCollapsed => state?.isCollapsed ?? true;
  double get progress => state?.progress ?? 0.0;

  bool tapped = false;
  bool show = false;

  @override
  void initState() {
    super.initState();
    controller = SheetController();
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => setState(() => tapped = !tapped),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: tapped ? 200 : 0,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: buildSheet(),
          ),
        ],
      ),
    );
  }


  Widget buildSheet() {
    return SlidingSheet(
      duration: const Duration(milliseconds: 900),
      controller: controller,
      color: Colors.white,
      shadowColor: Colors.black26,
      elevation: 12,
      maxWidth: 500,
      cornerRadius: 16,
      cornerRadiusOnFullscreen: 0.0,
      closeOnBackdropTap: true,
      closeOnBackButtonPressed: true,
      addTopViewPaddingOnFullscreen: true,
      isBackdropInteractable: true,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 3,
      ),
      snapSpec: SnapSpec(
        snap: true,
        positioning: SnapPositioning.relativeToAvailableSpace,
        snappings: const [
          SnapSpec.headerFooterSnap,
          0.6,
          SnapSpec.expanded,
        ],
        onSnap: (state, snap) {
          //print('Snapped to $snap');
        },
      ),
      parallaxSpec: const ParallaxSpec(
        enabled: true,
        amount: 0.35,
        endExtent: 0.6,
      ),
      listener: (state) {
        final needsRebuild = (this.state?.isCollapsed != state.isCollapsed) ||
            (this.state.isExpanded != state.isExpanded) ||
            (this.state.isAtTop != state.isAtTop) ||
            (this.state.isAtBottom != state.isAtBottom);
        this.state = state;

        if (needsRebuild) {
          setState(() {});
        }
      },
      body: _buildBody(),
      headerBuilder: buildHeader,
      footerBuilder: buildFooter,
      builder: buildChild,
    );
  }


  Widget buildHeader(BuildContext context, SheetState state) {
    return CustomContainer(
      animate: true,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      elevation: !state.isAtTop ? 4 : 0,
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder(
              valueListenable: sheetState,
              builder: (context, state, _) {
                return CustomContainer(
                  width: 16,
                  height: 4,
                  borderRadius: 2,
                  color: Colors.grey
                      .withOpacity(.5 * (1 - interval(0.7, 1.0, state.progress))),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                '5h 36m',
                style: textStyle.copyWith(
                  color: const Color(0xFFF0BA64),
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(353 mi)',
                style: textStyle.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Fastest route now due to traffic conditions.',
            style: textStyle.copyWith(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildFooter(BuildContext context, SheetState state) {
    Widget button(
      Icon icon,
      Text text,
      VoidCallback onTap, {
      BorderSide border,
      Color color,
    }) {
      final child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          const SizedBox(width: 8),
          text,
        ],
      );

      const shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      );

      return border == null
          ? RaisedButton(
              color: color,
              onPressed: onTap,
              elevation: 2,
              shape: shape,
              child: child,
            )
          : OutlineButton(
              color: color,
              onPressed: onTap,
              borderSide: border,
              shape: shape,
              child: child,
            );
    }

    return CustomContainer(
      animate: true,
      elevation: !isCollapsed && !state.isAtBottom ? 4 : 0,
      shadowDirection: ShadowDirection.top,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shadowColor: Colors.black12,
      child: Row(
        children: <Widget>[
          button(
            Icon(
              Icons.navigation,
              color: Colors.white,
            ),
            Text(
              'Start',
              style: textStyle.copyWith(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            () async {
              // Inherit from context...
              await SheetController.of(context).hide();
              Future.delayed(const Duration(milliseconds: 1500), () {
                // or use the controller
                controller.show();
              });
            },
            color: mapsBlue,
          ),
          const SizedBox(width: 8),
          button(
            Icon(
              !isExpanded ? Icons.list : Icons.map,
              color: mapsBlue,
            ),
            Text(
              !isExpanded ? 'Steps & more' : 'Show map',
              style: textStyle.copyWith(
                fontSize: 15,
              ),
            ),
            !isExpanded
                ? () => controller.scrollTo(state.maxScrollExtent)
                : controller.collapse,
            color: Colors.white,
            border: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChild(BuildContext context, SheetState state) {
    final divider = Container(
      height: 1,
      color: Colors.grey.shade300,
    );

    final titleStyle = textStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        divider,
        const SizedBox(height: 32),
        InkWell(
          onTap: () => setState(() => show = !show),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Traffic',
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                buildChart(context),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        divider,
        TextField(
          keyboardType: TextInputType.number,
        ),
        divider,
        const SizedBox(height: 32),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: padding,
              child: Text(
                'Steps',
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 8),
            buildSteps(context),
          ],
        ),
        const SizedBox(height: 32),
        divider,
        const SizedBox(height: 32),
        Icon(
          Icons.group,
          color: Colors.grey.shade900,
          size: 48,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Pull request are welcome!',
            style: textStyle.copyWith(
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: Text(
            '(Stars too)',
            style: textStyle.copyWith(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget buildSteps(BuildContext context) {
    final steps = [
      Step('Go to your pubspec.yaml file.', '2 seconds'),
      Step(
          "Add the newest version of 'sliding_sheet' to your dependencies.", '5 seconds'),
      Step("Run 'flutter packages get' in the terminal.", '4 seconds'),
      Step("Happy coding!", 'Forever'),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, i) {
        final step = steps[i];

        return Padding(
          padding: const EdgeInsets.fromLTRB(56, 16, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                step.instruction,
                style: textStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Text(
                    '${step.time}',
                    style: textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget buildChart(BuildContext context) {
    final series = [
      charts.Series<Traffic, String>(
        id: 'traffic',
        data: [
          Traffic(0.5, '14:00'),
          Traffic(0.6, '14:30'),
          Traffic(0.5, '15:00'),
          Traffic(0.7, '15:30'),
          Traffic(0.8, '16:00'),
          Traffic(0.6, '16:30'),
        ],
        colorFn: (traffic, __) {
          if (traffic.time == '14:30') return charts.Color.fromHex(code: '#F0BA64');
          return charts.MaterialPalette.gray.shade300;
        },
        domainFn: (Traffic traffic, _) => traffic.time,
        measureFn: (Traffic traffic, _) => traffic.intesity,
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: show ? 256 : 128,
      color: Colors.transparent,
      child: charts.BarChart(
        series,
        animate: true,
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.gray.shade500,
            ),
          ),
        ),
        defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(5),
        ),
      ),
    );
  }

  Future<void> showBottomSheetDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final controller = SheetController();
    bool isDismissable = false;

    await showSlidingBottomSheet(
      context,
      // The parentBuilder can be used to wrap the sheet inside a parent.
      // This can be for example a Theme or an AnnotatedRegion.
      parentBuilder: (context, sheet) {
        return Theme(
          data: ThemeData.dark(),
          child: sheet,
        );
      },
      // The builder to build the dialog. Calling rebuilder on the dialogController
      // will call the builder, allowing react to state changes while the sheet is shown.
      builder: (context) {
        return SlidingSheetDialog(
          controller: controller,
          duration: const Duration(milliseconds: 500),
          snapSpec: const SnapSpec(
            snap: true,
            initialSnap: 0.7,
            snappings: [
              0.3,
              0.7,
            ],
          ),
          scrollSpec: const ScrollSpec(
            showScrollbar: true,
          ),
          color: Colors.teal,
          maxWidth: 500,
          minHeight: 700,
          isDismissable: isDismissable,
          dismissOnBackdropTap: true,
          isBackdropInteractable: true,
          onDismissPrevented: (backButton, backDrop) async {
            //HapticFeedback.heavyImpact();

            if (backButton || backDrop) {
              const duration = Duration(milliseconds: 300);
              await controller.snapToExtent(0.2, duration: duration, clamp: false);
              await controller.snapToExtent(0.4, duration: duration);
              // or Navigator.pop(context);
            }

            // Or pop the route
            // if (backButton) {
            //   Navigator.pop(context);
            // }

            //print('Dismiss prevented');
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Confirm purchase',
                    style: textTheme.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sagittis tellus lacus, et pulvinar orci eleifend in.',
                          style: textTheme.subtitle1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Icon(
                        isDismissable ? Icons.check : Icons.error,
                        color: Colors.white,
                        size: 56,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          footerBuilder: (context, state) {
            return Container(
              color: Colors.teal.shade700,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: textTheme.subtitle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FlatButton(
                    onPressed: () {
                      if (!isDismissable) {
                        isDismissable = true;
                        SheetController.of(context).rebuild();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Approve',
                      style: textTheme.subtitle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        buildMap(),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top + 16, 16, 0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                await showBottomSheetDialog(context);
              },
              child: Icon(
                Icons.layers,
                color: mapsBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMap() {
    return GestureDetector(
      onTap: () => setState(() => tapped = !tapped),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/maps_screenshot.png',
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 56),
        ],
      ),
    );
  }










}



class Step {
  final String instruction;
  final String time;
  Step(
    this.instruction,
    this.time,
  );
}

class Traffic {
  final double intesity;
  final String time;
  Traffic(
    this.intesity,
    this.time,
  );
}



double interval(double lower, double upper, double progress) {
  assert(lower < upper);

  if (progress > upper) return 1.0;
  if (progress < lower) return 0.0;

  return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
}

void postFrame(void Function() callback) => WidgetsBinding.instance.addPostFrameCallback((_) => callback());




enum ShadowDirection {
  topLeft,
  top,
  topRight,
  right,
  bottomRight,
  bottom,
  bottomLeft,
  left,
  center,
}

class CustomContainer extends StatelessWidget {
  final double borderRadius;
  final double elevation;
  final double height;
  final double width;
  final Border border;
  final BorderRadius customBorders;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;
  final Color color;
  final Color shadowColor;
  final List<BoxShadow> boxShadows;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDoubleTap;
  final BoxShape boxShape;
  final AlignmentGeometry alignment;
  final ShadowDirection shadowDirection;
  final Color rippleColor;
  final bool animate;
  final Duration duration;
  CustomContainer({
    Key key,
    this.child,
    this.border,
    this.color = Colors.transparent,
    this.borderRadius = 0.0,
    this.elevation = 0.0,
    this.rippleColor,
    this.shadowColor = Colors.black12,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.height,
    this.width,
    this.margin,
    this.customBorders,
    this.alignment,
    this.boxShadows,
    this.animate = false,
    this.duration = const Duration(milliseconds: 200),
    this.boxShape = BoxShape.rectangle,
    this.shadowDirection = ShadowDirection.bottomRight,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  static const double WRAP = -1;
  static const double EXPAND = -2;

  bool get circle => boxShape == BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = width == null || width == EXPAND ? double.infinity : width == WRAP ? null : width;
    final h = height == EXPAND ? double.infinity : height;
    final br = customBorders ??
        BorderRadius.circular(
          boxShape == BoxShape.rectangle ? borderRadius : w != null ? w / 2.0 : h != null ? h / 2.0 : 0,
        );

    Widget content = Padding(
      padding: padding,
      child: child,
    );

    if (boxShape == BoxShape.circle || (customBorders != null || borderRadius > 0.0)) {
      content = ClipRRect(
        borderRadius: br,
        child: content,
      );
    }

    content = Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      shape: circle ? CircleBorder() : RoundedRectangleBorder(borderRadius: br),
      child: InkWell(
        splashColor: onTap != null ? rippleColor ?? theme.splashColor : Colors.transparent,
        customBorder: circle ? CircleBorder() : RoundedRectangleBorder(borderRadius: br),
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: content,
      ),
    );

    final List<BoxShadow> boxShadow = boxShadows ?? elevation != 0
        ? [
            BoxShadow(
              color: shadowColor ?? Colors.black12,
              offset: _getShadowOffset(min(elevation / 5.0, 1.0)),
              blurRadius: elevation,
              spreadRadius: 0,
            ),
          ]
        : const [];

    final boxDecoration = BoxDecoration(
      color: color,
      borderRadius: circle ? null : br,
      shape: boxShape,
      boxShadow: boxShadow,
      border: border,
    );

    return animate
        ? AnimatedContainer(
            height: h,
            width: w,
            margin: margin,
            alignment: alignment,
            duration: duration,
            decoration: boxDecoration,
            child: content,
          )
        : Container(
            height: h,
            width: w,
            margin: margin,
            alignment: alignment,
            decoration: boxDecoration,
            child: content,
          );
  }

  Offset _getShadowOffset(double ele) {
    final ym = 5 * ele;
    final xm = 2 * ele;
    switch (shadowDirection) {
      case ShadowDirection.topLeft:
        return Offset(-1 * xm, -1 * ym);
        break;
      case ShadowDirection.top:
        return Offset(0, -1 * ym);
        break;
      case ShadowDirection.topRight:
        return Offset(xm, -1 * ym);
        break;
      case ShadowDirection.right:
        return Offset(xm, 0);
        break;
      case ShadowDirection.bottomRight:
        return Offset(xm, ym);
        break;
      case ShadowDirection.bottom:
        return Offset(0, ym);
        break;
      case ShadowDirection.bottomLeft:
        return Offset(-1 * xm, ym);
        break;
      case ShadowDirection.left:
        return Offset(-1 * xm, 0);
        break;
      default:
        return Offset.zero;
        break;
    }
  }
}