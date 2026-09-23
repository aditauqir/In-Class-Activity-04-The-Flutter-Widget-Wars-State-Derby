// Activity 04: Flutter Widget Wars
// Theme: Magic Spell Console
// Team: Magic Spell Console
// Members:
// - Adi Tauqir — 002847062
// - Wilder Edwards — 002636276

import 'package:flutter/material.dart';

void main() {
  runApp(const MagicSpellConsoleApp());
}

class MagicSpellConsoleApp extends StatefulWidget {
  const MagicSpellConsoleApp({super.key});

  @override
  State<MagicSpellConsoleApp> createState() => _MagicSpellConsoleAppState();
}

class _MagicSpellConsoleAppState extends State<MagicSpellConsoleApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = isDarkMode
        ? ColorScheme.fromSeed(
            seedColor: const Color(0xFF9C6BFF),
            brightness: Brightness.dark,
          )
        : ColorScheme.fromSeed(
            seedColor: const Color(0xFF6841C8),
            brightness: Brightness.light,
          );

    return MaterialApp(
      title: 'Magic Spell Console',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: isDarkMode
            ? const Color(0xFF100D1D)
            : const Color(0xFFF5F1FF),
      ),
      home: MagicSpellConsoleScreen(
        isDark: isDarkMode,
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

class MagicSpellConsoleScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const MagicSpellConsoleScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<MagicSpellConsoleScreen> createState() =>
      _MagicSpellConsoleScreenState();
}

class _MagicSpellConsoleScreenState extends State<MagicSpellConsoleScreen> {
  int mana = 100;
  int spellsCast = 0;
  double arcanePower = 50;
  double ritualFocus = 50;
  String lastSpell = 'NONE';
  String systemMessage = 'The console is ready for your command.';
  String? previousSpell;
  bool flameArmorUnlocked = false;
  bool phaseBarrierUnlocked = false;

  static const _spellCosts = <String, int>{
    'FIREBALL': 20,
    'SHIELD': 15,
    'TELEPORT': 30,
    'HEAL': 25,
  };

  bool get overloadUnlocked => arcanePower >= 100;

  void _castSpell(String spell) {
    final cost = _spellCosts[spell]!;
    if (mana < cost) {
      setState(() {
        systemMessage = 'Not enough mana for $spell. Restore your mana first.';
      });
      return;
    }

    setState(() {
      mana -= cost;
      spellsCast++;
      lastSpell = spell;
      arcanePower = (arcanePower + 15).clamp(0, 100).toDouble();
      systemMessage = '$spell cast successfully.';

      final combo = '$previousSpell+$spell';
      if (combo == 'SHIELD+FIREBALL' || combo == 'FIREBALL+SHIELD') {
        flameArmorUnlocked = true;
        systemMessage = 'COMBO UNLOCKED: Flame Armor surrounds you!';
      } else if (combo == 'TELEPORT+SHIELD' || combo == 'SHIELD+TELEPORT') {
        phaseBarrierUnlocked = true;
        systemMessage = 'COMBO UNLOCKED: Phase Barrier is active!';
      }

      if (arcanePower >= 100) {
        systemMessage = 'ARCANE OVERLOAD ✨ The ley lines are surging!';
      }

      previousSpell = spell;
    });
  }

  void _restoreMana() {
    setState(() {
      mana = 100;
      arcanePower = (arcanePower - 10).clamp(0, 100).toDouble();
      lastSpell = 'RESTORE';
      systemMessage = 'Mana restored. The console hums with renewed energy.';
      previousSpell = null;
    });
  }

  void _updateRitualFocus(double value) {
    setState(() {
      ritualFocus = value;
      systemMessage = 'Ritual focus calibrated to ${value.toInt()}%.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ConsolePalette(widget.isDark);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConsoleHeader(
                    isDark: widget.isDark,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                  const SizedBox(height: 22),
                  _StatusPanel(
                    palette: palette,
                    mana: mana,
                    spellsCast: spellsCast,
                    arcanePower: arcanePower,
                    ritualFocus: ritualFocus,
                    lastSpell: lastSpell,
                    overloadUnlocked: overloadUnlocked,
                    onRitualFocusChanged: _updateRitualFocus,
                  ),
                  const SizedBox(height: 16),
                  _SystemMessage(
                    palette: palette,
                    message: systemMessage,
                    overloadUnlocked: overloadUnlocked,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'SPELL MATRIX',
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 620 ? 4 : 2;
                      final buttonWidth = columns == 4
                          ? (constraints.maxWidth - 48) / 4
                          : (constraints.maxWidth - 16) / 2;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _spellButton(
                            width: buttonWidth,
                            palette: palette,
                            icon: Icons.local_fire_department_rounded,
                            spell: 'FIREBALL',
                            subtitle: 'EMBER RUNE',
                            cost: _spellCosts['FIREBALL']!,
                            accent: const Color(0xFFFF8552),
                          ),
                          _spellButton(
                            width: buttonWidth,
                            palette: palette,
                            icon: Icons.shield_rounded,
                            spell: 'SHIELD',
                            subtitle: 'AEGIS WARD',
                            cost: _spellCosts['SHIELD']!,
                            accent: const Color(0xFF64D8CB),
                          ),
                          _spellButton(
                            width: buttonWidth,
                            palette: palette,
                            icon: Icons.swap_horizontal_circle_rounded,
                            spell: 'TELEPORT',
                            subtitle: 'VOID STEP',
                            cost: _spellCosts['TELEPORT']!,
                            accent: const Color(0xFF9C8CFF),
                          ),
                          _spellButton(
                            width: buttonWidth,
                            palette: palette,
                            icon: Icons.favorite_rounded,
                            spell: 'HEAL',
                            subtitle: 'LIFE WEAVE',
                            cost: _spellCosts['HEAL']!,
                            accent: const Color(0xFFFF78B9),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  _RestoreManaButton(palette: palette, onPressed: _restoreMana),
                  const SizedBox(height: 22),
                  _ComboPanel(
                    palette: palette,
                    flameArmorUnlocked: flameArmorUnlocked,
                    phaseBarrierUnlocked: phaseBarrierUnlocked,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Cast two compatible spells in sequence to discover a combination.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: palette.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _spellButton({
    required double width,
    required _ConsolePalette palette,
    required IconData icon,
    required String spell,
    required String subtitle,
    required int cost,
    required Color accent,
  }) {
    return TactileSpellButton(
      width: width,
      icon: icon,
      spell: spell,
      subtitle: subtitle,
      manaCost: cost,
      accentColor: accent,
      enabled: mana >= cost,
      palette: palette,
      onPressed: () => _castSpell(spell),
    );
  }
}

// StatelessWidget checkpoint: this header is rendered from parent values.
class ConsoleHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ConsoleHeader({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C6BFF), Color(0xFF5E3BA9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C6BFF).withOpacity(0.32),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MAGIC SPELL',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              Text(
                'CONSOLE / ARCANE CONTROL DECK',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Toggle light and dark mode',
          onPressed: onToggleTheme,
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          ),
        ),
      ],
    );
  }
}

// StatelessWidget checkpoint: a pure view of live counters and meter values.
class _StatusPanel extends StatelessWidget {
  final _ConsolePalette palette;
  final int mana;
  final int spellsCast;
  final double arcanePower;
  final double ritualFocus;
  final String lastSpell;
  final bool overloadUnlocked;
  final ValueChanged<double> onRitualFocusChanged;

  const _StatusPanel({
    required this.palette,
    required this.mana,
    required this.spellsCast,
    required this.arcanePower,
    required this.ritualFocus,
    required this.lastSpell,
    required this.overloadUnlocked,
    required this.onRitualFocusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.panel,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'ARCANE READOUT',
                style: TextStyle(
                  color: palette.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.circle,
                size: 8,
                color: overloadUnlocked
                    ? Colors.amber
                    : const Color(0xFF64D8CB),
              ),
              const SizedBox(width: 6),
              Text(
                overloadUnlocked ? 'OVERLOAD' : 'ONLINE',
                style: TextStyle(
                  color: overloadUnlocked
                      ? Colors.amber
                      : const Color(0xFF64D8CB),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricBadge(
                  label: 'MANA',
                  value: '$mana',
                  suffix: '/ 100',
                  icon: Icons.water_drop_rounded,
                  color: const Color(0xFF64D8CB),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBadge(
                  label: 'CASTS',
                  value: '$spellsCast',
                  suffix: ' TOTAL',
                  icon: Icons.bolt_rounded,
                  color: const Color(0xFFFFC857),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBadge(
                  label: 'LAST SPELL',
                  value: lastSpell,
                  suffix: '',
                  icon: Icons.auto_awesome_rounded,
                  color: const Color(0xFFB493FF),
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'ARCANE POWER',
                style: TextStyle(
                  color: palette.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              Text(
                '${arcanePower.toInt()}%',
                style: TextStyle(
                  color: overloadUnlocked
                      ? Colors.amber
                      : const Color(0xFFB493FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: arcanePower / 100,
              minHeight: 9,
              backgroundColor: palette.track,
              valueColor: AlwaysStoppedAnimation<Color>(
                overloadUnlocked ? Colors.amber : const Color(0xFF9C6BFF),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'RITUAL FOCUS',
                style: TextStyle(
                  color: palette.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              Text(
                '${ritualFocus.toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF64D8CB),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          // 🐛 BUG #2 — a slider value can change without rebuilding the UI.
          // FIX: keep the value update inside setState via the callback above.
          Slider(
            value: ritualFocus,
            min: 0,
            max: 100,
            activeColor: const Color(0xFF64D8CB),
            inactiveColor: palette.track,
            onChanged: onRitualFocusChanged,
          ),
        ],
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final IconData icon;
  final Color color;
  final bool compact;

  const _MetricBadge({
    required this.label,
    required this.value,
    required this.suffix,
    required this.icon,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: compact ? 16 : 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (suffix.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  Text(
                    suffix,
                    style: TextStyle(
                      color: color.withOpacity(0.68),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemMessage extends StatelessWidget {
  final _ConsolePalette palette;
  final String message;
  final bool overloadUnlocked;

  const _SystemMessage({
    required this.palette,
    required this.message,
    required this.overloadUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final color = overloadUnlocked ? Colors.amber : const Color(0xFFB493FF);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        border: Border.all(color: color.withOpacity(0.32)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            overloadUnlocked
                ? Icons.warning_amber_rounded
                : Icons.terminal_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: palette.text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom StatefulWidget checkpoint: each spell pad owns its pressed state and
// uses GestureDetector for tactile press/release feedback.
class TactileSpellButton extends StatefulWidget {
  final double width;
  final IconData icon;
  final String spell;
  final String subtitle;
  final int manaCost;
  final Color accentColor;
  final bool enabled;
  final _ConsolePalette palette;
  final VoidCallback onPressed;

  const TactileSpellButton({
    super.key,
    required this.width,
    required this.icon,
    required this.spell,
    required this.subtitle,
    required this.manaCost,
    required this.accentColor,
    required this.enabled,
    required this.palette,
    required this.onPressed,
  });

  @override
  State<TactileSpellButton> createState() => _TactileSpellButtonState();
}

class _TactileSpellButtonState extends State<TactileSpellButton> {
  // 🐛 BUG #1 — sharing this flag in the parent makes every button react.
  // FIX: each custom StatefulWidget owns its own pressed state.
  bool isPressed = false;

  void _releaseAndCast() {
    if (!widget.enabled) return;
    setState(() => isPressed = false);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    final surface = disabled ? widget.palette.disabled : widget.palette.panel;
    final accent = disabled ? widget.palette.muted : widget.accentColor;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: '${widget.spell}, costs ${widget.manaCost} mana',
      child: GestureDetector(
        // 🐛 BUG #4 — firing the spell from onTapDown triggers too early.
        // FIX: onTapDown changes visuals; onTapUp performs the action.
        onTapDown: disabled ? null : (_) => setState(() => isPressed = true),
        onTapUp: disabled ? null : (_) => _releaseAndCast(),
        onTapCancel: disabled ? null : () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          width: widget.width,
          height: 142,
          padding: const EdgeInsets.all(14),
          transform: Matrix4.translationValues(0, isPressed ? 3 : 0, 0),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isPressed ? accent : widget.palette.border,
              width: isPressed ? 1.5 : 1,
            ),
            boxShadow: disabled
                ? null
                : [
                    // 🐛 BUG #3 — reversed shadow depth makes a pressed pad
                    // look raised. FIX: pressed state uses the smaller shadow.
                    BoxShadow(
                      color: isPressed
                          ? Colors.transparent
                          : Colors.black.withOpacity(
                              widget.palette.isDark ? 0.28 : 0.12,
                            ),
                      blurRadius: isPressed ? 0 : 16,
                      offset: Offset(0, isPressed ? 2 : 8),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon, color: accent, size: 30),
                  const Spacer(),
                  Icon(
                    Icons.bolt_rounded,
                    color: accent.withOpacity(0.7),
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${widget.manaCost}',
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.spell,
                style: TextStyle(
                  color: accent,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                disabled ? 'INSUFFICIENT MANA' : widget.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.palette.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestoreManaButton extends StatelessWidget {
  final _ConsolePalette palette;
  final VoidCallback onPressed;

  const _RestoreManaButton({required this.palette, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh_rounded, size: 18),
      label: const Text('RESTORE MANA'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF64D8CB),
        side: BorderSide(color: const Color(0xFF64D8CB).withOpacity(0.55)),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ComboPanel extends StatelessWidget {
  final _ConsolePalette palette;
  final bool flameArmorUnlocked;
  final bool phaseBarrierUnlocked;

  const _ComboPanel({
    required this.palette,
    required this.flameArmorUnlocked,
    required this.phaseBarrierUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMBINATION CODEX',
            style: TextStyle(
              color: palette.muted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          _ComboRow(
            palette: palette,
            sequence: 'SHIELD  +  FIREBALL',
            reward: 'FLAME ARMOR',
            unlocked: flameArmorUnlocked,
          ),
          const SizedBox(height: 10),
          _ComboRow(
            palette: palette,
            sequence: 'TELEPORT  +  SHIELD',
            reward: 'PHASE BARRIER',
            unlocked: phaseBarrierUnlocked,
          ),
        ],
      ),
    );
  }
}

class _ComboRow extends StatelessWidget {
  final _ConsolePalette palette;
  final String sequence;
  final String reward;
  final bool unlocked;

  const _ComboRow({
    required this.palette,
    required this.sequence,
    required this.reward,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? const Color(0xFFFFC857) : palette.muted;
    return Row(
      children: [
        Icon(
          unlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            sequence,
            style: TextStyle(
              color: palette.text,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          unlocked ? '$reward ✦' : 'LOCKED',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _ConsolePalette {
  final bool isDark;

  const _ConsolePalette(this.isDark);

  Color get panel => isDark ? const Color(0xFF1C172D) : Colors.white;
  Color get disabled =>
      isDark ? const Color(0xFF171421) : const Color(0xFFE7E3EF);
  Color get border =>
      isDark ? const Color(0xFF372C53) : const Color(0xFFE0D8F0);
  Color get track => isDark ? const Color(0xFF2A2140) : const Color(0xFFE5DDF2);
  Color get muted => isDark ? const Color(0xFF9B91AD) : const Color(0xFF756A86);
  Color get text => isDark ? const Color(0xFFF6F1FF) : const Color(0xFF211A30);
}
