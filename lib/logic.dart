import 'dart:math' as math;

import 'package:intl/intl.dart' as intl;

class Logic {
  String _text = '0';

  String get text => _text;

  /// 表示する値
  double _displayValue = 0;

  /// 最大桁数
  static const maxNumberOfDigits = 9;

  /// 現在の値
  double _currentValue = 0;

  /// 現在の値(読込専用)
  double get currentValue => _currentValue;

  /// 足す、引く用の値
  double _memorialValue = 0;

  /// 足す、引く用の値(読込専用)
  double get memorialValue => _memorialValue;

  /// 掛ける、割る用の値
  double _previousValue = 0;

  /// 掛ける、割る用の値(読込専用)
  double get previousValue => _previousValue;

  /// かけ算か割り算を記録しておく
  String _previousOperation = '';

  /// かけ算か割り算を記録しておく(読込専用)
  String get previousOperation => _previousOperation;

  /// たし算かひき算を記録しておく
  String _memorialOperation = '';

  /// たし算かひき算を記録しておく(読込専用)
  String get memorialOperation => _memorialOperation;

  /// 小数点の有無
  bool _hasPoint = false;

  /// 小数点以下の数
  int _numAfterPoint = 0;

  final intl.NumberFormat formatter = intl.NumberFormat('#,###.########', 'en_US');

  ///
  void input(String text) {
    if (text == '.') {
      _hasPoint = true;
    } else if (text == 'C') {
      _clear();
      return;
    } else if (text == '=') {
      if (_previousOperation == 'x' || _previousOperation == '/') {
        final result = _previousOperation == 'x' ? _previousValue * _currentValue : _previousValue / _currentValue;

        _displayValue = _memorialValue + (_memorialOperation == '-' ? -1 : 1) * result;
      } else if (_memorialOperation == '+') {
        _displayValue = _memorialValue + _currentValue;
      } else if (_memorialOperation == '-') {
        _displayValue = _memorialValue - _currentValue;
      }

      _clear();
    } else if (text == 'x' || text == '/') {
      if (_previousOperation == '') {
        _previousValue = _currentValue;
      } else if (_previousOperation == 'x') {
        _previousValue = _previousValue * _currentValue;
      } else if (_previousOperation == '/') {
        _previousValue = _previousValue / _currentValue;
      }
      _displayValue = _previousValue;
      _currentValue = 0;
      _previousOperation = text;
    } else if (text == '+' || text == '-') {
      if (_previousOperation == 'x') {
        _memorialValue = _previousValue * _currentValue;
        _previousValue = 0;
        _previousOperation = '';
      } else if (_previousOperation == '/') {
        _memorialValue = _previousValue / _currentValue;
        _previousValue = 0;
        _previousOperation = '';
      } else if (_memorialOperation == '') {
        _memorialValue = _currentValue;
      } else if (_memorialOperation == '+') {
        _memorialValue = _memorialValue + _currentValue;
      } else if (_memorialOperation == '-') {
        _memorialValue = _memorialValue - _currentValue;
      }

      _displayValue = _memorialValue;
      _currentValue = 0;
      _memorialOperation = text;
    } else {
      // 数値の入力

      final numberOfDigits = getNumberOfDigits(_currentValue);

      if (numberOfDigits + _numAfterPoint == maxNumberOfDigits) {
        // 最大桁数のため、入力させない
      } else if (_hasPoint) {
        _numAfterPoint++;
        _currentValue = _currentValue + int.parse(text) * math.pow(0.1, _numAfterPoint);
      } else if (_currentValue == 0) {
        _currentValue = double.parse(text);
      } else {
        _currentValue = _currentValue * 10 + double.parse(text);
      }

      _displayValue = _currentValue;
    }

    if (_hasPoint) {
      _text = getDisplayText(_displayValue, numAfterPoint: _numAfterPoint);
    } else {
      _text = getDisplayText(_displayValue);
    }
  }

  ///
  void _clear() {
    _currentValue = 0;
    _previousValue = 0;
    _memorialValue = 0;
    _previousOperation = '';
    _memorialOperation = '';
    _text = '0';
  }

  ///
  String getDisplayText(double value, {int numAfterPoint = -1}) {
    if (numAfterPoint != -1) {
      // 小数点以下あり

      final intPart = value.toInt();

      if (numAfterPoint == 0) {
        // 最後が「.」になる場合 例:1.
        return '${formatter.format(value)}.';
      } else if (intPart == value) {
        // 値の整数部分と、全ての値が一致する場合 例:1.0
        return formatter.format(intPart) + (value - intPart).toStringAsFixed(numAfterPoint).substring(1);
      }

      final digit = getNumberOfDigits(value);

      final decimalPart = maxNumberOfDigits - digit;

      final roundedValue = round(value, decimalPart);

      return formatter.format(roundedValue);
    }
    return formatter.format(value);
  }

  ///
  int getNumberOfDigits(double value) {
    var i = 0;
    for (; 10 <= value; i++) {
      // ignore: parameter_assignments
      value = value / 10;
    }
    return i + 1;
  }

  ///
  double round(double value, int numberOfDigits) {
    final key = math.pow(10, numberOfDigits).toInt();
    return (value * key).roundToDouble() / key;
  }
}
