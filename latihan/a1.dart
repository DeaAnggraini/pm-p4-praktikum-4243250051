class Mahasiswa {
  final String nim;
  final String nama;
  double _ipk; // privat terhadap library (berkas), bukan terhadap kelas
  static const String kampus = 'UNIMED';

  // Konstruktor utama: this.x mengisi field secara langsung
  Mahasiswa(this.nim, this.nama, {double ipk = 0}) : _ipk = ipk;

  // Named constructor yang meneruskan ke konstruktor utama
  Mahasiswa.baru(String nim, String nama) : this(nim, nama);

  // Factory constructor: menyusun objek dari data mentah (misalnya JSON)
  factory Mahasiswa.dariMap(Map<String, Object?> data) {
    return Mahasiswa(
      data['nim'] as String,
      data['nama'] as String,
      ipk: (data['ipk'] as num?)?.toDouble() ?? 0,
    );
  }

  // Getter dan setter: akses terkendali ke field privat
  double get ipk => _ipk;
  set ipk(double nilai) {
    if (nilai < 0 || nilai > 4) {
      throw ArgumentError.value(nilai, 'ipk', 'harus di antara 0 dan 4');
    }
    _ipk = nilai;
  }

  bool get cumlaude => _ipk >= 3.51; // getter terhitung

  @override
  String toString() => '$nama ($nim) IPK ${_ipk.toStringAsFixed(2)}';
}

void main() {
  final a = Mahasiswa('4243250001', 'Butet', ipk: 3.62);
  final b = Mahasiswa.baru('4243250002', 'Ucok');
  final c = Mahasiswa.dariMap({'nim': '4243250003', 'nama': 'Citra', 'ipk': 3});
  b.ipk = 3.1; // memanggil setter
  try {
    b.ipk = 5; // di luar 0-4, harus error
  } catch (e) {
    print('Error: $e');
  }

  print(a); // Butet (4243250001) IPK 3.62
  print(b.cumlaude); // false
  print(c.ipk); // 3.0
  print(Mahasiswa.kampus); // UNIMED
}