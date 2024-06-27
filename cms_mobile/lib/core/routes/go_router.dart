import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_page.dart';
import 'package:cms_mobile/features/home/presentation/pages/HomePage.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/material_issue_details.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/material_issue_edit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_request/create_material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issues.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_request/material_request_details.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_requests.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/purchase_orders.dart';
import 'package:cms_mobile/features/products/presentation/pages/products_page.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/pages/milestone_details.dart';
import 'package:cms_mobile/features/progress/presentation/pages/task_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter _router;

  AppRouter({Key? key}) {
    debugPrint('AppRouter');
    _router = GoRouter(
      initialLocation: RoutePaths.home,
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state.status;
        final isAuthenticated = authState == AuthStatus.signedIn;
        if (isAuthenticated &&
            (state.matchedLocation == '/${RoutePaths.login}' ||
                state.matchedLocation == '/${RoutePaths.forgotPassword}' ||
                state.matchedLocation == '/${RoutePaths.resetPassword}' ||
                state.matchedLocation == '/${RoutePaths.signup}')) {
          return RoutePaths.home;
        }
        if (!isAuthenticated && state.path == '/${RoutePaths.login}' ||
            state.matchedLocation == '/${RoutePaths.forgotPassword}' ||
            state.matchedLocation == '/${RoutePaths.resetPassword}' ||
            state.matchedLocation == '/${RoutePaths.signup}') {
          return state.matchedLocation;
        }

        if (!isAuthenticated) {
          return '/${RoutePaths.login}';
        }

        if (isAuthenticated) {
          return state.matchedLocation;
        }
        return RoutePaths.home;
      },
      routes: <RouteBase>[
        GoRoute(
          name: RouteNames.home,
          path: RoutePaths.home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
          routes: <RouteBase>[
            GoRoute(
              name: RouteNames.milestoneDetails,
              path: RoutePaths.milestoneDetails,
              builder: (BuildContext context, GoRouterState state) {
                return MilestoneDetailsPage(
                  milestoneId: state.pathParameters['milestoneId']!,
                );
              },
            ),
            GoRoute(
                name: RouteNames.taskDetails,
                path: RoutePaths.taskDetails,
                builder: (BuildContext context, GoRouterState state) {
                  TaskEntity task = state.extra as TaskEntity; //
                  return TaskDetails(task: task);
                }),
            GoRoute(
              name: RouteNames.items,
              path: RoutePaths.items,
              builder: (BuildContext context, GoRouterState state) {
                return ProductsPage(
                  warehouseId: state.pathParameters['warehouseId']!,
                );
              },
            ),
            GoRoute(
                name: RouteNames.login,
                path: RoutePaths.login,
                builder: (BuildContext context, GoRouterState state) {
                  return const LoginPage();
                }),
            GoRoute(
              name: RouteNames.materialIssue,
              path: RoutePaths.materialIssue,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialIssuesPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.materialIssueCreate,
                  path: RoutePaths.materialIssueCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const MaterialIssueCreatePage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialIssueDetails,
                  path: RoutePaths.materialIssueDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialIssueDetailsPage(
                        materialIssueId:
                            state.pathParameters['materialIssueId']!);
                  },
                ),
                GoRoute(
                  name: RouteNames.materialIssueEdit,
                  path: RoutePaths.materialIssueEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialIssueEditPage(
                        materialIssueId:
                            state.pathParameters['materialIssueId']!);
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.materialRequests,
              path: RoutePaths.materialRequests,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialRequestsPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.materialRequestCreate,
                  path: RoutePaths.materialRequestCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialRequestEdit,
                  path: RoutePaths.materialRequestEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialRequestDetails,
                  path: RoutePaths.materialRequestDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialRequestDetailsPage(
                        materialRequestId:
                            state.pathParameters['materialRequestId']!);
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.materialTransfer,
              path: RoutePaths.materialTransfer,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialTransferPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.materialTransferCreate,
                  path: RoutePaths.materialTransferCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialTransferEdit,
                  path: RoutePaths.materialTransferEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialTransferDetails,
                  path: RoutePaths.materialTransferDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialRequestDetailsPage(
                        materialRequestId:
                            state.pathParameters['materialTransferId']!);
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.materialReceiving,
              path: RoutePaths.materialReceiving,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialReceivingPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.materialReceivingCreate,
                  path: RoutePaths.materialReceivingCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialReceivingEdit,
                  path: RoutePaths.materialReceivingEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.materialReceivingDetails,
                  path: RoutePaths.materialReceivingDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialRequestDetailsPage(
                        materialRequestId:
                            state.pathParameters['materialReceivingId']!);
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.materialReturn,
              path: RoutePaths.materialReturn,
              builder: (BuildContext context, GoRouterState state) {
                return const MaterialReturnsPage();
              },
            ),
            GoRoute(
              name: RouteNames.purchaseOrder,
              path: RoutePaths.purchaseOrder,
              builder: (BuildContext context, GoRouterState state) {
                return const PurchaseOrdersPage();
              },
              routes: <RouteBase>[
                GoRoute(
                  name: RouteNames.purchaseOrderCreate,
                  path: RoutePaths.purchaseOrderCreate,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.purchaseOrderEdit,
                  path: RoutePaths.purchaseOrderEdit,
                  builder: (BuildContext context, GoRouterState state) {
                    return const CreateMaterialRequestPage();
                  },
                ),
                GoRoute(
                  name: RouteNames.purchaseOrderDetails,
                  path: RoutePaths.purchaseOrderDetails,
                  builder: (BuildContext context, GoRouterState state) {
                    return MaterialRequestDetailsPage(
                        materialRequestId:
                            state.pathParameters['purchaseOrderId']!);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  GoRouter get router => _router;
}
