import 'dart:async';

Future<int> jumlahMahasiswa(String kelas) async {
  await Future.delayed(const Duration(milliseconds: 500));
  if (kelas.isEmpty) throw Exception('Kelas tidak dikenal');
  return kelas.length * 10;
}

Future<void> main() async {
  // Gaya callback: then, catchError, whenComplete
  await jumlahMahasiswa('')
      .then((n) => print('Jumlah: $n'))
      .catchError((Object e) => print('Gagal: $e'))
      .whenComplete(() => print('Selesai, berhasil atau gagal'));

  // Future.wait: menunggu banyak Future yang berjalan bersamaan
  final jumlah = await Future.wait([
    jumlahMahasiswa('Kom-A'),
    jumlahMahasiswa('Kom-B'),
    jumlahMahasiswa('Ilkom-C'),
  ]); // total ±0,5 detik, bukan 1,5 detik
  print(jumlah); // [50, 50, 70]
  print(jumlah.fold<int>(0, (a, b) => a + b)); // 170

  // timeout: menyerah bila jawaban terlalu lama
  try {
    await Future.delayed(const Duration(seconds: 3), () => 'lambat')
        .timeout(const Duration(seconds: 1));
  } on TimeoutException {
    print('Server terlalu lama menjawab');
  }
}