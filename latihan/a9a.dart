Future<String> ambilNama(String nim) async {
  await Future.delayed(const Duration(seconds: 1)); // simulasi akses server
  if (nim.isEmpty) throw Exception('NIM kosong');
  return 'Butet Siregar';
}

Future<double> ambilIpk(String nim) =>
    Future.delayed(const Duration(milliseconds: 1500), () => 3.62);

Future<void> main() async {
  print('1. Mulai');
  final futureNama = ambilNama('4243250001');
  print('2. Permintaan dikirim; program tidak menunggu');

  final nama = await futureNama; // berhenti di sini sampai Future selesai
  print('3. Nama: $nama');

  // Menjalankan dua Future bersamaan (record of futures, Dart 3)
  final (namaB, ipkB) =
      await (ambilNama('4243250001'), ambilIpk('4243250001')).wait;
  print('4. $namaB - IPK $ipkB');

  try {
    await ambilNama('');
  } on Exception catch (e) {
    print('5. Gagal: $e');
  }

  // Gaya .then() masih sering ditemui di kode lama
  ambilIpk('x').then((v) => print('7. IPK via then: $v'));
  print('6. Baris ini tercetak sebelum nomor 7');
}