abstract class MaterialTransactionEvent{
  const MaterialTransactionEvent();
}

class GetMaterialTransactions extends MaterialTransactionEvent{
  const GetMaterialTransactions();
}

class GetMaterialTransaction extends MaterialTransactionEvent{
  final String id;
  const GetMaterialTransaction(this.id);
}

class CreateMaterialTransaction extends MaterialTransactionEvent{
  final String id;
  const CreateMaterialTransaction(this.id);
}

class UpdateMaterialTransaction extends MaterialTransactionEvent{
  final String id;
  const UpdateMaterialTransaction(this.id);
}

class DeleteMaterialTransaction extends MaterialTransactionEvent{
  final String id;
  const DeleteMaterialTransaction(this.id);
}
