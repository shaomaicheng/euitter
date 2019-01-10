import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the RefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the RefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

typedef RefreshCallback = Future<void> Function();

typedef LoadingCallback = Future<void> Function();

typedef OnRefreshStatusCallback = Function(RefreshIndicatorMode mode);

// The state machine moves through these modes only when the scrollable
// identified by scrollableKey has been scrolled to its min or max limit.
enum RefreshIndicatorMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
  loadingDrag,
  loadingArmed,
  loadingSnap,
  loading,
  loadingDone,
  loadingCanceled,
}

/// A widget that supports the Material "swipe to refresh" idiom.
///
/// When the child's [Scrollable] descendant overscrolls, an animated circular
/// progress indicator is faded into view. When the scroll ends, if the
/// indicator has been dragged far enough for it to become completely opaque,
/// the [onRefresh] callback is called. The callback is expected to update the
/// scrollable's contents and then complete the [Future] it returns. The refresh
/// indicator disappears after the callback's [Future] has completed.
///
/// If the [Scrollable] might not have enough content to overscroll, consider
/// settings its `physics` property to [AlwaysScrollableScrollPhysics]:
///
/// ```dart
/// ListView(
///   physics: const AlwaysScrollableScrollPhysics(),
///   children: ...
//  )
/// ```
///
/// Using [AlwaysScrollableScrollPhysics] will ensure that the scroll view is
/// always scrollable and, therefore, can trigger the [EUIRefreshIndicator].
///
/// A [EUIRefreshIndicator] can only be used with a vertical scroll view.
///
/// See also:
///
///  * <https://material.google.com/patterns/swipe-to-refresh.html>
///  * [EUIRefreshIndicatorState], can be used to programmatically show the refresh indicator.
///  * [RefreshProgressIndicator], widget used by [EUIRefreshIndicator] to show
///    the inner circular progress spinner during refreshes.
///  * [CupertinoSliverRefreshControl], an iOS equivalent of the pull-to-refresh pattern.
///    Must be used as a sliver inside a [CustomScrollView] instead of wrapping
///    around a [ScrollView] because it's a part of the scrollable instead of
///    being overlaid on top of it.
class EUIRefreshIndicator extends StatefulWidget {
  /// Creates a refresh indicator.
  ///
  /// The [onRefresh], [child], and [notificationPredicate] arguments must be
  /// non-null. The default
  /// [displacement] is 40.0 logical pixels.
  ///
  /// The [semanticsLabel] is used to specify an accessibility label for this widget.
  /// If it is null, it will be defaulted to [MaterialLocalizations.refreshIndicatorSemanticLabel].
  /// An empty string may be passed to avoid having anything read by screen reading software.
  /// The [semanticsValue] may be used to specify progress on the widget. The
  const EUIRefreshIndicator({
    Key key,
    @required this.child,
    this.maxRefreshHeight = 70.0,
    @required this.onRefresh,
    @required this.onLoad,
    this.refreshWidget,
    this.loadingWidget,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.onRefreshStatusCallback,
    this.refreshController,
    this.loadingController,
  })  : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  final Widget refreshWidget;

  final Widget loadingWidget;

  final RefreshController refreshController;

  final RefreshController loadingController;

  /// The distance from the child's top or bottom edge to where the refresh
  /// indicator will settle. During the drag that exposes the refresh indicator,
  /// its actual displacement may significantly exceed this value.
  final double maxRefreshHeight;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  final LoadingCallback onLoad;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  final OnRefreshStatusCallback onRefreshStatusCallback;

  @override
  EUIRefreshIndicatorState createState() => EUIRefreshIndicatorState();
}

/// Contains the state for a [EUIRefreshIndicator]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class EUIRefreshIndicatorState extends State<EUIRefreshIndicator>
    with TickerProviderStateMixin<EUIRefreshIndicator> {
  AnimationController _positionController;
  AnimationController _loadingPositionController;

  //AnimationController _scaleController;
  Animation<double> _positionFactor;
  Animation<double> _loadingPositionFactor;
  Animation<double> _valueColor;

  RefreshIndicatorMode _mode;
  Future<void> _pendingRefreshFuture;
  bool _isIndicatorAtTop;
  double _dragOffset;

  double _loadingDragOffset;

  double _fingerOffset;

  double _fingerLoadingOffset;

  bool isLoadingHidden = true;

  static final Animatable<double> _kDragSizeFactorLimitTween =
      Tween<double>(begin: 0.0, end: _kDragSizeFactorLimit);
  static final Animatable<double> _kLoadingDragSizeFactorLimitTween =
      Tween<double>(begin: 0.0, end: _kDragSizeFactorLimit);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);

    _loadingPositionController = new AnimationController(vsync: this);
    _loadingPositionFactor =
        _loadingPositionController.drive(_kLoadingDragSizeFactorLimitTween);
    //_scaleController = AnimationController(vsync: this);
    _positionFactor.addListener(() {
      setState(() {
        _fingerOffset = _positionFactor.value;
        //  print("finger::${_fingerOffset}");
        if (widget.refreshController != null) {
          widget.refreshController.percent = _fingerOffset;
        }
      });
    });
    _loadingPositionFactor.addListener(() {
      _fingerLoadingOffset = _loadingPositionFactor.value;
      if (widget.loadingController != null) {
        widget.loadingController.percent = _fingerOffset;
      }
    });
  }

  @override
  void didChangeDependencies() {
    _valueColor = _positionController.drive(
      Tween(begin: 0.0, end: 0.5).chain(
          CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
//      ColorTween(
//              begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
//              end: (widget.color ?? theme.accentColor).withOpacity(1.0))
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _positionController.dispose();
    _loadingPositionController.dispose();
    //_scaleController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) return false;
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0 &&
        _mode == null &&
        _start(notification.metrics.axisDirection)) {
      setState(() {
        _mode = RefreshIndicatorMode.drag;
        _refreshStatusCallback(_mode);
      });
      return false;
    }
    if (notification is ScrollStartNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
        _mode == null &&
        _start(notification.metrics.axisDirection)) {
      //  print("to the bottom!!!!!");
      setState(() {
        _mode = RefreshIndicatorMode.loadingDrag;
        _refreshStatusCallback(_mode);
      });
      return false;
    }

    bool indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }

    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == RefreshIndicatorMode.drag ||
          _mode == RefreshIndicatorMode.armed)
        _dismiss(RefreshIndicatorMode.canceled);
      else if (_mode == RefreshIndicatorMode.loadingDrag ||
          _mode == RefreshIndicatorMode.loadingArmed) {
        _dismiss(RefreshIndicatorMode.loadingCanceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == RefreshIndicatorMode.drag ||
          _mode == RefreshIndicatorMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          _dismiss(RefreshIndicatorMode.canceled);
        } else {
          _dragOffset -= notification.scrollDelta;
          _checkDragOffset(notification.metrics.viewportDimension);
        }
      }
      if (_mode == RefreshIndicatorMode.loadingDrag ||
          _mode == RefreshIndicatorMode.loadingArmed) {
        if (notification.metrics.extentBefore >=
            notification.metrics.maxScrollExtent) {
          _loadingDragOffset+=notification.scrollDelta;
          _checkDragOffset(notification.metrics.viewportDimension);
        } else {
//           _dismiss(_RefreshIndicatorMode.loadingCanceled);

        }
      }

      if (_mode == RefreshIndicatorMode.armed &&
          notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == RefreshIndicatorMode.drag ||
          _mode == RefreshIndicatorMode.armed) {
        var dragPercent = _dragOffset / widget.maxRefreshHeight;
        _dragOffset -= notification.overscroll / 2;
//            (dragPercent < 0.3
//                ? 2.0
//                : dragPercent < 0.5 ? 4.0 : dragPercent < 0.75 ? 8.0 : 16.0);
        _checkDragOffset(notification.metrics.viewportDimension);
      } else if (_mode == RefreshIndicatorMode.loadingDrag ||
          _mode == RefreshIndicatorMode.loadingArmed) {
        //  var dragPercent = _loadingDragOffset / widget.maxRefreshHeight;
        _loadingDragOffset += notification.overscroll;
        isLoadingHidden = false;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case RefreshIndicatorMode.armed:
          _show();
          break;
        case RefreshIndicatorMode.drag:
          _dismiss(RefreshIndicatorMode.canceled);
          break;
        case RefreshIndicatorMode.loadingArmed:
          _showLoading();
          break;
        case RefreshIndicatorMode.loadingDrag:
          _dismiss(RefreshIndicatorMode.loadingCanceled);
          break;
        default:
          // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) return false;
    if (_mode == RefreshIndicatorMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _loadingDragOffset = 0.0;
    //_scaleController.value = 0.0;
    _positionController.value = 0.0;
    _loadingPositionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
//    assert(_mode == _RefreshIndicatorMode.drag ||
//        _mode == _RefreshIndicatorMode.armed);
    if (_mode == RefreshIndicatorMode.drag ||
        _mode == RefreshIndicatorMode.armed) {
      double newValue =
          _dragOffset / (containerExtent * _kDragContainerExtentPercentage);
      if (_mode == RefreshIndicatorMode.armed)
        newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
      _positionController.value =
          newValue.clamp(0.0, 1.0); // this triggers various rebuilds
      if (_mode == RefreshIndicatorMode.drag && _fingerOffset >= 1.0)
        _mode = RefreshIndicatorMode.armed;
      _refreshStatusCallback(_mode);
    } else if (_mode == RefreshIndicatorMode.loadingArmed ||
        _mode == RefreshIndicatorMode.loadingDrag) {
      double newValue = _loadingDragOffset /
          (containerExtent * _kDragContainerExtentPercentage);
      if (_mode == RefreshIndicatorMode.loadingArmed)
        newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
      _loadingPositionController.value = newValue.clamp(0.0, 1.0);
      if (_mode == RefreshIndicatorMode.loadingDrag &&
          _fingerLoadingOffset >= 1.0) {
        _mode = RefreshIndicatorMode.loadingArmed;
        setState(() {
          isLoadingHidden = false;
        });
        _refreshStatusCallback(_mode);
      }
    }
  }

  void _refreshStatusCallback(mode) {
    var callback = widget.onRefreshStatusCallback;
    if (callback != null) {
      callback(mode);
    }
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(RefreshIndicatorMode newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
//    assert(newMode == _RefreshIndicatorMode.canceled ||
//        newMode == _RefreshIndicatorMode.done);
    setState(() {
      _mode = newMode;
      _refreshStatusCallback(_mode);
    });
    switch (_mode) {
      case RefreshIndicatorMode.done:
        await _positionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      case RefreshIndicatorMode.canceled:
        await _positionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      case RefreshIndicatorMode.loadingDone:
        isLoadingHidden = true;
        await _loadingPositionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      case RefreshIndicatorMode.loadingCanceled:
        isLoadingHidden = true;
        await _loadingPositionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _mode == newMode) {
      _dragOffset = null;
      _loadingDragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _mode = null;
      });
    }
  }

  void _show() {
    assert(_mode != RefreshIndicatorMode.refresh);
    assert(_mode != RefreshIndicatorMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = RefreshIndicatorMode.snap;
    _refreshStatusCallback(_mode);

    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _mode == RefreshIndicatorMode.snap) {
        assert(widget.onRefresh != null);
        setState(() {
          // Show the indeterminate progress indicator.
          _mode = RefreshIndicatorMode.refresh;
          _refreshStatusCallback(_mode);
        });

        final Future<void> refreshResult = widget.onRefresh();
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError('The onRefresh callback returned null.\n'
                  'The RefreshIndicator onRefresh callback must return a Future.'),
              context: 'when calling onRefresh',
              library: 'material library',
            ));
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.whenComplete(() {
          if (mounted && _mode == RefreshIndicatorMode.refresh) {
            completer.complete();
            _dismiss(RefreshIndicatorMode.done);
          }
        });
      }
    });
  }

  void _showLoading() {
    //  assert(_mode != _RefreshIndicatorMode.refresh);
    // assert(_mode != _RefreshIndicatorMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = RefreshIndicatorMode.loadingSnap;
    _refreshStatusCallback(_mode);

    _loadingPositionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _mode == RefreshIndicatorMode.loadingSnap) {
        setState(() {
          // Show the indeterminate progress indicator.
          _mode = RefreshIndicatorMode.loading;
          _refreshStatusCallback(_mode);
        });

        final Future<void> refreshResult = widget.onLoad();
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError('The onRefresh callback returned null.\n'
                  'The RefreshIndicator onRefresh callback must return a Future.'),
              context: 'when calling onRefresh',
              library: 'material library',
            ));
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.whenComplete(() {
          if (mounted && _mode == RefreshIndicatorMode.loading) {
            completer.complete();
            _dismiss(RefreshIndicatorMode.loadingDone);
          }
        });
      }
    });
  }

  /// Show the refresh indicator and run the refresh callback as if it had
  /// been started interactively. If this method is called while the refresh
  /// callback is running, it quietly does nothing.
  ///
  /// Creating the [EUIRefreshIndicator] with a [GlobalKey<RefreshIndicatorState>]
  /// makes it possible to refer to the [EUIRefreshIndicatorState].
  ///
  /// The future returned from this method completes when the
  /// [EUIRefreshIndicator.onRefresh] callback's future completes.
  ///
  /// If you await the future returned by this function from a [State], you
  /// should check that the state is still [mounted] before calling [setState].
  ///
  /// When initiated in this manner, the refresh indicator is independent of any
  /// actual scroll view. It defaults to showing the indicator at the top. To
  /// show it at the bottom, set `atTop` to false.
  Future<void> show({bool atTop = true}) {
    if (_mode != RefreshIndicatorMode.refresh &&
        _mode != RefreshIndicatorMode.snap) {
      if (_mode == null) _start(atTop ? AxisDirection.down : AxisDirection.up);
      _show();
    }
    return _pendingRefreshFuture;
  }

  final GlobalKey _key = GlobalKey();

  _headerHeight() {
    return widget.maxRefreshHeight * _fingerOffset;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final Widget child = NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );
    if (_mode == null) {
      assert(_dragOffset == null);
      assert(_isIndicatorAtTop == null);
      return child;
    }
    assert(_dragOffset != null);
    assert(_isIndicatorAtTop != null);

    final bool showIndeterminateIndicator =
        _mode == RefreshIndicatorMode.refresh ||
            _mode == RefreshIndicatorMode.done;

    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: _headerHeight(),
                child: OverflowBox(
//                  maxHeight: double.infinity,
                  // padding: const EdgeInsets.all(8.0),
                  child: widget.refreshWidget ?? _buildDefaultHeader(),
                ),
              ),
              Expanded(child: child),
              Offstage(
                offstage: isLoadingHidden,
                child: Container(
                  height: widget.maxRefreshHeight * _fingerLoadingOffset,
                  child: widget.loadingWidget ?? _buildDefaultLoading(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Center _buildDefaultLoading() => Center(child: Text("加载更多..."));

  Widget _buildDefaultHeader() {
    return Opacity(
      opacity: _fingerOffset.clamp(0.0, 1.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RotationTransition(
              turns: _valueColor,
              child: Icon(
                Icons.arrow_downward,
                size: 20.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text("正在刷新..."),
            )
          ],
        ),
      ),
    );
  }
}

class RefreshController extends ChangeNotifier {
  double _percent;

  double get percent => _percent;

  set percent(double value) {
    if (_percent != value) {
      _percent = value;
      notifyListeners();
    }
  }
}
