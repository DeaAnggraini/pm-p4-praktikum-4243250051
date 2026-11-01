import 'dart:async';

// ===================== Model =====================
sealed class Koleksi {
  final String kode;
  final String judul;
  bool _dipinjam = false; // hanya diubah oleh kelas di berkas ini

  Koleksi(this.kode, this.judul);

  int get lamaPinjam;
  bool get tersedia => !_dipinjam;
  String info() => '[$kode] $judul';
}

mixin BisaDiunduh {
  String get url;
  String unduh() => 'Mengunduh dari $url ...';
}

class Buku extends Koleksi {
  final String penulis;
  Buku(super.kode, super.judul, this.penulis);

  @override
  int get lamaPinjam => 14;

  @override
  String info() => '${super.info()} oleh $penulis';
}

class Majalah extends Koleksi {
  final int edisi;
  Majalah(super.kode, super.judul, this.edisi);

  @override
  int get lamaPinjam => 7;

  @override
  String info() => '${super.info()} edisi $edisi';
}

class EBook extends Buku with BisaDiunduh {
  @override
  final String url;
  EBook(super.kode, super.judul, super.penulis, this.url);

  @override
  int get lamaPinjam => 30;
}

class Skripsi extends Koleksi {
  final String penulis;
  Skripsi(super.kode, super.judul, this.penulis);

  @override
  int get lamaPinjam => 0; // baca di tempat saja
}

class Anggota {
  final String id;
  final String nama;
  final int maksPinjam;
  Anggota(this.id, this.nama, {this.maksPinjam = 2});
}

class Peminjaman {
  final Anggota anggota;
  final Koleksi koleksi;
  final DateTime tanggal;
  Peminjaman(this.anggota, this.koleksi, this.tanggal);

  DateTime get jatuhTempo => tanggal.add(Duration(days: koleksi.lamaPinjam));

  int dendaPada(DateTime kembali) {
    final telat = kembali.difference(jatuhTempo).inDays;
    return telat > 0 ? telat * 1000 : 0; // Rp1.000 per hari
  }
}

class PeminjamanGagal implements Exception {
  final String alasan;
  PeminjamanGagal(this.alasan);

  @override
  String toString() => 'Peminjaman gagal: $alasan';
}

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

    k._dipinjam = true;
    final p = Peminjaman(a, k, tanggal ?? DateTime.now());
    _aktif.add(p);
    _log.add('${a.nama} meminjam "${k.judul}"');
    return p;
  }

  int kembalikan(Peminjaman p, {DateTime? tanggal}) {
    final denda = p.dendaPada(tanggal ?? DateTime.now());
    p.koleksi._dipinjam = false;
    _aktif.remove(p);
    _log.add('${p.anggota.nama} mengembalikan "${p.koleksi.judul}"');
    return denda;
  }

  Future<void> tutup() => _log.close();
}

// ===================== Tantangan 3 =====================
String ikon(Koleksi k) => switch (k) {
      Buku() => '📘',
      Majalah() => '📰',
      Skripsi() => '🎓',
    };

// ===================== Program utama =====================
Future<void> main() async {
  final perpus = Perpustakaan('Perpustakaan FMIPA');
  perpus.log.listen((pesan) => print('[LOG] $pesan'));

  perpus
    ..tambah(Buku('B01', 'Dasar-Dasar Dart', 'A. Siregar'))
    ..tambah(Majalah('M01', 'Majalah Teknologi', 112))
    ..tambah(EBook('E01', 'Flutter in Action', 'Eric Windmill',
        'https://contoh.id/e01'))
    ..tambah(Skripsi('S01', 'Skripsi Klasifikasi Teks', 'Dea'));

  final butet = Anggota('A01', 'Butet', maksPinjam: 1);
  final ucok = Anggota('A02', 'Ucok');

  final p1 = await perpus.pinjam(butet, 'B01', tanggal: DateTime(2026, 10, 1));
  print('Jatuh tempo: ${p1.jatuhTempo}');

  // Tiga percobaan yang seharusnya ditolak
  for (final (anggota, kode) in [
    (ucok, 'B01'),
    (butet, 'M01'),
    (ucok, 'X99'),
    (ucok, 'S01'),
  ]) {
    try {
      await perpus.pinjam(anggota, kode);
    } on PeminjamanGagal catch (e) {
      print(e);
    }
  }

  final denda = perpus.kembalikan(p1, tanggal: DateTime(2026, 10, 18));
  print('Denda: Rp$denda'); // terlambat 3 hari -> Rp3000
  print('Tersedia: ${perpus.koleksiTersedia.map((k) => k.judul).join(', ')}');

  // Tantangan 3: switch pada sealed class
  final contoh = <Koleksi>[
    Buku('B02', 'Tes', 'X'),
    Majalah('M02', 'Tes', 1),
    EBook('E02', 'Tes', 'X', 'https://contoh.id/e02'),
    Skripsi('S02', 'Tes', 'Dea'),
  ];
  for (final k in contoh) {
    print('${ikon(k)} ${k.info()}');
  }
  
  await perpus.tutup();
}