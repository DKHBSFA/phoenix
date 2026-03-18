import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';

/// ListTile with a TDSwitch as trailing widget.
/// Drop-in replacement for Material SwitchListTile.
class PhoenixSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const PhoenixSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: context.phoenix.textSecondary,
              ),
            )
          : null,
      trailing: TDSwitch(
        isOn: value,
        size: TDSwitchSize.medium,
        onChanged: (v) {
          onChanged?.call(v);
          return true; // externally managed state
        },
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
