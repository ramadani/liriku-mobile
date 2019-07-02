import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final String id;
  final String name;
  final String coverUrl;

  Artist({this.id, this.name, this.coverUrl}) : super([id, name, coverUrl]);
}
