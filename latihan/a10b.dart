import 'dart:async';

Future<void> main() async {
  // Stream dari koleksi, lalu disaring seperti List
  final lulus = await Stream.fromIterable([85, 72, 58])
      .where((n) => n >= 60)
      .toList();
  print(lulus); // [85, 72]

  // Stream berkala: satu event setiap 300 ms, ambil 3 saja
  final detak =
      Stream.periodic(const Duration(milliseconds: 300), (i) => i + 1).take(3);
  await for (final d in detak) {
    print('Detak ke-$d');
  }

  // listen lengkap: onData, onError, onDone
  final sensor = StreamController<int>();
  sensor.stream.listen(
    (n) => print('Data: $n'),
    onError: (Object e) => print('Error: $e'),
    onDone: () => print('Stream selesai'),
  );
  sensor
    ..add(1)
    ..addError(Exception('sensor terputus'))
    ..add(2);
  await sensor.close();

  // Broadcast: banyak pendengar sekaligus
  final siaran = StreamController<String>.broadcast();
  siaran.stream.listen((p) => print('Layar A: $p'));
  siaran.stream.listen((p) => print('Layar B: $p'));
  siaran.add('Kuliah dimulai');
  await siaran.close();
}