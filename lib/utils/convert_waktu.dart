String convertBulan(int n) {
  switch (n) {
    case 1:
      return 'Januari';
    case 2:
      return 'Febuari';
    case 3:
      return 'Maret';
    case 4:
      return 'April';
    case 5:
      return 'Mei';
    case 6:
      return 'Juni';
    case 7:
      return 'Juli';
    case 8:
      return 'Agustus';
    case 9:
      return 'September';
    case 10:
      return 'Oktober';
    case 11:
      return 'November';
    case 12:
      return 'Desember';
  }
  return 'bukan';
}

String convertHari(int n) {
  switch (n) {
    case 1:
      return 'Senin';
    case 2:
      return 'Selasa';

    case 3:
      return 'Rabu';

    case 4:
      return 'Kamis';

    case 5:
      return 'Jumat';

    case 6:
      return 'Sabtu';

    case 7:
      return 'Minggu';
  }
  return 'a';
}

String fixJam(String x) {
  if (x.length == 1) {
    return '0$x';
  } else {
    return '$x';
  }
}
