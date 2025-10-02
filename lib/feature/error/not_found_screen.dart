import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../product/constants/enums/app_route_enums.dart';
import '../../product/constants/image/image_constants.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImageConstants.instance.getImage('error_page'),
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: TextButton(
              onPressed: () {
                context.goNamed(AppRoutes.LOGIN.name);
              },
              child: Text(
                "Go Home".toUpperCase(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
