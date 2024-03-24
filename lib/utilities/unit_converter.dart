String formatDuration(int durationInSeconds) {
  Duration duration = Duration(seconds: durationInSeconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}

String convertMetersToMiles(double distanceInMeters) {
  return (distanceInMeters * 0.000621371192).toStringAsFixed(2);
}

String convertMetersPerSecondToMilesPerHour(double speedInMetersPerSecond) {
  return (speedInMetersPerSecond * 2.23694).toStringAsFixed(1);
}

String convertMetersToFeet(double meters) {
  return (meters * 3.28084).toStringAsFixed(0);
}