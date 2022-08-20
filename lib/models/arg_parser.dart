import 'package:args/args.dart';
import 'package:untruth_instagram_followers/models/arguments.dart';

const _kUsernameArgumentName = 'username';
const _kUsernameArgumentAbbreviation = 'u';
const _kUsernameArgumentHelp =
    'Specifies the username credential to login in Instagram';

const _kPasswordArgumentName = 'password';
const _kPasswordArgumentAbbreviation = 'p';
const _kPasswordArgumentHelp =
    'Specifies the password credential to login in Instagram';

const _kProfileIdArgumentName = 'profileid';
const _kProfileIdArgumentAbbreviation = 'i';
const _kProfileIdArgumentHelp =
    'Specifies the ID of the user profile which data is getting scrapped';

const _kOutputModeArgumentName = 'mode';
const _kOutputModeArgumentAbbreviation = 'm';
const _kOutputModeArgumentHelp =
    'Specifies the output mode (jpeg, gif, webm) which results will be formatted';

const _kHeadfulArgumentName = 'headful';
const _kHeadfulArgumentAbbreviation = 'h';
const _kHeadfulArgumentNameHelp =
    'Specifies whether the automation should run in headful or headless mode. (defaults to headless)';

ArgParser programArgParser() {
  final parser = ArgParser();

  parser.addOption(
    _kUsernameArgumentName,
    abbr: _kUsernameArgumentAbbreviation,
    help: _kUsernameArgumentHelp,
    mandatory: true,
  );

  parser.addOption(
    _kPasswordArgumentName,
    abbr: _kPasswordArgumentAbbreviation,
    help: _kPasswordArgumentHelp,
    mandatory: true,
  );

  parser.addOption(
    _kProfileIdArgumentName,
    abbr: _kProfileIdArgumentAbbreviation,
    help: _kProfileIdArgumentHelp,
    mandatory: true,
  );

  parser.addOption(
    _kOutputModeArgumentName,
    abbr: _kOutputModeArgumentAbbreviation,
    help: _kOutputModeArgumentHelp,
    defaultsTo: 'text',
    mandatory: false,
  );

  parser.addFlag(
    _kHeadfulArgumentName,
    abbr: _kHeadfulArgumentAbbreviation,
    help: _kHeadfulArgumentNameHelp,
    defaultsTo: false,
  );

  return parser;
}

extension ArgResultsExtension on ArgResults {
  String get username => this[_kUsernameArgumentName];

  String get password => this[_kPasswordArgumentName];

  String get profileId => this[_kProfileIdArgumentName];

  OutputMode? get outputMode =>
      OutputMode.fromArgument(this[_kOutputModeArgumentName]);

  bool get headless => !this[_kHeadfulArgumentName];
}
