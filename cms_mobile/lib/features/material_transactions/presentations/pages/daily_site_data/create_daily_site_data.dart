import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/utils/ids.dart';

import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data/daily_site_datas_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/create_daily_site_data_form.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class DailySiteDataCreatePage extends StatefulWidget {
  const DailySiteDataCreatePage({super.key});

  @override
  State<DailySiteDataCreatePage> createState() =>
      _DailySiteDataCreatePageState();
}

class _DailySiteDataCreatePageState extends State<DailySiteDataCreatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(GetAllWarehouseProducts(
      context.read<ProjectBloc>().state.selectedProjectId ?? "",
    ));
  }

  // final String savedUserId = await GQLClient.getUserIdFromStorage();

  _buildOnCreateSuccess(BuildContext context) {
    // context.goNamed(RouteNames.dailySiteData);
    BlocProvider.of<DailySiteDataLocalBloc>(context)
        .add(const ClearDailySiteDataMaterialsLocal());
    context.pop();
    Fluttertoast.showToast(
        msg: "Daily site data task created successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 1, 135, 23),
        textColor: Colors.white,
        fontSize: 16.0);

    context.read<DailySiteDataBloc>().add(
          GetDailySiteDatas(
            filterDailySiteDataInput: FilterDailySiteDataInput(),
            orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 20),
          ),
        );
  }

  _buildOnCreateFailed(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Create Daily Side Data Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // final dailySiteDataFormCubit = context.watch<DailySiteDataFormCubit>();
    return BlocBuilder<DailySiteDataLocalBloc, DailySiteDataLocalState>(
        builder: (localContext, localState) {
      return BlocConsumer<DailySiteDataBloc, DailySiteDataState>(
        listener: (issueContext, issueState) {
          debugPrint("Daily Site Data Create Page: $issueState");
          if (issueState is CreateDailySiteDataSuccess) {
            _buildOnCreateSuccess(issueContext);
          } else if (issueState is CreateDailySiteDataFailed) {
            _buildOnCreateFailed(issueContext);
          }
        },
        builder: (issueContext, issueState) {
          return Scaffold(
            appBar: AppBar(title: const Text("Create Daily Site data")),
            bottomSheet: _buildButtons(issueContext, localState, issueState),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      "Tasks to be added:",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // (localState.dailySiteDataMaterials == null ||
                    //         localState
                    //             .dailySiteDataMaterials!.isEmpty)
                    //     SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

_buildButtons(
  BuildContext context,
  DailySiteDataLocalState localState,
  DailySiteDataState state,
) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      OutlinedButton(
        // onPressed:(){},
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<DailySiteDataFormCubit>(
                create: (_) => DailySiteDataFormCubit(),
              )
            ],
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CreateDailySiteDataForm(),
                  // child: SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text('Add Task'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: (state is CreateDailySiteDataLoading ||
                localState.dailySiteDataMaterials == null ||
                localState.dailySiteDataMaterials!.isEmpty)
            ? null
            : () {
                context.read<DailySiteDataBloc>().add(
                      CreateDailySiteDataEvent(
                        createDailySiteDataParamsEntity:
                            CreateDailySiteDataParamsEntity(
                          projectId: context
                                  .read<ProjectBloc>()
                                  .state
                                  .selectedProjectId ??
                              "",
                          preparedById:
                              context.read<AuthBloc>().state.user?.id ??
                                  USER_ID,
                          tasks: [],
                        ),
                      ),
                    );

                context.read<DailySiteDataBloc>().add(
                      GetDailySiteDatas(
                        filterDailySiteDataInput: FilterDailySiteDataInput(),
                        orderBy: OrderByDailySiteDataInput(createdAt: "desc"),
                        paginationInput: PaginationInput(skip: 0, take: 10),
                      ),
                    );
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            state is CreateDailySiteDataLoading
                ? const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        )),
                  )
                : const SizedBox(),
            const Text('Send Daily Site Data')
          ],
        ),
      )
    ]),
  );
}
