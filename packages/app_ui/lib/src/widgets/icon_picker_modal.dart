// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///{@template icon_pack}
///The group of icons to pick from. It is a list of [IconData]s.
///
///The icons are displayed in a grid and has name
///{@endtemplate}
class IconPack extends Equatable {
  ///{@macro icon_pack}
  const IconPack({
    required this.name,
    required this.icons,
  });

  ///The title of the group.
  final String name;

  ///The icons to pick from.
  final List<IconPickerIcon> icons;

  @override
  List<Object?> get props => [name, icons];

  IconPack copyWith({
    String? name,
    List<IconPickerIcon>? icons,
  }) {
    return IconPack(
      name: name ?? this.name,
      icons: icons ?? this.icons,
    );
  }
}

class IconPickerIcon extends Equatable {
  const IconPickerIcon({
    required this.name,
    required this.data,
  });

  /// The name of the icon represents the `key`
  final String name;

  /// The IconData of the icon like `codePoint`, `fontFamily`, `fontPackage`, `matchTextDirection`
  final IconData data;

  @override
  List<Object?> get props => [name, data];

  IconPickerIcon copyWith({
    String? name,
    IconData? data,
  }) {
    return IconPickerIcon(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}

/// {@template icon_picker}
/// A modal that allows the user to pick an icon.
/// {@endtemplate}
class IconPickerModal extends StatefulWidget {
  /// {@macro icon_picker}
  const IconPickerModal({
    required this.iconPacks,
    this.title,
    super.key,
  });

  /// The title of the picker
  final Widget? title;

  /// The icon packs to pick from.
  ///
  /// You can
  final List<IconPack> iconPacks;

  @override
  State<IconPickerModal> createState() => _IconPickerModalState();
}

class _IconPickerModalState extends State<IconPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<IconPack> _filteredIconPacks = [];
  bool _showClearButton = false;

  @override
  void initState() {
    _filteredIconPacks = widget.iconPacks;
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _showClearButton = _searchController.text.isNotEmpty;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final filtered = <IconPack>[];
      for (final iconPack in widget.iconPacks) {
        final filteredIcons = iconPack.icons.where(
          (icon) {
            return icon.name.toLowerCase().contains(_searchController.text);
          },
        ).toList();
        if (filteredIcons.isNotEmpty) {
          filtered.add(iconPack.copyWith(icons: filteredIcons));
        }
      }
      setState(() {
        _filteredIconPacks = filtered;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    // The padding for when keyboard is open
    final keyboardPadding = mediaQuery.viewInsets.bottom;
    return ModalScaffold(
      header: widget.title,
      content: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: keyboardPadding,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xlg,
              0,
              AppSpacing.xlg,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _showClearButton
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _showClearButton = false;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: (mediaQuery.size.height * 0.2) //
                          .clamp(100.0, 300.0),
                      maxHeight: mediaQuery.size.height * 0.4,
                    ),
                    child: Scrollbar(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredIconPacks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final pack = _filteredIconPacks[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pack.name,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final icon in pack.icons)
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.sm,
                                          ),
                                        ),
                                        backgroundColor: theme
                                            .colorScheme.surfaceContainerLow,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(icon.data),
                                      icon: Icon(icon.data),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Done'.hardCoded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The predefined icon packs.
class IconPacks {
  /// The wallets icon pack.
  static const wallets = IconPack(
    name: 'Wallets',
    icons: [
      IconPickerIcon(name: 'wallet', data: Icons.wallet),
      IconPickerIcon(name: 'wallet_giftcard', data: Icons.wallet_giftcard),
      IconPickerIcon(name: 'wallet_membership', data: Icons.wallet_membership),
      IconPickerIcon(name: 'wallet_travel', data: Icons.wallet_travel),
      IconPickerIcon(
        name: 'wallet_giftcard_rounded',
        data: Icons.wallet_giftcard_rounded,
      ),
      IconPickerIcon(
        name: 'wallet_membership_rounded',
        data: Icons.wallet_membership_rounded,
      ),
    ],
  );
}
