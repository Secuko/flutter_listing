import 'package:flutter/material.dart';
import 'package:flutter_work/features/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_work/features/catalog/ui/scope/catalog_scope.dart';
import 'package:scope/scope.dart';

class CatalogListener extends StatelessWidget {
  const CatalogListener({
    required this.child,
    super.key,
  });

  final Widget child;

  static Future<void> _listener(BuildContext context, CatalogState state) async {
    // switch (state) {
    //   case final CatalogStateError v:
    //     if (v.isError) {
    //       AppSnackBar.showRequestError(
    //         context,
    //         v.networkError,
    //         v.error,
    //         paddingBottom: 80,
    //       );
    //       if (v.networkError?.code == 401) {
    //         final storage = DependenciesScope.dependencies(context).localStorage;
    //         final token = storage.getToken();
    //         await storage.saveToken(
    //           Token(
    //             accessToken: token!.accessToken,
    //             isAuthorized: false,
    //           ),
    //         );
    //       }
    //     }
    //   default:
    //     null;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return StreamListener(
      listener: _listener,
      stream: CatalogScope.streamOf,
      child: child,
    );
  }
}
