// Kelas generik: T diganti tipe nyata saat dipakai
class Kotak<T> {
  final T isi;
  const Kotak(this.isi);
  T ambil() => isi;
}

// Hasil sebuah proses: sukses membawa data bertipe T, gagal membawa pesan
class Hasil<T> {
  final T? data;
  final String? galat;
  const Hasil.sukses(T this.data) : galat = null;
  const Hasil.gagal(String this.galat) : data = null;
  bool get berhasil => galat == null;
}

// Fungsi generik dengan batasan: T harus num atau turunannya
T terbesar<T extends num>(List<T> daftar) =>
    daftar.reduce((a, b) => a > b ? a : b);

Hasil<int> bacaSks(String teks) {
  final n = int.tryParse(teks);
  return n == null ? const Hasil.gagal('SKS harus angka') : Hasil.sukses(n);
}

void main() {
  const k1 = Kotak<String>('Dart');
  const k2 = Kotak(3.75); // T disimpulkan sebagai double
  print('${k1.ambil().length} ${k2.ambil()}'); // 4 3.75

  print(terbesar([78, 92, 55])); // 92
  print(terbesar([2.5, 3.75])); // 3.75
  // terbesar(['a', 'b']); // ERROR: String bukan turunan num

  final h = bacaSks('tiga');
  print(h.berhasil ? h.data : h.galat); // SKS harus angka

  // List, Set, dan Map adalah kelas generik bawaan
  final Map<String, List<int>> nilaiPerMk = {'Mobile': [85, 90]};
  print(nilaiPerMk['Mobile']?.first); // 85
}