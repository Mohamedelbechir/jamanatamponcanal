enum SyncCollection {
  customers,
  decoders,
  bouquets,
  subscriptions,
  futureSubscriptionPayments,
}

class SyncMutation {
  const SyncMutation({
    required this.collection,
    required this.entityId,
    this.deleted = false,
  });

  final SyncCollection collection;
  final int entityId;
  final bool deleted;

  factory SyncMutation.upsert(SyncCollection collection, int entityId) {
    return SyncMutation(collection: collection, entityId: entityId);
  }

  factory SyncMutation.delete(SyncCollection collection, int entityId) {
    return SyncMutation(
      collection: collection,
      entityId: entityId,
      deleted: true,
    );
  }

  String get key => '${collection.name}:$entityId';

  Map<String, dynamic> toJson() => {
        'collection': collection.name,
        'entityId': entityId,
        'deleted': deleted,
      };

  factory SyncMutation.fromJson(Map<String, dynamic> json) {
    return SyncMutation(
      collection: SyncCollection.values.byName(json['collection'] as String),
      entityId: (json['entityId'] as num).toInt(),
      deleted: json['deleted'] as bool? ?? false,
    );
  }
}

String syncCollectionName(SyncCollection collection) {
  switch (collection) {
    case SyncCollection.customers:
      return 'customers';
    case SyncCollection.decoders:
      return 'decoders';
    case SyncCollection.bouquets:
      return 'bouquets';
    case SyncCollection.subscriptions:
      return 'subscriptions';
    case SyncCollection.futureSubscriptionPayments:
      return 'futureSubscriptionPayments';
  }
}
