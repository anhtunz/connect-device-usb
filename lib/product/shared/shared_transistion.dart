import 'package:flutter/material.dart';

/// Hiệu ứng di chuyển từ phải qua trái
Widget transitionsRightToLeft(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Hiệu ứng di chuyển từ trái sang phải
Widget transitionsLeftToRight(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(-1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Hiệu ứng di chuyển từ dưới lên trên
Widget transitionsBottomToTop(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Hiệu ứng di chuyển từ trên xuống dưới
Widget transitionsTopToBottom(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(0.0, -1.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Hiệu ứng mở dần vào và ra
Widget transitionsFaded(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = 0.0;
  const end = 1.0;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var fadeAnimation = animation.drive(tween);

  return FadeTransition(
    opacity: fadeAnimation,
    child: child,
  );
}

/// Hiệu ứng di chuyển từ kích thước nhỏ đến đầy đủ
Widget transitionsScale(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = 0.0; // Bắt đầu từ kích thước 0
  const end = 1.0; // Kết thúc ở kích thước 1
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var scaleAnimation = animation.drive(tween);

  return ScaleTransition(
    scale: scaleAnimation,
    child: child,
  );
}

Widget transitionsTotation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = 0.0; // Bắt đầu từ góc 0 độ
  const end = 1.0; // Kết thúc ở góc 1 vòng (360 độ)
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var rotationAnimation = animation.drive(tween);

  return RotationTransition(
    turns: rotationAnimation,
    child: child,
  );
}

/// Hiệu ứng kết hợp (Di chuyển và mờ dần)
Widget transitionsCustom1(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const beginOffset = Offset(1.0, 0.0); // Di chuyển từ phải vào
  const endOffset = Offset.zero;
  const beginOpacity = 0.0; // Bắt đầu từ độ mờ 0
  const endOpacity = 1.0; // Kết thúc ở độ mờ 1

  var offsetTween = Tween(begin: beginOffset, end: endOffset);
  var opacityTween = Tween(begin: beginOpacity, end: endOpacity);

  var offsetAnimation =
  animation.drive(offsetTween.chain(CurveTween(curve: Curves.easeInOut)));
  var opacityAnimation =
  animation.drive(opacityTween.chain(CurveTween(curve: Curves.easeInOut)));

  return FadeTransition(
    opacity: opacityAnimation,
    child: SlideTransition(
      position: offsetAnimation,
      child: child,
    ),
  );
}
