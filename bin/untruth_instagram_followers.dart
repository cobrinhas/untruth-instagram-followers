import 'package:puppeteer/puppeteer.dart';
import 'package:untruth_instagram_followers/untruth_instagram_followers.dart';

void main(final List<String> args) async {
  final parser = programArgParser();

  final arguments = Arguments.fromArgs(args, parser);

  if (arguments == null) {
    print(
      'Welcome to untruth-instagram-followers! Below are the mandatory arguments you need to specify.',
    );
    print(parser.usage);
  } else {
    final username = arguments.username;

    final password = arguments.password;

    final profileId = arguments.profileId;

    final outputMode = arguments.outputMode;

    // Download the Chromium binaries, launch it and connect to the "DevTools"
    final browser = await puppeteer.launch(
      headless: arguments.headless,
    );

    // Open a new tab
    print('Starting browser engine...');
    final myPage = await browser.newPage();

    // Go to a page and wait to be fully loaded
    print('Loading $instagramUrl in a new tab...');
    await myPage.goto(instagramUrl, wait: Until.networkIdle);

    print('Searching for cookie box...');
    final cookiesButtonElements = await myPage.$x(
      cookiesButtonXPathSelectorExpression,
    );

    // Accept cookies box if present
    if (cookiesButtonElements.isNotEmpty) {
      print('Found. Clicking it...');

      final cookiesButtonElement = cookiesButtonElements.first;

      await cookiesButtonElement.click();
    }

    await Future.delayed(afterActionDelayDuration);

    final loginFormUsernameInputElement = await myPage.$(
      loginFormUsernameInputSelectorExpression,
    );

    // Fill username input
    print('Filling username input...');
    await loginFormUsernameInputElement.type(
      username,
      delay: inputTypeDelayDuration,
    );

    final loginFormPasswordInputElement = await myPage.$(
      loginFormPasswordInputSelectorExpression,
    );

    // Fill password input
    print('Filling password input...');
    await loginFormPasswordInputElement.type(
      password,
      delay: inputTypeDelayDuration,
    );

    final loginFormSubmitButtonElement = await myPage.$(
      loginFormSubmitButtonSelectorExpression,
    );

    // Submit login form
    print('Submitting login form...');
    await loginFormSubmitButtonElement.tap();

    // Wait until notifications box appears
    print('Waiting for notification box...');
    await myPage.waitForXPath(
      notificationsXPathButtonSelectorExpression,
      timeout: waitTimeoutDuraton,
    );

    // Ignore notifications
    final notificationsButtonElements = await myPage.$x(
      notificationsXPathButtonSelectorExpression,
    );

    if (notificationsButtonElements.isNotEmpty) {
      final notificationsButtonElement = notificationsButtonElements.first;

      print('Ignoring notifications.');
      await notificationsButtonElement.click();
    }

    print('Getting profile following users...');

    final usersThatProfileFollows = await fetchAllUsers(
      profileId: profileId,
      page: myPage,
      following: true,
    );

    print('Getting profile followers users...');

    final usersThatAreFollowingProfile = await fetchAllUsers(
      profileId: profileId,
      page: myPage,
      following: false,
    );

    final usersThatProfileFollowsAndThatFollowProfile =
        usersThatProfileFollows.intersection(
      usersThatAreFollowingProfile,
    );

    final usersThatProfileFollowsAndThatDoNotFollowProfile =
        usersThatProfileFollows.difference(
      usersThatAreFollowingProfile,
    );

    final usersThatFollowProfileButThatProfileDoesntFollow =
        usersThatAreFollowingProfile.difference(
      usersThatProfileFollows,
    );

    printFormattedOutput(
      profileId: profileId,
      profileFollowsAndIsFollowed: usersThatProfileFollowsAndThatFollowProfile,
      profileFollowsAndIsNotFollowed:
          usersThatProfileFollowsAndThatDoNotFollowProfile,
      profileDoesNotFollowAndIsFollowed:
          usersThatFollowProfileButThatProfileDoesntFollow,
      outputMode: outputMode,
    );

    // Gracefully close the browser's process
    await browser.close();
  }
}

void printFormattedOutput({
  required String profileId,
  required Iterable<User> profileFollowsAndIsFollowed,
  required Iterable<User> profileFollowsAndIsNotFollowed,
  required Iterable<User> profileDoesNotFollowAndIsFollowed,
  required OutputMode outputMode,
}) {
  if (outputMode == OutputMode.markdown) {
    void printUsersMarkdownTable(final Iterable<User> users) {
      final header = '|ID|Full Name|Username|';
      final headerSeparator = '|--|---------|--------|';

      print(header);
      print(headerSeparator);
      for (final user in users) {
        print('|${user.id}|${user.fullName}|${user.username}|');
      }
    }

    print('# Profile ($profileId) follow vs following status\n');

    print('**Users that profile follows and is followed back**\n');
    printUsersMarkdownTable(profileFollowsAndIsFollowed);

    print('**Users that profile follows but is not followed back**\n');
    printUsersMarkdownTable(profileFollowsAndIsNotFollowed);

    print('**Users that profile does not follow and is followed back**\n');
    printUsersMarkdownTable(profileDoesNotFollowAndIsFollowed);
  } else {
    print(
      'These are the users that profile follows and is being followed:\n\n',
    );

    profileFollowsAndIsFollowed.forEach(print);

    print(
      'And these are the users that profile follows and are not following profile:\n\n',
    );

    profileFollowsAndIsNotFollowed.forEach(print);

    print(
      'And these are the users that profile does not follow but are following profile:\n\n',
    );

    profileDoesNotFollowAndIsFollowed.forEach(print);
  }
}
