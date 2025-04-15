class AudioClipModel {
  final String email;
  final String audioLink;
  final String name;
  final String status;
  final String createdAt;

  AudioClipModel({
    required this.email,
    required this.audioLink,
    this.name = '',
    this.status = '',
    this.createdAt = '',
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'audioLink': audioLink,
      'name': name,
      'status': status,
      'createdAt': createdAt
    };
  }

  // Create User object from JSON
  factory AudioClipModel.fromJson(Map<String, dynamic> json) {
    return AudioClipModel(
      email: json['email'] as String,
      audioLink: json['audioLink'] as String,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}


class PaginatedAudioClip {
  final List<AudioClipModel> users;
  final Pagination pagination;

  PaginatedAudioClip({required this.users, required this.pagination});

  factory PaginatedAudioClip.fromJson(Map<String, dynamic> json) {
    return PaginatedAudioClip(
      users: (json['data'] as List).map((item) => AudioClipModel.fromJson(item)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
    );
  }
}