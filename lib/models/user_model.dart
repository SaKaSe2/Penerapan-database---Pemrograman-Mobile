class User {
  final int? id;
  final String nama;
  final String nim;
  final String alamat;
  final String noWa;
  final String email;
  final String password;

  const User({
    this.id,
    required this.nama,
    required this.nim,
    required this.alamat,
    required this.noWa,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'alamat': alamat,
      'noWa': noWa,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      nim: map['nim'] as String,
      alamat: map['alamat'] as String,
      noWa: map['noWa'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  User copy({
    int? id,
    String? nama,
    String? nim,
    String? alamat,
    String? noWa,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      alamat: alamat ?? this.alamat,
      noWa: noWa ?? this.noWa,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}