import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:SnowGauge/utilities/unit_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/recording_view_model.dart';

class HistoryView extends StatefulWidget {
  final FirebaseAuth auth;
  const HistoryView({super.key, required this.auth});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

  @override
  Widget build(BuildContext context) {
    final recordingProvider = Provider.of<RecordingViewModel>(context);
    if (widget.auth.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recording History'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You must be signed in to use this feature',
              style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        body: ListView.builder(
          itemCount: recordingProvider.recordingHistory.length,
          itemBuilder: (context, index) {
            final record = recordingProvider.recordingHistory[index];
            return _buildRecordItem(record, widget.auth.currentUser!.email!);
          },
        ),
      );
    }
  }

  Widget _buildRecordItem(Recording record, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        // elevation: 4,
        child: ListTile(
          title: Text('User: $userName'),
          tileColor: Colors.teal[100],
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recording Date: ${record.recordingDate}'),
              Text('Number of Runs: ${record.numberOfRuns}'),
              Text('Max Speed: ${convertMetersPerSecondToMilesPerHour(record.maxSpeed)} mph'),
              Text('Average Speed: ${convertMetersPerSecondToMilesPerHour(record.averageSpeed)} mph'),
              Text('Total Distance: ${convertMetersToMiles(record.totalDistance)} miles'),
              Text('Total Vertical: ${convertMetersToFeet(record.totalVertical)} ft'),
              Text('Max Elevation: ${convertMetersToFeet(record.maxElevation)} ft'),
              Text('Min Elevation: ${convertMetersToFeet(record.minElevation)} ft'),
              Text('Duration: ${formatDuration(record.duration)}'),
            ],
          ),
        ),
      ),
    );
  }
}
