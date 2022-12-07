import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  Size get getScreenSize => MediaQuery.of(this).size;

  bool get isModalOpen{
    return ModalRoute.of(this)?.isCurrent != true;
  }

  void dismissModal(){
    if(isModalOpen){
      Navigator.pop(this);
    }
  }
}

