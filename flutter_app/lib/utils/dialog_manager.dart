import 'package:flutter/material.dart';
import '../widgets/mise_popup.dart';
import '../widgets/point_popup.dart';
import '../data/mise_data.dart';

class DialogManager {
  static void ukazStartPopup({
    required BuildContext context,
    required Mise miseData,
    required VoidCallback onVyrazit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MisePopup(
          miseData: miseData,
          onVyrazit: onVyrazit,
        );
      },
    );
  }

  static void ukazPribehPopup({
    required BuildContext context,
    required List<BodMise> historieBodu,
    required Mise miseData,
    required VoidCallback onPokracovat,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PointPopup(
          historieBodu: historieBodu,
          miseData: miseData,
          onPokracovat: onPokracovat,
        );
      },
    );
  }
}