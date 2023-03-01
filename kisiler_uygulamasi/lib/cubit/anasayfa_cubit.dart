import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/kisiler.dart';
import '../repo/kisilerdao_repository.dart';

class AnasayfaCubit extends Cubit<List<Kisiler>> {
  AnasayfaCubit() : super(<Kisiler>[]);

  var krepo = KisilerDaoRepository();
  var refKisiler = FirebaseDatabase.instance.ref("kisiler");

  Future<void> kisileriYukle() async {
    refKisiler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as Map<dynamic, dynamic>;
      if (gelenDegerler != null) {
        var liste = <Kisiler>[];
        gelenDegerler.forEach(
          (key, value) {
            var kisi = Kisiler.fromJson(key, value);
            liste.add(kisi);
          },
        );
        emit(liste);
      }
    });
  }

  Future<void> ara(String aramaKelimesi) async {
    refKisiler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value as Map<dynamic, dynamic>;
      if (gelenDegerler != null) {
        var liste = <Kisiler>[];
        gelenDegerler.forEach(
          (key, value) {
            var kisi = Kisiler.fromJson(key, value);
            if (kisi.kisi_ad.toLowerCase().contains(aramaKelimesi)) {
              liste.add(kisi);
            }
          },
        );
        emit(liste);
      }
    });
  }

  Future<void> sil(String kisi_id) async {
    await krepo.kisiSil(kisi_id);
    await kisileriYukle();
  }
}
