import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/country_model.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;
  final bool? isHint;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.isHint,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 15,
    this.trailingSpace = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: leadingPadding),
        _Flag(
          country: country,
          showFlag: showFlag,
          useEmoji: useEmoji,
        ),
        if(isHint != null && !isHint!) ...[
          SizedBox(width: 10.0.w),
          Text(
            dialCode,
            style: textStyle,
          ),
        ]
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.showFlag, this.useEmoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag! ? Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade400, blurRadius: 1, spreadRadius: 1)
          ]
      ),
      child: Image.asset(
        country!.flagUri,
        width: 26.w,
        // height: 18.6.h,
        package: 'intl_phone_number_input',
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      ),
    )
        : const SizedBox.shrink();
  }
}
