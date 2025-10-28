import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tp_media/widget/common_card.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.labelText,
    this.onChanged,
    this.maxLength,
    this.textInputType,
    this.editingController,
    this.suffixChild,
    this.inputFormatter,
    this.onFocusChanged,
    this.errorMessage = '',
    this.onValidate,
  });

  final String labelText;
  final int? maxLength;
  final TextInputType? textInputType;
  final TextEditingController? editingController;
  final Widget? suffixChild;
  final List<TextInputFormatter>? inputFormatter;
  final VoidCallback? onFocusChanged;
  final Function(String)? onChanged;
  final String errorMessage;
  final bool Function(String)? onValidate;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  var _visibleSuffix = false;
  var _hasChanged = false;

  TextEditingController? _editingController = TextEditingController();
  final _focus = FocusNode();

  Color get hintColor {
    return Theme.of(context).hintColor;
  }

  Color get textColor {
    return Theme.of(context).colorScheme.onSurface;
  }

  Color get errorColor {
    return Theme.of(context).colorScheme.error;
  }

  @override
  void initState() {
    super.initState();

    if (widget.editingController != null) {
      _editingController = widget.editingController;
    }

    _visibleSuffix = _editingController?.text.isNotEmpty ?? false;

    _focus.addListener(listener);
  }

  VoidCallback get listener => () {
    if (mounted) {
      setState(() {
        widget.onFocusChanged?.call();
      });
    }
  };

  @override
  void dispose() {
    if (widget.editingController == null) {
      _editingController?.dispose();
    }
    _focus.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonCard(
          child: Container(
            padding: const EdgeInsets.only(right: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _editingController,
                    maxLength: widget.maxLength,
                    keyboardType: widget.textInputType,
                    inputFormatters: widget.inputFormatter,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18.0,
                      decorationThickness: 0,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      labelStyle: TextStyle(
                        color: hintColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: hintColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(
                        12.0,
                        12,
                        4.0,
                        12,
                      ),
                      counterText: "",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _hasChanged = true;
                        _visibleSuffix = value.isNotEmpty;
                      });
                      widget.onChanged?.call(value);
                    },
                    focusNode: _focus,
                  ),
                ),
                Container(
                  child:
                      widget.suffixChild ??
                      Visibility(
                        visible:
                            _visibleSuffix &&
                            _focus.hasFocus &&
                            _editingController?.text.isNotEmpty == true,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _editingController?.text = "";
                                _editingController
                                    ?.selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset:
                                        _editingController?.text.length ?? 0,
                                  ),
                                );
                                widget.onChanged?.call("");
                              });
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: hintColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible:
              widget.onValidate != null &&
              widget.onValidate?.call(_editingController?.text ?? '') ==
                  false &&
              _hasChanged,
          child: Padding(
            padding: EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Text(
              widget.errorMessage,
              textAlign: TextAlign.start,
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
