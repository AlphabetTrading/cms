import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_bloc.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_state.dart';
import 'package:cms_mobile/features/home/presentation/widgets/material_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialTransactionsTabScreen extends StatefulWidget {
  const MaterialTransactionsTabScreen({super.key});

  @override
  State<MaterialTransactionsTabScreen> createState() =>
      _MaterialTransactionsTabScreenState();
}

class _MaterialTransactionsTabScreenState
    extends State<MaterialTransactionsTabScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<MaterialTransactionBloc>()
        .add(const GetMaterialTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Documents',
              style: TextStyle(
                color: Color.fromARGB(255, 40, 41, 41),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<MaterialTransactionBloc,
                  MaterialTransactionState>(
                builder: (_, state) {
                  if (state is MaterialTransactionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is MaterialTransactionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is MaterialTransactionsuccess) {
                    return Expanded(
                        child: MaterialTransactionsList(
                            materialRequests: state.materialTransactions!));
                  }

                  if (state is MaterialTransactionFailed) {
                    return Center(
                      child: Text(state.error!.errorMessage),
                    );
                  }

                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
