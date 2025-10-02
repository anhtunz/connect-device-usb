import 'package:flutter/material.dart';

import '../constants/icon/icon_constants.dart';

const int _kDuration = 300;
const double _kWidth = 60;
const double _kheight = 30;

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  /// Whether this switch is on or off.
  ///
  /// This property must not be null.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// LanguageSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  @override
  Widget build(BuildContext context) {
    bool toggleState = widget.value;
    const dayColor = Colors.blue;
    const nightColor = Colors.grey;

    return InkWell(
      onTap: () => setState(() {
        toggleState = !toggleState;
        widget.onChanged?.call(toggleState);
      }),
      customBorder: const StadiumBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: _kDuration),
        width: _kWidth,
        height: _kheight,
        decoration: ShapeDecoration(
          color: toggleState ? dayColor : nightColor,
          shape: const StadiumBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              //day icon
              AnimatedOpacity(
                opacity: toggleState ? 1 : 0,
                duration: const Duration(milliseconds: _kDuration),
                child: AnimatedAlign(
                  alignment: toggleState
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: _kDuration),
                  // child: const Icon(
                  //   Icons.circle,
                  //   size: 30,
                  //   // color: Colors.white,
                  // ),
                  child: Image.asset(
                    IconConstants.instance.getIcon('vi_icon'),
                    width: 30,
                    height: 30,
                  ),
                ),
              ),

              //night Icon
              AnimatedOpacity(
                opacity: toggleState ? 0 : 1,
                duration: const Duration(milliseconds: _kDuration),
                child: AnimatedAlign(
                  alignment: toggleState
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: _kDuration),
                  child: AnimatedRotation(
                    turns: toggleState ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: _kDuration),
                    // child: const Icon(
                    //   Icons.nightlight,
                    //   size: 30,
                    //   // color: Colors.white,
                    // ),
                    child: Image.asset(
                      IconConstants.instance.getIcon('en_icon'),
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
