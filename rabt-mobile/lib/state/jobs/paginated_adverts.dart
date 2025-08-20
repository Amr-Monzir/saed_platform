import '../../models/advert.dart';

class PaginatedAdverts {
  PaginatedAdverts({required this.items, required this.totalPages});
  final List<AdvertResponse> items;
  final int totalPages;
}


