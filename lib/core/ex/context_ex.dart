import 'package:flutter/material.dart';

extension ContextEx on BuildContext{
 TextStyle?  get appBarTitleTheme => Theme.of(this).textTheme.labelMedium;
 TextStyle?  get titleButton => Theme.of(this).textTheme.labelMedium;
}