abstract class MaterialEvent{
  const MaterialEvent();
}

class GetMaterials extends MaterialEvent{
  const GetMaterials();
}

class GetMaterial extends MaterialEvent{
  final String id;
  const GetMaterial(this.id); 
}
class CreateMaterial extends MaterialEvent{
  final String id;
  const CreateMaterial(this.id);
}

class UpdateMaterial extends MaterialEvent{
  final String id;
  const UpdateMaterial(this.id);
}

class DeleteMaterial extends MaterialEvent{
  final String id;
  const DeleteMaterial(this.id);
}