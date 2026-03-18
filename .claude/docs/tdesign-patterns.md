# TDesign Flutter Pattern Reference

**Extracted:** 2026-03-13
**Source:** `tdesign-flutter/tdesign-component/lib/src/`
**Purpose:** Reference for rebuilding Phoenix UI with TDesign patterns

---

## 1. Theme System

### Access Pattern
```dart
final theme = TDTheme.of(context);  // Gets TDThemeData

// Colors
theme.brandNormalColor    // Primary brand
theme.brandClickColor     // Pressed state
theme.brandDisabledColor  // Disabled state
theme.bgColorPage         // Page background
theme.bgColorContainer    // Card/container background
theme.textColorPrimary    // Primary text
theme.textColorSecondary  // Secondary text
theme.componentStrokeColor // Borders

// Spacing (4/8pt grid)
theme.spacer4, theme.spacer8, theme.spacer12, theme.spacer16, theme.spacer24, theme.spacer32

// Radius
theme.radiusSmall    // 3
theme.radiusDefault  // 6
theme.radiusLarge    // 9
theme.radiusExtraLarge // 12
theme.radiusRound    // 9999 (capsule)

// Shadows (3-level)
theme.shadowsBase    // Elevation 1 — cards
theme.shadowsMiddle  // Elevation 2 — dropdowns
theme.shadowsTop     // Elevation 3 — modals

// Typography
theme.fontTitleMedium   // 16/24px w600
theme.fontBodyLarge     // 16/24px w400
theme.fontBodyMedium    // 14/22px w400
theme.fontBodySmall     // 12/20px w400
```

### Theme Provider Setup
```dart
// Single theme (most apps)
TDTheme(data: myThemeData, child: MaterialApp(...))

// Or attach as ThemeExtension
ThemeData(extensions: [myTDThemeData], ...)
```

### Dark Mode
TDThemeData has `.dark` and `.light` fields. Access via `TDTheme.of(context)` which resolves based on current brightness.

---

## 2. Button State Machine

### 3-State Pattern
```dart
enum TDButtonStatus { defaultState, active, disable }
```

### Lifecycle
```
tap down   → active (immediate)
tap up     → defaultState (100ms delay for visual feedback)
tap cancel → defaultState (immediate)
disabled   → GestureDetector removed entirely
```

### Style Per State
```dart
TDButtonStyle get style {
  switch (_buttonStatus) {
    case TDButtonStatus.defaultState: return _defaultStyle;
    case TDButtonStatus.active: return _activeStyle;
    case TDButtonStatus.disable: return _disableStyle;
  }
}
```

Colors auto-adjust: `brandNormalColor` → `brandClickColor` → `brandDisabledColor`

### Implementation Pattern
```dart
GestureDetector(
  onTap: widget.onTap,
  onTapDown: (_) => setState(() => _status = TDButtonStatus.active),
  onTapUp: (_) => Future.delayed(Duration(milliseconds: 100), () {
    if (mounted && !widget.disabled) setState(() => _status = TDButtonStatus.defaultState);
  }),
  onTapCancel: () => setState(() => _status = TDButtonStatus.defaultState),
  child: Container(
    decoration: BoxDecoration(
      color: style.backgroundColor,
      borderRadius: style.radius,
      border: Border.all(color: style.frameColor, width: style.frameWidth),
    ),
    child: ...
  ),
)
```

---

## 3. Widget Composition Pattern

### Two-Tier Architecture
```
Public API (StatefulWidget)
  - All configuration props
  - Immutable, no state

Internal State (_State)
  - Manages visual state
  - Caches computed values
  - _updateParams() called in initState, didChangeDependencies, didUpdateWidget
  - Provides getters for current style
```

### Lifecycle Hook Pattern
```dart
@override void initState() { super.initState(); _updateParams(); }
@override void didChangeDependencies() { super.didChangeDependencies(); _updateParams(); }
@override void didUpdateWidget(old) { super.didUpdateWidget(old); _updateParams(); }
```

---

## 4. Animation Patterns

### Progress (Circular Arc)
- AnimationController + Tween<double>(0→1) + AnimatedBuilder
- Duration: 300ms (configurable)
- CustomPainter: `canvas.drawArc()` with `sweepAngle = 2 * pi * value`
- StrokeCap.round for smooth endpoints

### Collapse (Expand/Contract)
- AnimatedCrossFade with overlapping Intervals
  - First: Interval(0.0, 0.6, curve: Curves.fastOutSlowIn)
  - Second: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn)
- Duration: ~200ms (kThemeAnimationDuration)

### Tab Indicator
- Rect.lerp(fromRect, toRect, progress) for smooth indicator movement
- TextStyle.lerp + Color.lerp for label transitions
- CustomPainter with `super(repaint: controller.animation)` for auto-tick

### Loading Spinner
- AnimationController..repeat()
- Transform(transform: Matrix4.identity()..rotateZ(value * 2 * pi))
- Gradient.sweep for arc fade effect

### Time Counter
- Uses raw Ticker (NOT AnimationController)
- setState on each tick
- No visual animation — pure numeric updates

### Bouncing Dots
- DelayTween with sine wave: `sin((t - delay) * 2 * pi) + 1) / 2`
- ScaleTransition per dot
- Stagger: delay = i * 0.2

---

## 5. Shadow System

### 3-Level Elevation
Each level = 3 layered BoxShadow:

**Base (cards):**
```dart
[BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 1)),
 BoxShadow(color: Color(0x14000000), blurRadius: 5, offset: Offset(0, 4)),
 BoxShadow(color: Color(0x1F000000), blurRadius: 4, offset: Offset(0, 2))]
```

**Middle (dropdowns):**
```dart
[BoxShadow(color: Color(0x0D000000), blurRadius: 14, offset: Offset(0, 3)),
 BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 8)),
 BoxShadow(color: Color(0x1A000000), blurRadius: 5, offset: Offset(0, 0))]
```

**Top (modals):**
```dart
[BoxShadow(color: Color(0x0D000000), blurRadius: 30, offset: Offset(0, 6)),
 BoxShadow(color: Color(0x0A000000), blurRadius: 24, offset: Offset(0, 16)),
 BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 8))]
```

---

## 6. Component Quick Reference

| Component | Key Props | Use For |
|-----------|-----------|---------|
| TDButton | text, type(fill/outline/text/ghost), theme(primary/danger/default), size, disabled | All buttons |
| TDCell | title, description, arrow, note, leftIcon, onClick, bordered | List items, settings rows |
| TDCellGroup | cells, title, theme(default/card), bordered | List containers |
| TDTag | text, size, shape, theme(primary/success/warning/danger), isOutline, isLight | Badges, labels |
| TDNavBar | title, leftBarItems, rightBarItems, useDefaultBack, height(48) | Top bar |
| TDBottomTabBar | basicType(iconText), navigationTabs, currentIndex, barHeight(56) | Bottom nav |
| TDDialog | (use TDAlertDialog/TDConfirmDialog) | Modals |
| TDToast | .showText(), .showSuccess(), .showFail(), .showLoading(), .dismissAll() | Notifications |
| TDPopup | via TDPopupRoute.show(), draggable, maxHeightRatio | Bottom sheets |
| TDSwipeCell | cell, right(TDSwipeCellPanel), disabled | Swipe to delete |
| TDSteps | steps(List<TDStepsItemData>), activeIndex, direction | Step indicators |
| TDRate | count(5), value, allowHalf, onChange, size(24), color[selected, unselected] | Star rating |
| TDProgress | value, type(linear/circular), animationDuration(300) | Progress bars |
| TDLoading | icon(circle/activity/point), text, axis | Loading states |
| TDCollapse | children(TDCollapsePanel), allowOnlyOnePanelOpen | Accordion |
| TDInput | controller, placeholder, type, maxLength, onChanged | Text input |
| TDSwitch | isOn, onChanged, disabled | Toggle switch |
| TDSlider | value, onChanged, min, max, divisions | Slider |
| TDDivider | (default horizontal) | Separators |
| TDEmpty | type, description | Empty states |
| TDNoticeBar | content, theme, prefixIcon | Alert bars |
| TDSkeleton | rowCount, animation | Loading placeholders |
