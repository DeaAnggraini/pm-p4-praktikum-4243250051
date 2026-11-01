import 'dart:io';

Future<void> main() async {
  final berkas = File('catatan.txt');

  // Menulis (menimpa isi lama), lalu menambah di akhir berkas
  await berkas.writeAsString('Pertemuan 4: OOP\n');
  await berkas.writeAsString('Pertemuan 4: Async\n', mode: FileMode.append);

  // Membaca seluruh isi, atau per baris
  print(await berkas.readAsString());
  final baris = await berkas.readAsLines();
  print('Jumlah baris: ${baris.length}'); // 2

  // Memeriksa lalu menghapus
  if (await berkas.exists()) {
    await berkas.delete();
    print('Berkas dihapus');
  }

  // Berkas yang tidak ada melempar FileSystemException
  try {
    await File('tidak_ada.txt').readAsString();
  } on FileSystemException catch (e) {
    print('Gagal membaca: ${e.message}');
  }
}