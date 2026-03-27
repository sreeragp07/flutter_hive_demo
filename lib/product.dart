import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {

  @HiveField(0)
  String name;

  @HiveField(1)
  String price;

  Product({required this.name,required this.price});
}
