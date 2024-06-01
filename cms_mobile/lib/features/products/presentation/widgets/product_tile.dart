import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductTile extends StatelessWidget {
  final WarehouseProductEntity warehouseProductEntity;
  const ProductTile({super.key, required this.warehouseProductEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: const Color(0x110F4A84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(5),
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: warehouseProductEntity.productVariant.product?.iconSrc != null
                ? SvgPicture.asset(
                    warehouseProductEntity.productVariant.product!.iconSrc!,
                  )
                : const SizedBox(),
          ),
          title: Text(
              '${warehouseProductEntity.productVariant.product?.name??""} ${warehouseProductEntity.productVariant.variant??""}'),
          subtitle: Text(
              '${warehouseProductEntity.quantity.toString()} ${warehouseProductEntity.productVariant.unitOfMeasure}'),
          trailing: TextButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(32.0),
                child: Wrap(children: [
                  Column(
                    children: [
                      ProductDetail(
                          title: "Name",
                          value:
                              '${warehouseProductEntity.productVariant.product?.name} - ${warehouseProductEntity.productVariant.variant}'),
                      const SizedBox(
                        height: 10,
                      ),
                      ProductDetail(
                          title: "Quantity",
                          value:
                              '${warehouseProductEntity.quantity.toString()} ${warehouseProductEntity.productVariant.unitOfMeasure}'),
                      const SizedBox(
                        height: 10,
                      ),
                      // productDetailProduct(
                      //     title: "Unit", value: productEntity.unit),
                    ],
                  )
                ]),
              ),
            ),
            child: const Text(
              "View More",
              style: TextStyle(fontSize: 12),
            ),
          )),
    );
  }
}
