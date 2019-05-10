import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';

import '../util/menu.dart';
import '../util/photos.dart';
import '../util/url.dart';
import 'query_model.dart';
import 'rocket.dart';

/// LAUNCHES MODEL
/// Model which storages information about
/// past or futures launches, depending on [type].
///   [type] == 0 => Upcoming launches
///   [type] == 1 => Latest launches
class LaunchesModel extends QueryModel {
  final int type;

  LaunchesModel(this.type);

  @override
  Future loadData([BuildContext context]) async {

    print("loading data..");
    // Fetch & add items
    List launches = await fetchData(
      type == 0 ? Url.upcomingList : Url.launchesList,
    );
    
    // Clear old data
    clearItems();

    items.addAll(launches.map((launch) => Launch.fromJson(launch)).toList());

    // Add photos & shuffle them
    if (photos.isEmpty) {
      if (getItem(0).photos.isEmpty)
        photos.addAll(SpaceXPhotos.spacexUpcomingScreen);
      else
        photos.addAll(getItem(0).photos.sublist(0, 3));
      photos.shuffle();
    }

    // Finished loading data
    setLoading(false);
  }
}

/// LAUNCH MODEL
/// Details about a specific launch, performed by a Falcon rocket,
/// including launch & landing pads, rocket & payload information...
class Launch {
  final int number, launchWindow;
  final String name,
      launchpadId,
      launchpadName,
      imageUrl,
      details,
      tentativePrecision;
  final List links, photos;
  final DateTime launchDate, staticFireDate;
  final bool launchSuccess, tentativeTime;
  final Rocket rocket;
  final FailureDetails failureDetails;

  Launch({
    this.number,
    this.launchWindow,
    this.name,
    this.launchpadId,
    this.launchpadName,
    this.imageUrl,
    this.details,
    this.tentativePrecision,
    this.links,
    this.photos,
    this.launchDate,
    this.staticFireDate,
    this.launchSuccess,
    this.tentativeTime,
    this.rocket,
    this.failureDetails,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      number: json['flight_number'],
      launchWindow: json['launch_window'],
      name: json['mission_name'],
      launchpadId: json['launch_site']['site_id'],
      launchpadName: json['launch_site']['site_name'],
      imageUrl: json['links']['mission_patch_small'],
      details: json['details'],
      tentativePrecision: json['tentative_max_precision'],
      links: [
        json['links']['video_link'],
        json['links']['reddit_campaign'],
        json['links']['presskit'],
        json['links']['article_link'],
      ],
      photos: setLaunchPhotos(json['links']['flickr_images']),
      launchDate: DateTime.parse(json['launch_date_utc']).toLocal(),
      staticFireDate: setStaticFireDate(json['static_fire_date_utc']),
      launchSuccess: json['launch_success'],
      tentativeTime: json['is_tentative'],
      rocket: Rocket.fromJson(json['rocket']),
      failureDetails: setFailureDetails(json['launch_failure_details']),
    );
  }

  static List setLaunchPhotos(List list) {
    if (list.isEmpty)
      return SpaceXPhotos.spacexUpcomingScreen;
    else
      // return list;
      return list.map((oneUrl)=>oneUrl.toString().replaceRange(oneUrl.length-5,oneUrl.length-1, "m.jpg")).toList();

  }

  static DateTime setStaticFireDate(String date) {
    try {
      return DateTime.parse(date).toLocal();
    } catch (_) {
      return null;
    }
  }

  static FailureDetails setFailureDetails(Map<String, dynamic> failureDetails) {
    try {
      return FailureDetails.fromJson(failureDetails);
    } catch (_) {
      return null;
    }
  }

  String getLaunchWindow(context) {
    if (launchWindow == null)
      return FlutterI18n.translate(context, 'spacex.other.unknown');
    else if (launchWindow == 0)
      return FlutterI18n.translate(
        context,
        'spacex.launch.page.rocket.instantaneous_window',
      );
    else if (launchWindow < 60)
      return '${NumberFormat.decimalPattern().format(launchWindow)} s';
    else if (launchWindow < 3600)
      return '${NumberFormat.decimalPattern().format(launchWindow / 60)} min';
    else if (launchWindow % 3600 == 0)
      return '${NumberFormat.decimalPattern().format(launchWindow / 3600)} h';
    else
      return '${NumberFormat.decimalPattern().format(launchWindow ~/ 3600)}h ${NumberFormat.decimalPattern().format((launchWindow / 3600 - launchWindow ~/ 3600) * 60)}min';
  }

  String get getProfilePhoto =>
      hasImages ? photos[0] : SpaceXPhotos.defaultImage;

  String getPhoto(index) =>
      hasImages ? photos[index] : SpaceXPhotos.spacexUpcomingScreen[index];

  int get getPhotosCount =>
      hasImages ? photos.length : SpaceXPhotos.spacexUpcomingScreen.length;

  String get getRandomPhoto => photos[Random().nextInt(getPhotosCount)];

  bool get hasImages => photos.isNotEmpty;

  String get getNumber => '#${NumberFormat('00').format(number)}';

  String get getImageUrl => imageUrl ?? SpaceXPhotos.defaultImage;

  bool get hasImage => imageUrl != null;

  bool get hasVideo => links[0] != null;

  String get getVideo => links[0];

  String getDetails(context) =>
      details ??
      FlutterI18n.translate(context, 'spacex.launch.page.no_description');

  String getLaunchDate(context) {
    switch (tentativePrecision) {
      case 'hour':
        return FlutterI18n.translate(
          context,
          'spacex.other.date.time',
          {'date': getTentativeDate, 'hour': getTentativeTime},
        );
      default:
        return FlutterI18n.translate(
          context,
          'spacex.other.date.upcoming',
          {'date': getTentativeDate},
        );
    }
  }

  String get getTentativeDate {
    switch (tentativePrecision) {
      case 'hour':
        return DateFormat.yMMMMd().format(launchDate);
      case 'day':
        return DateFormat.yMMMMd().format(launchDate);
      case 'month':
        return DateFormat.yMMMM().format(launchDate);
      case 'quarter':
        return DateFormat.yQQQ().format(launchDate);
      case 'half':
        return 'H${launchDate.month < 7 ? 1 : 2} ${launchDate.year}';
      case 'year':
        return DateFormat.y().format(launchDate);
      default:
        return 'date error';
    }
  }

  String get getTentativeTime =>
      '${DateFormat.Hm().format(launchDate)} ${launchDate.timeZoneName}';

  String getStaticFireDate(context) => staticFireDate == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : DateFormat.yMMMMd().format(staticFireDate);

  int getMenuIndex(context, url) => Menu.launch.indexOf(url) + 1;

  bool isUrlEnabled(context, url) => links[getMenuIndex(context, url)] != null;

  String getUrl(context, name) => links[getMenuIndex(context, name)];
}

/// FAILURE DETAILS MODEL
/// Auxiliar model to storage details about a launch failure
class FailureDetails {
  final num time, altitude;
  final String reason;

  FailureDetails({this.time, this.altitude, this.reason});

  factory FailureDetails.fromJson(Map<String, dynamic> json) {
    return FailureDetails(
      time: json['time'],
      altitude: json['altitude'],
      reason: json['reason'],
    );
  }

  String get getTime =>
      'T${time.isNegative ? '-' : '+'}${NumberFormat.decimalPattern().format(time.abs())} s';

  String getAltitude(context) => altitude == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : '${NumberFormat.decimalPattern().format(altitude)} km';

  String get getReason => '${reason[0].toUpperCase()}${reason.substring(1)}';
}
