import 'package:cms_mobile/config/gql.client.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class PurchaseOrderDataSource {
  Future<DataState<PurchaseOrdersListWithMeta>> fetchPurchaseOrders({
    FilterPurchaseOrderInput? filterPurchaseOrderInput,
    OrderByPurchaseOrderInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  });

  Future<DataState<String>> createPurchaseOrder(
      {required CreatePurchaseOrderParamsModel createPurchaseOrderParamsModel});

  Future<DataState<PurchaseOrderModel>> getPurchaseOrderDetails(
      {required String params});

  Future<DataState<String>> editPurchaseOrder(
      {required EditPurchaseOrderParamsEntity editPurchaseOrderParamsModel});

  Future<DataState<String>> deletePurchaseOrder({required String materialId});

  Future<DataState<String>> generatePurchaseOrderPdf({required String id});
}

class PurchaseOrderDataSourceImpl extends PurchaseOrderDataSource {
  late final GraphQLClient _client;

  PurchaseOrderDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  @override
  Future<DataState<PurchaseOrderModel>> getPurchaseOrderDetails(
      {required String params}) {
    String fetchPurchaseOrderDetailsQuery = r'''
      query GetPurchaseOrderById($getPurchaseOrderByIdId: String!) {
        getPurchaseOrderById(id: $getPurchaseOrderByIdId) {
          id
          serialNumber
          projectId
          subTotal
          vat
          status
          grandTotal
          createdAt
          updatedAt
          approvedById
          preparedById
          preparedBy {
            createdAt
            email
            fullName
            id
            phoneNumber
            role
            updatedAt
          }
          approvedBy {
            createdAt
            email
            fullName
            id
            phoneNumber
            role
            updatedAt
          }
          items {
            id
            quantity
            remark
            totalPrice
            unitPrice
            createdAt
            materialRequestItemId
            materialRequestItem {
              createdAt
              id
              productVariantId
              productVariant {
                id
                variant
                unitOfMeasure
                product {
                  name
                }
              }
              quantity
              remark
              updatedAt
            }
            proforma {
              id
              serialNumber
              projectId
              status
              updatedAt
              selectedProformaItemId
              materialRequestItemId
              materialRequestItem {
                id
                productVariantId
                productVariant {
                  id
                  variant
                  unitOfMeasure
                  product {
                    name
                  }
                }
                quantity
                remark
                updatedAt
              }
              selectedProformaItem {
                createdAt
                id
                photos
                quantity
                remark
                totalPrice
                unitPrice
                updatedAt
                vendor
              }
            }
            proformaId
            purchaseOrderId
            updatedAt
          }
        }
      }
    ''';

    return _client
        .query(QueryOptions(
      document: gql(fetchPurchaseOrderDetailsQuery),
      variables: {"getPurchaseOrderByIdId": params},
    ))
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      print("****************************");
      print(response.data!['getPurchaseOrderById']);
      final purchaseOrder =
          PurchaseOrderModel.fromJson(response.data!['getPurchaseOrderById']);

      return DataSuccess(purchaseOrder);
    });
  }

  @override
  Future<DataState<String>> createPurchaseOrder(
      {required CreatePurchaseOrderParamsModel
          createPurchaseOrderParamsModel}) async {
    const String _createPurchaseOrderMutation = r'''
      mutation CreatePurchaseOrder($createPurchaseOrderInput: CreatePurchaseOrderInput!) {
        createPurchaseOrder(createPurchaseOrderInput: $createPurchaseOrderInput) {
          id
        }
      }
    ''';

    List<Map<String, dynamic>> purchaseOrderMaterialsMap =
        createPurchaseOrderParamsModel.purchaseOrderMaterials
            .map((purchaseOrderMaterial) {
      final isProforma = createPurchaseOrderParamsModel.isProforma;
      return {
        "quantity": purchaseOrderMaterial.quantity,
        "unitPrice": purchaseOrderMaterial.unitPrice,
        "totalPrice": purchaseOrderMaterial.totalPrice,
        if (isProforma) "proformaId": purchaseOrderMaterial.proformaId ?? "",
        if (!isProforma)
          "materialRequestItemId":
              purchaseOrderMaterial.materialRequestItemId ?? "",
        "remark": purchaseOrderMaterial.remark ?? "",
      };
    }).toList();

    final MutationOptions options = MutationOptions(
      document: gql(_createPurchaseOrderMutation),
      variables: {
        "createPurchaseOrderInput": {
          "preparedById": createPurchaseOrderParamsModel.preparedById,
          "projectId": createPurchaseOrderParamsModel.projectId,
          "items": purchaseOrderMaterialsMap
        }
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      final String id = result.data!['createPurchaseOrder']['id'];

      return DataSuccess(id);
    } catch (e) {
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deletePurchaseOrder(
      {required String materialId}) async {
    const String _deletePurchaseOrderMutation = r'''
      mutation DeletePurchaseOrder($deletePurchaseOrderId: String!) {
        deletePurchaseOrder(id: $deletePurchaseOrderId) {
          id
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(_deletePurchaseOrderMutation),
      variables: {"deletePurchaseOrderId": materialId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `PurchaseOrderModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deletePurchaseOrder']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> generatePurchaseOrderPdf({required String id}) {
    String generatePurchaseOrderPdfQuery = r'''
      query Query($generatePurchaseOrderPdfId: String!) {
        generatePurchaseOrderPdf(id: $generatePurchaseOrderPdfId)
      }
    ''';

    return _client
        .query(QueryOptions(
      document: gql(generatePurchaseOrderPdfQuery),
      variables: {"generatePurchaseOrderPdfId": id},
      fetchPolicy: FetchPolicy.noCache,
    ))
        .then((response) {
      if (response.hasException) {
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      final purchaseOrderReport = response.data!['generatePurchaseOrderPdf'];

      return DataSuccess(purchaseOrderReport);
      
    });
  }

  @override
  Future<DataState<String>> editPurchaseOrder(
      {required EditPurchaseOrderParamsEntity<PurchaseOrderEntity>
          editPurchaseOrderParamsModel}) {
    // TODO: implement editPurchaseOrder
    throw UnimplementedError();
  }

  @override
  Future<DataState<PurchaseOrdersListWithMeta>> fetchPurchaseOrders({
    FilterPurchaseOrderInput? filterPurchaseOrderInput,
    OrderByPurchaseOrderInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  }) async {
    String fetchMaterialReceiveQuery;

    fetchMaterialReceiveQuery = r'''
        query GetPurchaseOrders($mine: Boolean!, $filterPurchaseOrderInput: FilterPurchaseOrderInput, $orderBy: OrderByPurchaseOrderInput, $paginationInput: PaginationInput) {
          getPurchaseOrders(mine: $mine, filterPurchaseOrderInput: $filterPurchaseOrderInput, orderBy: $orderBy, paginationInput: $paginationInput) {
            items {
              approvedBy {
                createdAt
                email
                fullName
                id
                phoneNumber
                role
                updatedAt
              }
              approvedById
              createdAt
              grandTotal
              id
              items {
                materialRequestItem {
                  productVariant {
                        id
                        unitOfMeasure
                        variant
                        product {
                          id
                          name
                        }
                  }
              }
              proforma{
              id
              materialRequestItem {
                  productVariant {
                        id
                        unitOfMeasure
                        variant
                        product {
                          id
                          name
                        }
                  }
              }
              }
           
                createdAt
                id
                materialRequestItemId
                proforma {
                  approvedBy {
                    createdAt
                    email
                    fullName
                    id
                    phoneNumber
                    role
                    updatedAt
                  }
                  approvedById
                  createdAt
                  id
                  materialRequestItemId
                  preparedBy {
                    createdAt
                    email
                    fullName
                    id
                    phoneNumber
                    role
                    updatedAt
                  }
                  preparedById
                  projectId
                  serialNumber
                  status
                  updatedAt
                  selectedProformaItem {
                    createdAt
                    id
                    photos
                    quantity
                    remark
                    totalPrice
                    unitPrice
                    updatedAt
                    vendor
                  }
                  selectedProformaItemId
                  materialRequestItem {
                    createdAt
                    id
                    productVariantId
                    quantity
                    remark
                    updatedAt
                  }
                }
                proformaId
                purchaseOrderId
                quantity
                remark
                totalPrice
                unitPrice
                updatedAt
                materialRequestItem {
                  createdAt
                  id
                  productVariantId
                  quantity
                  remark
                  updatedAt
                }
              }
              preparedBy {
                createdAt
                email
                fullName
                id
                phoneNumber
                role
                updatedAt
              }
              preparedById
              projectId
              serialNumber
              status
              subTotal
              updatedAt
              vat
            }
            meta {
              count
              limit
              page
            }
          }
        }
    ''';

    final filterInput = filterPurchaseOrderInput?.toJson();
    final selectedProjectId =
        await GQLClient.getFromLocalStorage('selected_project_id');
    debugPrint("purchase order is loading");
    debugPrint('selectedProjectId: $selectedProjectId');
    filterInput!["projectId"] = selectedProjectId;
    debugPrint('filterInput: $filterInput');
    return _client
        .query(
      QueryOptions(
        document: gql(fetchMaterialReceiveQuery),
        variables: {
          'filterPurchaseOrderInput': filterInput,
          'orderBy': orderBy ?? {},
          'paginationInput': paginationInput ?? {},
          "mine": mine ?? false,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    )
        .then((response) {
      if (response.hasException) {
        debugPrint(
            'fetchMaterialReceiveQuery: ${response.exception.toString()}');
        return DataFailed(
          ServerFailure(
            errorMessage: response.exception.toString(),
          ),
        );
      }

      debugPrint('filterPurchaseOrderInput: ${response.data}');
      final receivings = response.data!['getPurchaseOrders']["items"] as List;

      debugPrint('filterPurchaseOrderInput: $receivings');
      final meta = response.data!['getPurchaseOrders']["meta"];

      final items =
          receivings.map((e) => PurchaseOrderModel.fromJson(e)).toList();

      debugPrint(
          '******************Successfully converted to MaterialReceiveModel: $items');

      return DataSuccess(
        PurchaseOrdersListWithMeta(
          items: items,
          meta: MetaModel.fromJson(meta),
        ),
      );
    });
  }
}
