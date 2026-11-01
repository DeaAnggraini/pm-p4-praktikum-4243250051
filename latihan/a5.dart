// Enum sederhana: daftar nilai tetap
enum Hari { senin, selasa, rabu, kamis, jumat, sabtu, minggu }

// Enhanced enum: punya field, konstruktor const, dan getter/method
enum Nilai {
  a(4.0, 'Sangat baik'),
  b(3.0, 'Baik'),
  c(2.0, 'Cukup'),
  d(1.0, 'Kurang'),
  e(0.0, 'Gagal');

  const Nilai(this.bobot, this.keterangan);
  final double bobot;
  final String keterangan;

  bool get lulus => bobot >= 2.0;
}

void main() {
  const h = Hari.rabu;
  print(h.name); // rabu
  print(h.index); // 2 (urutan dimulai dari 0)
  print(Hari.values.length); // 7

  final pesan = switch (h) {
    Hari.sabtu || Hari.minggu => 'Libur',
    _ => 'Kuliah',
  };
  print(pesan); // Kuliah

  final n = Nilai.values.byName('b'); // dari teks ke enum
  print('${n.name.toUpperCase()} = ${n.bobot} (${n.keterangan})');
  print('Lulus: ${n.lulus}'); // B = 3.0 (Baik) / Lulus: true
}