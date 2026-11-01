import 'dart:async';
import 'model.dart';

// ===================== Layanan =====================
class Perpustakaan {
  final String nama;
  final List<Koleksi> _koleksi = [];
  final List<Peminjaman> _aktif = [];
  final _log = StreamController<String>.broadcast();

  Perpustakaan(this.nama);

  Stream<String> get log => _log.stream;

  List<Koleksi> get koleksiTersedia =>
      _koleksi.where((k) => k.tersedia).toList();

  void tambah(Koleksi k) {
    _koleksi.add(k);
    _log.add('Koleksi baru: ${k.judul}');
  }

  Future<Peminjaman> pinjam(Anggota a, String kode, {DateTime? tanggal}) async {
    await Future.delayed(const Duration(milliseconds: 300)); // cek ke server

    final k = _koleksi.where((x) => x.kode == kode).firstOrNull;
    if (k == null) throw PeminjamanGagal('kode $kode tidak ditemukan');
    if (k.lamaPinjam == 0) {
      throw PeminjamanGagal('"${k.judul}" hanya boleh dibaca di tempat');
    }
    if (!k.tersedia) throw PeminjamanGagal('"${k.judul}" sedang dipinjam');

    final jumlah = _aktif.where((p) => p.anggota.id == a.id).length;
    if (jumlah >= a.maksPinjam) {
      throw PeminjamanGagal('${a.nama} sudah mencapai batas $jumlah pinjaman');
    }

    k.tandaiDipinjam();
    final p = Peminjaman(a, k, tanggal ?? DateTime.now());
    _aktif.add(p);
    _log.add('${a.nama} meminjam "${k.judul}"');
    return p;
  }

  int kembalikan(Peminjaman p, {DateTime? tanggal}) {
    final denda = p.dendaPada(tanggal ?? DateTime.now());
    p.koleksi.tandaiKembali();    
    _aktif.remove(p);
    _log.add('${p.anggota.nama} mengembalikan "${p.koleksi.judul}"');
    return denda;
  }

  Future<void> tutup() => _log.close();
}