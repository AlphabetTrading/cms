import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_requests/material_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrdersPage extends StatelessWidget {
  const PurchaseOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Purchase Orders'),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<MaterialRequestBloc, MaterialRequestState>(
      builder: (_, state) {
        if (state is MaterialRequestInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MaterialRequestLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MaterialRequestSuccess) {
          return ListView.builder(
            itemCount: state.materialRequests!.length,
            itemBuilder: (_, index) {
              final materialRequest = state.materialRequests![index];
              return ListTile(
                title: Text(materialRequest.id!),
              );
            },
          );
        }

        if (state is MaterialRequestFailed) {
          return Center(
            child: Text(state.error!.errorMessage),
          );
        }

        return const SizedBox();
      },
    );
  }
}
