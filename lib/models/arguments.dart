import 'package:args/args.dart';
import 'arg_parser.dart';

class Arguments {
  final String username;

  final String password;

  final String profileId;

  final OutputMode outputMode;

  final bool headless;

  const Arguments({
    required this.username,
    required this.password,
    required this.profileId,
    this.outputMode = OutputMode.text,
    this.headless = true,
  });

  static Arguments? fromArgs(
    final List<String> args,
    final ArgParser parser,
  ) {
    try {
      if (args.where((x) => x.startsWith('-')).isEmpty && args.length >= 2) {
        return Arguments(
          username: args[0],
          password: args[1],
          profileId: args[2],
        );
      } else {
        final parseResults = parser.parse(args);

        return Arguments(
          username: parseResults.username,
          password: parseResults.password,
          profileId: parseResults.profileId,
          outputMode: parseResults.outputMode ?? OutputMode.text,
          headless: parseResults.headless,
        );
      }
    } on Object catch (_) {
      return null;
    }
  }
}

enum OutputMode {
  text,
  markdown;

  static OutputMode? fromArgument(final String? value) {
    final lowerValue = value?.toLowerCase();

    final possibleValues = OutputMode.values.where((v) => v.name == lowerValue);

    if (possibleValues.isNotEmpty) {
      return possibleValues.first;
    } else {
      return null;
    }
  }
}
