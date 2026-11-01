abstract class Koleksi {
  final String kode;
  final String judul;
  Koleksi(this.kode, this.judul);

  int get lamaPinjam; // abstrak: wajib diimplementasikan subclass
  String info() => '[$kode] $judul (pinjam $lamaPinjam hari)';
}

// Interface murni (Dart 3): hanya boleh di-implements
abstract interface class BisaDicetak {
  String labelRak();
}

// Mixin: kumpulan perilaku yang bisa "dicampurkan" ke kelas lain
mixin BisaDiunduh {
  String get url;
  String unduh() => 'Mengunduh dari $url ...';
}

class Buku extends Koleksi implements BisaDicetak {
  final String penulis;
  Buku(super.kode, super.judul, this.penulis); // super parameter

  @override
  int get lamaPinjam => 14;

  @override
  String info() => '${super.info()} oleh $penulis';

  @override
  String labelRak() => 'RAK-${penulis[0].toUpperCase()}';
}

class Majalah extends Koleksi {
  final int edisi;
  Majalah(super.kode, super.judul, this.edisi);

  @override
  int get lamaPinjam => 7;
}

class EBook extends Buku with BisaDiunduh {
  @override
  final String url;
  EBook(super.kode, super.judul, super.penulis, this.url);

  @override
  int get lamaPinjam => 30;
}

void main() {
  final List<Koleksi> rak = [
    Buku('B01', 'Dasar-Dasar Dart', 'A. Siregar'),
    Majalah('M01', 'Majalah Teknologi', 112),
    EBook('E01', 'Flutter in Action', 'Eric Windmill', 'https://contoh.id/e01'),
  ];

  for (final k in rak) {
    print(k.info()); // polimorfisme: method yang dipanggil sesuai objek aslinya
  }

  final terakhir = rak.last;
  if (terakhir is EBook) {
    print(terakhir.unduh()); // promosi tipe: Koleksi -> EBook
    print(terakhir.labelRak()); // RAK-E
  }
}