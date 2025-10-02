import 'package:base_project/product/constants/navigation/navigation_constants.dart';
import 'package:go_router/go_router.dart';

import '../../feature/main/main_bloc.dart';
import '../../feature/main/main_screen.dart';
import '../base/bloc/base_bloc.dart';
import '../constants/enums/app_route_enums.dart';

GoRouter goRouter() {
  return GoRouter(
    debugLogDiagnostics: true,
    // errorBuilder: (context, state) => const NotFoundScreen(),
    initialLocation: NavigationConstants.HOME_PATH,
    routes: <RouteBase>[
      // GoRoute(
      //   path: ApplicationConstants.LOGIN_PATH,
      //   name: AppRoutes.LOGIN.name,
      //   builder: (context, state) => BlocProvider(
      //     child: const LoginScreen(),
      //     blocBuilder: () => LoginBloc(),
      //   ),
      // ),
      GoRoute(
        path: NavigationConstants.HOME_PATH,
        name: AppRoutes.HOME.name,
        builder: (context, state) => BlocProvider(
          child: const MainScreen(),
          blocBuilder: () => MainBloc(),
        ),
      ),
      // GoRoute(
      //   path: ApplicationConstants.SETTINGS_PATH,
      //   name: AppRoutes.SETTINGS.name,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //     child: BlocProvider(
      //       child: const SettingsScreen(),
      //       blocBuilder: () => SettingsBloc(),
      //     ),
      //     transitionsBuilder: transitionsBottomToTop,
      //   ),
      // ),
      // GoRoute(
      //   path: '${ApplicationConstants.DEVICES_UPDATE_PATH}/:thingID',
      //   name: AppRoutes.DEVICE_UPDATE.name,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //       child: BlocProvider(
      //         child: DeviceUpdateScreen(
      //           thingID: state.pathParameters['thingID']!,
      //         ),
      //         blocBuilder: () => DeviceUpdateBloc(),
      //       ),
      //       transitionsBuilder: transitionsBottomToTop),
      // ),
      // GoRoute(
      //     path: '${ApplicationConstants.GROUP_PATH}/:groupId',
      //     name: AppRoutes.GROUP_DETAIL.name,
      //     pageBuilder: (context, state) {
      //       final groupId = state.pathParameters['groupId']!;
      //       final role = state.extra! as String;
      //       return CustomTransitionPage(
      //           child: BlocProvider(
      //             child: DetailGroupScreen(group: groupId, role: role),
      //             blocBuilder: () => DetailGroupBloc(),
      //           ),
      //           transitionsBuilder: transitionsRightToLeft);
      //     }),
    ],
  );
}
