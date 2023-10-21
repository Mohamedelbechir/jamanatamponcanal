class BouquetDetail {
  final int id;
  final String name;
  final int nombreOfActiveSubcription;
  final DateTime? updateAt;
  final bool obsolte;

  BouquetDetail({
    required this.id,
    required this.name,
    required this.nombreOfActiveSubcription,
    required this.updateAt,
    required this.obsolte,
  });
}
