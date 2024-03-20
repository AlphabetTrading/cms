abstract class MaterialRequestEvent{
  const MaterialRequestEvent();
}

class GetMaterialRequests extends MaterialRequestEvent{
  const GetMaterialRequests();
}

class GetMaterialRequest extends MaterialRequestEvent{
  final String id;
  const GetMaterialRequest(this.id);
}

class CreateMaterialRequest extends MaterialRequestEvent{
  final String id;
  const CreateMaterialRequest(this.id);
}

class UpdateMaterialRequest extends MaterialRequestEvent{
  final String id;
  const UpdateMaterialRequest(this.id);
}

class DeleteMaterialRequest extends MaterialRequestEvent{
  final String id;
  const DeleteMaterialRequest(this.id);
}
