import 'package:rabt_mobile/models/advert.dart';

class PaginatedAdverts {
  PaginatedAdverts({required this.items, required this.totalPages});
  final List<Advert> items;
  final int totalPages;
}
