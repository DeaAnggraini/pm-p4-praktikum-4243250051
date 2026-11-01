class Mahasiswa {
  static int jumlahDibuat = 0; // milik kelas, dipakai bersama semua objek
  static const maksSks = 24;
  final String nama;

  Mahasiswa(this.nama) {
    jumlahDibuat++; // setiap objek baru menambah penghitung kelas
  }

  // method static: tidak memerlukan objek, tidak dapat memakai this
  static bool sksValid(int sks) => sks > 0 && sks <= maksSks;
}

void main() {
  final daftar = [Mahasiswa('Andi'), Mahasiswa('Butet')];
  print(daftar.length); // 2
  print(Mahasiswa.jumlahDibuat); // 2, diakses lewat nama kelas
  print(Mahasiswa.sksValid(26)); // false
}