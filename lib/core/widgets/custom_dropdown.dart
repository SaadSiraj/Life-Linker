import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';

class CustomDropDown<T> extends StatefulWidget {
  final T? selectedValue;
  final String placeholder;
  final List<T> items;
  final Function(T) onChanged;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? prefixWidget;
  final Color? backgroundColor;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String Function(T)? labelBuilder;

  const CustomDropDown({
    super.key,
    required this.selectedValue,
    required this.placeholder,
    required this.items,
    required this.onChanged,
    this.width,
    this.height,
    this.borderRadius,
    this.prefixWidget,
    this.backgroundColor,
    this.itemBuilder,
    this.labelBuilder,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  bool _isOpen = false;
  OverlayEntry? _overlay;
  final LayerLink _layerLink = LayerLink();

  void _openDropdown() {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;

    _overlay = OverlayEntry(
      builder: (_) => _DropdownOverlay<T>(
        items: widget.items,
        selectedValue: widget.selectedValue,
        layerLink: _layerLink,
        fieldWidth: size.width,
        fieldHeight: widget.height ?? SizeConfig.heightMultiplier * 6,
        labelBuilder: widget.labelBuilder,
        itemBuilder: widget.itemBuilder,
        onSelect: (value) {
          _closeDropdown();
          widget.onChanged(value);
        },
        onClose: _closeDropdown,
      ),
    );

    Overlay.of(context).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  String _label(T? val) {
    if (val == null) return widget.placeholder;
    return widget.labelBuilder?.call(val) ?? val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double fieldHeight = widget.height ?? SizeConfig.heightMultiplier * 6;
    final double radius = widget.borderRadius ?? 12;
    final bool hasValue = widget.selectedValue != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _isOpen ? _closeDropdown : _openDropdown,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: fieldHeight,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: _isOpen ? AppColors.black800 : AppColors.unFocusGreyClr,
              width: _isOpen ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 3,
            ),
            child: Row(
              children: [
                if (widget.prefixWidget != null) ...[
                  widget.prefixWidget!,
                  SizedBox(width: SizeConfig.widthMultiplier * 2),
                ],
                Expanded(
                  child: Text(
                    _label(widget.selectedValue),
                    style: textTheme.bodyMedium!.copyWith(
                      color: hasValue ? AppColors.black800 : AppColors.grey400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    color: _isOpen ? AppColors.black800 : AppColors.grey500,
                    size: SizeConfig.widthMultiplier * 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownOverlay<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final LayerLink layerLink;
  final double fieldWidth;
  final double fieldHeight;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String Function(T)? labelBuilder;
  final Function(T) onSelect;
  final VoidCallback onClose;

  const _DropdownOverlay({
    required this.items,
    required this.selectedValue,
    required this.layerLink,
    required this.fieldWidth,
    required this.fieldHeight,
    required this.onSelect,
    required this.onClose,
    this.itemBuilder,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          CompositedTransformFollower(
            link: layerLink,
            offset: Offset(0, fieldHeight + 4),
            child: Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: fieldWidth,
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.heightMultiplier * 28,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.heightMultiplier * 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      final item = items[i];
                      final isSelected = item == selectedValue;
                      return GestureDetector(
                        onTap: () => onSelect(item),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 4,
                            vertical: SizeConfig.heightMultiplier * 1.6,
                          ),
                          color: isSelected
                              ? AppColors.black800.withValues(alpha: 0.06)
                              : Colors.transparent,
                          child: itemBuilder != null
                              ? itemBuilder!(ctx, item)
                              : Text(
                                  labelBuilder?.call(item) ?? item.toString(),
                                  style: Theme.of(ctx).textTheme.bodyMedium!
                                      .copyWith(
                                        color: isSelected
                                            ? AppColors.black900
                                            : AppColors.black800,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
