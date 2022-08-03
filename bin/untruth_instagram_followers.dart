import 'package:puppeteer/puppeteer.dart';
import 'package:untruth_instagram_followers/untruth_instagram_followers.dart';

void main() async {
  // Download the Chromium binaries, launch it and connect to the "DevTools"
  final browser = await puppeteer.launch(
    headless: false,
  );

  // Open a new tab
  final myPage = await browser.newPage();

  // Go to a page and wait to be fully loaded
  await myPage.goto(instagramUrl, wait: Until.networkIdle);

  final cookiesButtonElements = await myPage.$x(
    cookiesButtonXPathSelectorExpression,
  );

  // Accept cookies box if present
  if (cookiesButtonElements.isNotEmpty) {
    final cookiesButtonElement = cookiesButtonElements.first;

    await cookiesButtonElement.click();
  }

  await Future.delayed(afterActionDelayDuration);

  // Fill username input
  final loginFormUsernameInputElement = await myPage.$(
    loginFormUsernameInputSelectorExpression,
  );

  await loginFormUsernameInputElement.type(
    username,
    delay: inputTypeDelayDuration,
  );

  // Fill password input
  final loginFormPasswordInputElement = await myPage.$(
    loginFormPasswordInputSelectorExpression,
  );

  await loginFormPasswordInputElement.type(
    password,
    delay: inputTypeDelayDuration,
  );

  // Submit login form
  final loginFormSubmitButtonElement = await myPage.$(
    loginFormSubmitButtonSelectorExpression,
  );

  await loginFormSubmitButtonElement.tap();

  // Wait until notifications box appears
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

    await notificationsButtonElement.click();
  }

  print('Getting profile following users...');

  final followingUsers = await fetchAllUsers(
    profileId: profileId,
    page: myPage,
    following: true,
  );

  print('Getting profile followers users...');

  final followersUsers = await fetchAllUsers(
    profileId: profileId,
    page: myPage,
    following: false,
  );

  final usersThatProfileFollowsAndThatFollowProfile =
      followingUsers.intersection(
    followersUsers,
  );

  final usersThatProfileFollowsAndThatDoNotFollowProfile =
      followingUsers.difference(
    usersThatProfileFollowsAndThatFollowProfile,
  );

  final usersThatFollowProfileButThatProfileDoesntFollow =
      followersUsers.difference(
    usersThatProfileFollowsAndThatFollowProfile,
  );

  print(
    'These are the users that profile follows and is being followed:\n\n',
  );

  usersThatProfileFollowsAndThatFollowProfile.forEach(print);

  print(
    'And these are the users that profile follows and are not following profile:\n\n',
  );

  usersThatProfileFollowsAndThatDoNotFollowProfile.forEach(print);

  print(
    'And these are the users that profile does not follow but are following profile:\n\n',
  );

  usersThatFollowProfileButThatProfileDoesntFollow.forEach(print);

  // Gracefully close the browser's process
  await browser.close();
}
