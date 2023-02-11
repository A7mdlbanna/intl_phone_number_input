import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/utils/sized_box.dart';
import '../models/country_model.dart';
import '../utils/selector_config.dart';
import '../utils/test/test_helper.dart';
import '../widgets/countries_search_list_widget.dart';
import '../widgets/input_widget.dart';
import '../widgets/item.dart';

/// [SelectorButton]
class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
        ? PopupMenuButton<Country>(
        itemBuilder: (context) => mapCountryToDropdownItem(countries),
        onSelected: isEnabled ? onCountryChanged : null,
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            10.widthBox,
            Item(
              country: country,
              isHint: true,
              showFlag: true,
              useEmoji: selectorConfig.useEmoji,
              leadingPadding: selectorConfig.leadingPadding,
              trailingSpace: selectorConfig.trailingSpace,
              textStyle: selectorTextStyle,
            ),
            10.widthBox,
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        )
    )
        : Item(
      isHint: false,
      country: country,
      showFlag: selectorConfig.showFlags,
      useEmoji: selectorConfig.useEmoji,
      leadingPadding: selectorConfig.leadingPadding,
      trailingSpace: selectorConfig.trailingSpace,
      textStyle: selectorTextStyle,
    )
        : MaterialButton(
      key: const Key(TestHelper.DropdownButtonKeyValue),
      padding: EdgeInsets.zero,
      minWidth: 0,
      onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
          ? () async {
        Country? selected;
        if (selectorConfig.selectorType ==
            PhoneInputSelectorType.BOTTOM_SHEET) {
          selected = await showCountrySelectorBottomSheet(
              context, countries);
        } else {
          selected =
          await showCountrySelectorDialog(context, countries);
        }

        if (selected != null) {
          onCountryChanged(selected);
        }
      }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Item(
          isHint: false,
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          leadingPadding: selectorConfig.leadingPadding,
          trailingSpace: selectorConfig.trailingSpace,
          textStyle: selectorTextStyle,
        ),
      ),
    );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<PopupMenuItem<Country>> mapCountryToDropdownItem(List<Country> countries) {
    return countries.map((country) {
      return PopupMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          isHint: false,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          withCountryNames: false,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(BuildContext context, List<Country> countries) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: CountrySearchListWidget(
            countries,
            locale,
            searchBoxDecoration: searchBoxDecoration,
            showFlags: selectorConfig.showFlags,
            useEmoji: selectorConfig.useEmoji,
            autoFocus: autoFocusSearchField,
          ),
        ),
      ),
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(BuildContext context, List<Country> countries) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).canvasColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: CountrySearchListWidget(
                  countries,
                  locale,
                  searchBoxDecoration: searchBoxDecoration,
                  scrollController: controller,
                  showFlags: selectorConfig.showFlags,
                  useEmoji: selectorConfig.useEmoji,
                  autoFocus: autoFocusSearchField,
                ),
              );
            },
          ),
        ]);
      },
    );
  }
}