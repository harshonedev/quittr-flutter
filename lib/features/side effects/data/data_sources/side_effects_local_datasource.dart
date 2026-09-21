import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quittr/features/side%20effects/data/models/side_effects_model.dart';

abstract interface class SideEffectsLocalDatasource {
  Future<List<SideEffectsModel>> getSideEffects();
}

class SideEffectsLocalDatasourceImpl implements SideEffectsLocalDatasource {
  @override
  Future<List<SideEffectsModel>> getSideEffects() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/side_effects.json');
      final data = await json.decode(response);

      List<dynamic> sideEffects = data['side_effects'];

      return sideEffects
          .map((sideEffects) => SideEffectsModel.fromJson(sideEffects))
          .toList();
    } catch (e) {
      throw Exception('Failed to load quotes: ${e.toString()}');
    }
  }
}
