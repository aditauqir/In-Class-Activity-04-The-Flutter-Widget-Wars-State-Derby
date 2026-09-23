# Round 2 Bug Fixes

Team: Magic Spell Console
Members: Adi Tauqir (002847062), Wilder Edwards (002636276)

## Bug 1 — Shared Button State

**Problem:** A single `isPressed` value in the parent could make multiple
buttons respond as if they were pressed together.

**Fix:** `TactileSpellButton` is a `StatefulWidget`, and each instance stores
its own private `isPressed` value.

```dart
class _TactileSpellButtonState extends State<TactileSpellButton> {
  bool isPressed = false;
}
```

## Bug 2 — Missing `setState()` in the Slider

**Problem:** A slider could change a Dart value without rebuilding the visible
percentage.

**Fix:** Ritual Focus is updated inside `setState()`.

```dart
void _updateRitualFocus(double value) {
  setState(() {
    ritualFocus = value;
    systemMessage = 'Ritual focus calibrated to ${value.toInt()}%.';
  });
}
```

## Bug 3 — Reversed Neomorphic Depth

**Problem:** Reversed shadow sizes made a pressed pad look raised instead of
pushed inward.

**Fix:** The pressed state uses the smaller shadow and downward translation;
the released state uses the larger shadow.

```dart
boxShadow: disabled
    ? null
    : [
        BoxShadow(
          color: isPressed
              ? Colors.transparent
              : Colors.black.withOpacity(0.28),
          blurRadius: isPressed ? 0 : 16,
          offset: Offset(0, isPressed ? 2 : 8),
        ),
      ],
```

## Bug 4 — Action Fired Too Early

**Problem:** Casting from `onTapDown` runs the action when the touch begins,
not when the user releases the control.

**Fix:** `onTapDown` changes only the visual state. `onTapUp` performs the
spell action, and `onTapCancel` resets the visual state without casting.

```dart
onTapDown: disabled ? null : (_) => setState(() => isPressed = true),
onTapUp: disabled ? null : (_) => _releaseAndCast(),
onTapCancel: disabled ? null : () => setState(() => isPressed = false),
```

## Required proof screenshot

Capture one image with the fixed running app visible, the editor showing one of
the corrected sections above and its `// 🐛 BUG #` comment, and the team name
`Magic Spell Console` visible. Save it as
`MagicSpellConsole-Round2-BugProof.png`.
