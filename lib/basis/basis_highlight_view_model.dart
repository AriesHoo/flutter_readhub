import 'package:flutter/material.dart';

import 'basis_view_model.dart';

///高亮变化
class BasisHighlightViewModel extends BasisViewModel {
  bool _highlight = false;

  bool get highlight => _highlight;

  ValueChanged<bool> get onHighlightChanged => (highlight) {
        _highlight = highlight;
        setSuccess();
      };
}
