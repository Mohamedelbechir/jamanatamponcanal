// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BouquetsTable extends Bouquets with TableInfo<$BouquetsTable, Bouquet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BouquetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _obsoleteMeta =
      const VerificationMeta('obsolete');
  @override
  late final GeneratedColumn<bool> obsolete = GeneratedColumn<bool>(
      'obsolete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("obsolete" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, obsolete, createAt, updateAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bouquets';
  @override
  VerificationContext validateIntegrity(Insertable<Bouquet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('obsolete')) {
      context.handle(_obsoleteMeta,
          obsolete.isAcceptableOrUnknown(data['obsolete']!, _obsoleteMeta));
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bouquet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bouquet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      obsolete: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}obsolete'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at']),
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at']),
    );
  }

  @override
  $BouquetsTable createAlias(String alias) {
    return $BouquetsTable(attachedDatabase, alias);
  }
}

class Bouquet extends DataClass implements Insertable<Bouquet> {
  final int id;
  final String name;
  final bool obsolete;
  final DateTime? createAt;
  final DateTime? updateAt;
  const Bouquet(
      {required this.id,
      required this.name,
      required this.obsolete,
      this.createAt,
      this.updateAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['obsolete'] = Variable<bool>(obsolete);
    if (!nullToAbsent || createAt != null) {
      map['create_at'] = Variable<DateTime>(createAt);
    }
    if (!nullToAbsent || updateAt != null) {
      map['update_at'] = Variable<DateTime>(updateAt);
    }
    return map;
  }

  BouquetsCompanion toCompanion(bool nullToAbsent) {
    return BouquetsCompanion(
      id: Value(id),
      name: Value(name),
      obsolete: Value(obsolete),
      createAt: createAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createAt),
      updateAt: updateAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updateAt),
    );
  }

  factory Bouquet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bouquet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      obsolete: serializer.fromJson<bool>(json['obsolete']),
      createAt: serializer.fromJson<DateTime?>(json['createAt']),
      updateAt: serializer.fromJson<DateTime?>(json['updateAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'obsolete': serializer.toJson<bool>(obsolete),
      'createAt': serializer.toJson<DateTime?>(createAt),
      'updateAt': serializer.toJson<DateTime?>(updateAt),
    };
  }

  Bouquet copyWith(
          {int? id,
          String? name,
          bool? obsolete,
          Value<DateTime?> createAt = const Value.absent(),
          Value<DateTime?> updateAt = const Value.absent()}) =>
      Bouquet(
        id: id ?? this.id,
        name: name ?? this.name,
        obsolete: obsolete ?? this.obsolete,
        createAt: createAt.present ? createAt.value : this.createAt,
        updateAt: updateAt.present ? updateAt.value : this.updateAt,
      );
  @override
  String toString() {
    return (StringBuffer('Bouquet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('obsolete: $obsolete, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, obsolete, createAt, updateAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bouquet &&
          other.id == this.id &&
          other.name == this.name &&
          other.obsolete == this.obsolete &&
          other.createAt == this.createAt &&
          other.updateAt == this.updateAt);
}

class BouquetsCompanion extends UpdateCompanion<Bouquet> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> obsolete;
  final Value<DateTime?> createAt;
  final Value<DateTime?> updateAt;
  const BouquetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.obsolete = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
  });
  BouquetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.obsolete = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Bouquet> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? obsolete,
    Expression<DateTime>? createAt,
    Expression<DateTime>? updateAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (obsolete != null) 'obsolete': obsolete,
      if (createAt != null) 'create_at': createAt,
      if (updateAt != null) 'update_at': updateAt,
    });
  }

  BouquetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? obsolete,
      Value<DateTime?>? createAt,
      Value<DateTime?>? updateAt}) {
    return BouquetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      obsolete: obsolete ?? this.obsolete,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (obsolete.present) {
      map['obsolete'] = Variable<bool>(obsolete.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BouquetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('obsolete: $obsolete, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numberCustomerMeta =
      const VerificationMeta('numberCustomer');
  @override
  late final GeneratedColumn<String> numberCustomer = GeneratedColumn<String>(
      'number_customer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, firstName, lastName, phoneNumber, numberCustomer];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('number_customer')) {
      context.handle(
          _numberCustomerMeta,
          numberCustomer.isAcceptableOrUnknown(
              data['number_customer']!, _numberCustomerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      numberCustomer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number_customer']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? numberCustomer;
  const Customer(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.phoneNumber,
      this.numberCustomer});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || numberCustomer != null) {
      map['number_customer'] = Variable<String>(numberCustomer);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      numberCustomer: numberCustomer == null && nullToAbsent
          ? const Value.absent()
          : Value(numberCustomer),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      numberCustomer: serializer.fromJson<String?>(json['numberCustomer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'numberCustomer': serializer.toJson<String?>(numberCustomer),
    };
  }

  Customer copyWith(
          {int? id,
          String? firstName,
          String? lastName,
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> numberCustomer = const Value.absent()}) =>
      Customer(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        numberCustomer:
            numberCustomer.present ? numberCustomer.value : this.numberCustomer,
      );
  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('numberCustomer: $numberCustomer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, firstName, lastName, phoneNumber, numberCustomer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.phoneNumber == this.phoneNumber &&
          other.numberCustomer == this.numberCustomer);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> phoneNumber;
  final Value<String?> numberCustomer;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.numberCustomer = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    this.phoneNumber = const Value.absent(),
    this.numberCustomer = const Value.absent(),
  })  : firstName = Value(firstName),
        lastName = Value(lastName);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phoneNumber,
    Expression<String>? numberCustomer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (numberCustomer != null) 'number_customer': numberCustomer,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? phoneNumber,
      Value<String?>? numberCustomer}) {
    return CustomersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      numberCustomer: numberCustomer ?? this.numberCustomer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (numberCustomer.present) {
      map['number_customer'] = Variable<String>(numberCustomer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('numberCustomer: $numberCustomer')
          ..write(')'))
        .toString();
  }
}

class $DecodersTable extends Decoders with TableInfo<$DecodersTable, Decoder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecodersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES customers (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, number, customerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decoders';
  @override
  VerificationContext validateIntegrity(Insertable<Decoder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Decoder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Decoder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
    );
  }

  @override
  $DecodersTable createAlias(String alias) {
    return $DecodersTable(attachedDatabase, alias);
  }
}

class Decoder extends DataClass implements Insertable<Decoder> {
  final int id;
  final String number;
  final int customerId;
  const Decoder(
      {required this.id, required this.number, required this.customerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<String>(number);
    map['customer_id'] = Variable<int>(customerId);
    return map;
  }

  DecodersCompanion toCompanion(bool nullToAbsent) {
    return DecodersCompanion(
      id: Value(id),
      number: Value(number),
      customerId: Value(customerId),
    );
  }

  factory Decoder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Decoder(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      customerId: serializer.fromJson<int>(json['customerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<String>(number),
      'customerId': serializer.toJson<int>(customerId),
    };
  }

  Decoder copyWith({int? id, String? number, int? customerId}) => Decoder(
        id: id ?? this.id,
        number: number ?? this.number,
        customerId: customerId ?? this.customerId,
      );
  @override
  String toString() {
    return (StringBuffer('Decoder(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('customerId: $customerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, customerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Decoder &&
          other.id == this.id &&
          other.number == this.number &&
          other.customerId == this.customerId);
}

class DecodersCompanion extends UpdateCompanion<Decoder> {
  final Value<int> id;
  final Value<String> number;
  final Value<int> customerId;
  const DecodersCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.customerId = const Value.absent(),
  });
  DecodersCompanion.insert({
    this.id = const Value.absent(),
    required String number,
    required int customerId,
  })  : number = Value(number),
        customerId = Value(customerId);
  static Insertable<Decoder> custom({
    Expression<int>? id,
    Expression<String>? number,
    Expression<int>? customerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (customerId != null) 'customer_id': customerId,
    });
  }

  DecodersCompanion copyWith(
      {Value<int>? id, Value<String>? number, Value<int>? customerId}) {
    return DecodersCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      customerId: customerId ?? this.customerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecodersCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('customerId: $customerId')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid = GeneratedColumn<bool>(
      'paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bouquetIdMeta =
      const VerificationMeta('bouquetId');
  @override
  late final GeneratedColumn<int> bouquetId = GeneratedColumn<int>(
      'bouquet_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bouquets (id) ON DELETE CASCADE'));
  static const VerificationMeta _decoderIdMeta =
      const VerificationMeta('decoderId');
  @override
  late final GeneratedColumn<int> decoderId = GeneratedColumn<int>(
      'decoder_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES decoders (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, startDate, endDate, paid, bouquetId, decoderId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Subscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
          _paidMeta, paid.isAcceptableOrUnknown(data['paid']!, _paidMeta));
    }
    if (data.containsKey('bouquet_id')) {
      context.handle(_bouquetIdMeta,
          bouquetId.isAcceptableOrUnknown(data['bouquet_id']!, _bouquetIdMeta));
    } else if (isInserting) {
      context.missing(_bouquetIdMeta);
    }
    if (data.containsKey('decoder_id')) {
      context.handle(_decoderIdMeta,
          decoderId.isAcceptableOrUnknown(data['decoder_id']!, _decoderIdMeta));
    } else if (isInserting) {
      context.missing(_decoderIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      paid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}paid'])!,
      bouquetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bouquet_id'])!,
      decoderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}decoder_id'])!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final bool paid;
  final int bouquetId;
  final int decoderId;
  const Subscription(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.paid,
      required this.bouquetId,
      required this.decoderId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['paid'] = Variable<bool>(paid);
    map['bouquet_id'] = Variable<int>(bouquetId);
    map['decoder_id'] = Variable<int>(decoderId);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      paid: Value(paid),
      bouquetId: Value(bouquetId),
      decoderId: Value(decoderId),
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      paid: serializer.fromJson<bool>(json['paid']),
      bouquetId: serializer.fromJson<int>(json['bouquetId']),
      decoderId: serializer.fromJson<int>(json['decoderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'paid': serializer.toJson<bool>(paid),
      'bouquetId': serializer.toJson<int>(bouquetId),
      'decoderId': serializer.toJson<int>(decoderId),
    };
  }

  Subscription copyWith(
          {int? id,
          DateTime? startDate,
          DateTime? endDate,
          bool? paid,
          int? bouquetId,
          int? decoderId}) =>
      Subscription(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        paid: paid ?? this.paid,
        bouquetId: bouquetId ?? this.bouquetId,
        decoderId: decoderId ?? this.decoderId,
      );
  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('paid: $paid, ')
          ..write('bouquetId: $bouquetId, ')
          ..write('decoderId: $decoderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startDate, endDate, paid, bouquetId, decoderId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.paid == this.paid &&
          other.bouquetId == this.bouquetId &&
          other.decoderId == this.decoderId);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<bool> paid;
  final Value<int> bouquetId;
  final Value<int> decoderId;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.paid = const Value.absent(),
    this.bouquetId = const Value.absent(),
    this.decoderId = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.paid = const Value.absent(),
    required int bouquetId,
    required int decoderId,
  })  : startDate = Value(startDate),
        endDate = Value(endDate),
        bouquetId = Value(bouquetId),
        decoderId = Value(decoderId);
  static Insertable<Subscription> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? paid,
    Expression<int>? bouquetId,
    Expression<int>? decoderId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (paid != null) 'paid': paid,
      if (bouquetId != null) 'bouquet_id': bouquetId,
      if (decoderId != null) 'decoder_id': decoderId,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<bool>? paid,
      Value<int>? bouquetId,
      Value<int>? decoderId}) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paid: paid ?? this.paid,
      bouquetId: bouquetId ?? this.bouquetId,
      decoderId: decoderId ?? this.decoderId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    if (bouquetId.present) {
      map['bouquet_id'] = Variable<int>(bouquetId.value);
    }
    if (decoderId.present) {
      map['decoder_id'] = Variable<int>(decoderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('paid: $paid, ')
          ..write('bouquetId: $bouquetId, ')
          ..write('decoderId: $decoderId')
          ..write(')'))
        .toString();
  }
}

class $FutureSubscriptionPaymentsTable extends FutureSubscriptionPayments
    with
        TableInfo<$FutureSubscriptionPaymentsTable, FutureSubscriptionPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FutureSubscriptionPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _closedMeta = const VerificationMeta('closed');
  @override
  late final GeneratedColumn<bool> closed = GeneratedColumn<bool>(
      'closed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("closed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bouquetIdMeta =
      const VerificationMeta('bouquetId');
  @override
  late final GeneratedColumn<int> bouquetId = GeneratedColumn<int>(
      'bouquet_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bouquets (id) ON DELETE CASCADE'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES customers (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, closed, bouquetId, customerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'future_subscription_payments';
  @override
  VerificationContext validateIntegrity(
      Insertable<FutureSubscriptionPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('closed')) {
      context.handle(_closedMeta,
          closed.isAcceptableOrUnknown(data['closed']!, _closedMeta));
    }
    if (data.containsKey('bouquet_id')) {
      context.handle(_bouquetIdMeta,
          bouquetId.isAcceptableOrUnknown(data['bouquet_id']!, _bouquetIdMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FutureSubscriptionPayment map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FutureSubscriptionPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      closed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}closed'])!,
      bouquetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bouquet_id']),
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
    );
  }

  @override
  $FutureSubscriptionPaymentsTable createAlias(String alias) {
    return $FutureSubscriptionPaymentsTable(attachedDatabase, alias);
  }
}

class FutureSubscriptionPayment extends DataClass
    implements Insertable<FutureSubscriptionPayment> {
  final int id;
  final bool closed;
  final int? bouquetId;
  final int customerId;
  const FutureSubscriptionPayment(
      {required this.id,
      required this.closed,
      this.bouquetId,
      required this.customerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['closed'] = Variable<bool>(closed);
    if (!nullToAbsent || bouquetId != null) {
      map['bouquet_id'] = Variable<int>(bouquetId);
    }
    map['customer_id'] = Variable<int>(customerId);
    return map;
  }

  FutureSubscriptionPaymentsCompanion toCompanion(bool nullToAbsent) {
    return FutureSubscriptionPaymentsCompanion(
      id: Value(id),
      closed: Value(closed),
      bouquetId: bouquetId == null && nullToAbsent
          ? const Value.absent()
          : Value(bouquetId),
      customerId: Value(customerId),
    );
  }

  factory FutureSubscriptionPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FutureSubscriptionPayment(
      id: serializer.fromJson<int>(json['id']),
      closed: serializer.fromJson<bool>(json['closed']),
      bouquetId: serializer.fromJson<int?>(json['bouquetId']),
      customerId: serializer.fromJson<int>(json['customerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'closed': serializer.toJson<bool>(closed),
      'bouquetId': serializer.toJson<int?>(bouquetId),
      'customerId': serializer.toJson<int>(customerId),
    };
  }

  FutureSubscriptionPayment copyWith(
          {int? id,
          bool? closed,
          Value<int?> bouquetId = const Value.absent(),
          int? customerId}) =>
      FutureSubscriptionPayment(
        id: id ?? this.id,
        closed: closed ?? this.closed,
        bouquetId: bouquetId.present ? bouquetId.value : this.bouquetId,
        customerId: customerId ?? this.customerId,
      );
  @override
  String toString() {
    return (StringBuffer('FutureSubscriptionPayment(')
          ..write('id: $id, ')
          ..write('closed: $closed, ')
          ..write('bouquetId: $bouquetId, ')
          ..write('customerId: $customerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, closed, bouquetId, customerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FutureSubscriptionPayment &&
          other.id == this.id &&
          other.closed == this.closed &&
          other.bouquetId == this.bouquetId &&
          other.customerId == this.customerId);
}

class FutureSubscriptionPaymentsCompanion
    extends UpdateCompanion<FutureSubscriptionPayment> {
  final Value<int> id;
  final Value<bool> closed;
  final Value<int?> bouquetId;
  final Value<int> customerId;
  const FutureSubscriptionPaymentsCompanion({
    this.id = const Value.absent(),
    this.closed = const Value.absent(),
    this.bouquetId = const Value.absent(),
    this.customerId = const Value.absent(),
  });
  FutureSubscriptionPaymentsCompanion.insert({
    this.id = const Value.absent(),
    this.closed = const Value.absent(),
    this.bouquetId = const Value.absent(),
    required int customerId,
  }) : customerId = Value(customerId);
  static Insertable<FutureSubscriptionPayment> custom({
    Expression<int>? id,
    Expression<bool>? closed,
    Expression<int>? bouquetId,
    Expression<int>? customerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (closed != null) 'closed': closed,
      if (bouquetId != null) 'bouquet_id': bouquetId,
      if (customerId != null) 'customer_id': customerId,
    });
  }

  FutureSubscriptionPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<bool>? closed,
      Value<int?>? bouquetId,
      Value<int>? customerId}) {
    return FutureSubscriptionPaymentsCompanion(
      id: id ?? this.id,
      closed: closed ?? this.closed,
      bouquetId: bouquetId ?? this.bouquetId,
      customerId: customerId ?? this.customerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (closed.present) {
      map['closed'] = Variable<bool>(closed.value);
    }
    if (bouquetId.present) {
      map['bouquet_id'] = Variable<int>(bouquetId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FutureSubscriptionPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('closed: $closed, ')
          ..write('bouquetId: $bouquetId, ')
          ..write('customerId: $customerId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $BouquetsTable bouquets = $BouquetsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $DecodersTable decoders = $DecodersTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $FutureSubscriptionPaymentsTable futureSubscriptionPayments =
      $FutureSubscriptionPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        bouquets,
        customers,
        decoders,
        subscriptions,
        futureSubscriptionPayments
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('customers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('decoders', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('bouquets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('subscriptions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('decoders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('subscriptions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('bouquets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('future_subscription_payments',
                  kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('customers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('future_subscription_payments',
                  kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
