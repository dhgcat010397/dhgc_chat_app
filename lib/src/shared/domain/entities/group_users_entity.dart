import 'package:equatable/equatable.dart';

class GroupUsersEntity extends Equatable {
  final String id;
  final String name;
  final List<String?> avatar;
  final List<String> admins;
  final DateTime createdAt;
  final String createdBy;

  const GroupUsersEntity({
    required this.id,
    required this.name,
    this.avatar = const [],
    required this.admins,
    required this.createdAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [id, name, avatar, admins, createdAt, createdBy];

  GroupUsersEntity copyWith({
    String? id,
    String? name,
    List<String?>? avatar,
    List<String>? admins,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return GroupUsersEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      admins: admins ?? this.admins,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
