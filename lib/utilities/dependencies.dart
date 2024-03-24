import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../dao/recording_dao.dart';
import '../database.dart';
import '../view_models/recording_view_model.dart';

final getIt = GetIt.instance;

void registerDependencies(FirebaseAuth auth) {
  // register database with getIt
  getIt.registerSingletonAsync<SnowGaugeDatabase>(
          () async => $FloorSnowGaugeDatabase.databaseBuilder('snow_gauge_database').build()
  );

  // register recording dao
  getIt.registerSingletonWithDependencies<RecordingDao>(() {
    return GetIt.instance.get<SnowGaugeDatabase>().recordingDao;
  }, dependsOn: [SnowGaugeDatabase]);

  // register RecordingViewModel
  getIt.registerSingletonWithDependencies<RecordingViewModel>(
          () => RecordingViewModel(auth),
      dependsOn: [SnowGaugeDatabase, RecordingDao]
  );
}