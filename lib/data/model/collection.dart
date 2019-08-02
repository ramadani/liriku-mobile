import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final String id;
  final String label;
  final DateTime createdAt;

  Collection({this.id, this.label, this.createdAt}) : super([id, label, createdAt]);
}