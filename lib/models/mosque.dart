import 'package:intl/intl.dart';

class Mosque {
  final String id;
  final String name;
  final String kind; // 'mosque' or 'madrasa'
  final String cityId;
  final String areaId;
  final String address;
  final String? imamName;
  final String? imamPhone;
  final String? photoUrl;
  final String? openTime;
  final String? closeTime;

  // Prayer Timings
  final String fajr;
  final String zuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String jumuah;

  // Madrasa fields
  final bool hasMadrasa;
  final String? madrasaName;
  final String? madrasaTiming;
  final String? madrasaContact;
  final String? madrasaInfo;

  Mosque({
    required this.id,
    required this.name,
    this.kind = 'mosque',
    required this.cityId,
    required this.areaId,
    required this.address,
    this.imamName,
    this.imamPhone,
    this.photoUrl,
    this.openTime,
    this.closeTime,
    this.fajr = '05:30',
    this.zuhr = '01:30',
    this.asr = '04:45',
    this.maghrib = '06:00',
    this.isha = '08:00',
    this.jumuah = '01:45',
    this.hasMadrasa = false,
    this.madrasaName,
    this.madrasaTiming,
    this.madrasaContact,
    this.madrasaInfo,
  });

  /// Calculates the next prayer relative to current local time
  Map<String, String> getNextPrayer() {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    DateTime? parsePrayer(String timeStr) {
      try {
        final clean = timeStr.trim().toUpperCase();
        DateTime dt;
        if (clean.contains('AM') || clean.contains('PM')) {
          dt = DateFormat('yyyy-MM-dd hh:mm a').parse('$todayStr $clean');
        } else {
          dt = DateFormat('yyyy-MM-dd HH:mm').parse('$todayStr $clean');
        }
        return dt;
      } catch (e) {
        return null;
      }
    }

    final prayers = [
      {'name': 'Fajr', 'nameUr': 'فجر', 'time': fajr, 'dt': parsePrayer(fajr)},
      {'name': 'Zuhr', 'nameUr': 'ظہر', 'time': zuhr, 'dt': parsePrayer(zuhr)},
      {'name': 'Asr', 'nameUr': 'عصر', 'time': asr, 'dt': parsePrayer(asr)},
      {'name': 'Maghrib', 'nameUr': 'مغرب', 'time': maghrib, 'dt': parsePrayer(maghrib)},
      {'name': 'Isha', 'nameUr': 'عشاء', 'time': isha, 'dt': parsePrayer(isha)},
    ];

    for (var p in prayers) {
      final dt = p['dt'] as DateTime?;
      if (dt != null && dt.isAfter(now)) {
        return {
          'name': p['name'] as String,
          'nameUr': p['nameUr'] as String,
          'time': p['time'] as String,
          'isTomorrow': 'false',
        };
      }
    }

    // If all today's prayers passed, next is Fajr tomorrow
    return {
      'name': 'Fajr',
      'nameUr': 'فجر',
      'time': fajr,
      'isTomorrow': 'true',
    };
  }

  factory Mosque.fromMap(Map<String, dynamic> map) {
    return Mosque(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      kind: map['kind'] ?? 'mosque',
      cityId: map['city_id'] ?? map['cityId'] ?? '',
      areaId: map['area_id'] ?? map['areaId'] ?? '',
      address: map['address'] ?? '',
      imamName: map['imam_name'] ?? map['imamName'],
      imamPhone: map['imam_phone'] ?? map['imamPhone'],
      photoUrl: map['photo_url'] ?? map['photoUrl'],
      openTime: map['open_time'] ?? map['openTime'],
      closeTime: map['close_time'] ?? map['closeTime'],
      fajr: map['fajr'] ?? '05:30',
      zuhr: map['zuhr'] ?? '01:30',
      asr: map['asr'] ?? '04:45',
      maghrib: map['maghrib'] ?? '06:00',
      isha: map['isha'] ?? '08:00',
      jumuah: map['jumuah'] ?? '01:45',
      hasMadrasa: map['has_madrasa'] ?? map['hasMadrasa'] ?? false,
      madrasaName: map['madrasa_name'] ?? map['madrasaName'],
      madrasaTiming: map['madrasa_timing'] ?? map['madrasaTiming'],
      madrasaContact: map['madrasa_contact'] ?? map['madrasaContact'],
      madrasaInfo: map['madrasa_info'] ?? map['madrasaInfo'],
    );
  }
}
