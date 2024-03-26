import 'package:cms_mobile/features/materials/presentation/bloc/materials_bloc.dart';
import 'package:cms_mobile/features/materials/presentation/bloc/materials_state.dart'
    as material_state;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        // child:Text('Materialssss')
        child: BlocBuilder<MaterialBloc, material_state.MaterialState>(
            builder: (_, state) {
          if (state is material_state.MaterialInitial) {
            return const Center(child: SizedBox());
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
