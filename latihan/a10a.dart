import 'dart:async';

// async* + yield: fungsi yang menghasilkan Stream
Stream<int> hitungMundur(int dari) async* {
  for (var i = dari; i >= 1; i--) {
    await Future.delayed(const Duration(milliseconds: 500));
    yield i;
  }
}

Future<void> main() async {
  await for (final detik in hitungMundur(3)) {
    print('Antrean dibuka dalam $detik ...');
  }
  print('Silakan masuk!');

  // StreamController: sumber event yang kita kendalikan sendiri
  final notifikasi = StreamController<String>();
  final langganan = notifikasi.stream
      .where((p) => p.contains('Mobile'))
      .listen((p) => print('Notifikasi: $p'));

  notifikasi.add('Nilai Pemrograman Mobile sudah keluar');
  notifikasi.add('Jadwal Jaringan berubah'); // tersaring, tidak tampil
  notifikasi.add('Tugas Pemrograman Mobile baru');
  await notifikasi.close();
  await langganan.cancel();
}