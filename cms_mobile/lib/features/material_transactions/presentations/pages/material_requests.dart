import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<MaterialRequestEntity> materialRequests = [
  const MaterialRequestEntity(
    id: '1',
    status: MaterialRequestStatus.pending,
  ),
  const MaterialRequestEntity(
    id: '2',
    status: MaterialRequestStatus.pending,
  ),
  const MaterialRequestEntity(
    id: '3',
    status: MaterialRequestStatus.pending,
  ),
];

class MaterialRequestsPage extends StatelessWidget {
  const MaterialRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   BlocProvider.of<MaterialRequestBloc>(context)
    //       .add(const GetMaterialRequest());
    // });
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              context.goNamed(RouteNames.createMaterialRequest);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Create Material Request'),
          ),
        ),
      ),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Material Requests'),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<MaterialRequestBloc, MaterialRequestState>(
      builder: (_, state) {
        // if (state is MaterialRequestInitial) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }

        // if (state is MaterialRequestLoading) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }

        // if (state is MaterialRequestSuccess) {
        return ListView.builder(
          itemCount: materialRequests.length,
          itemBuilder: (_, index) {
            final materialRequest = materialRequests[index];
            return ListTile(
              title: Text(materialRequest.id!),
            );
          },
        );
        // }

        // if (state is MaterialRequestFailed) {
        //   return Center(
        //     child: Text(state.error!.errorMessage),
        //   );
        // }

        // return const SizedBox();
      },
    );
  }
}
