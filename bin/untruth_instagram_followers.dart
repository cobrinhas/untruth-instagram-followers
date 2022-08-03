import 'package:puppeteer/puppeteer.dart';

const cookiesButtonSelectorExpression =
    "//button[contains(., 'Permitir apenas cookies essenciais')]";

const loginFormUsernameInputSelectorExpression = "input[name='username']";
const loginFormPasswordInputSelectorExpression = "input[name='password']";
const loginFormSubmitButtonSelectorExpression = "button[type='submit']";

const inputTypeDelayDuration = Duration(milliseconds: 50);

void main() async {
  // Download the Chromium binaries, launch it and connect to the "DevTools"
  final browser = await puppeteer.launch(
    headless: false,
  );

  // Open a new tab
  final myPage = await browser.newPage();

  // Go to a page and wait to be fully loaded
  await myPage.goto('https://instagram.com', wait: Until.networkIdle);

  final cookiesButtonElements = await myPage.$x(
    cookiesButtonSelectorExpression,
  );

  if (cookiesButtonElements.isNotEmpty) {
    final cookiesButtonElement = cookiesButtonElements.first;

    await cookiesButtonElement.click();
  }

  await Future.delayed(Duration(seconds: 2));

  final loginFormUsernameInputElement = await myPage.$(
    loginFormUsernameInputSelectorExpression,
  );

  await loginFormUsernameInputElement.type(
    'username example',
    delay: inputTypeDelayDuration,
  );

  final loginFormPasswordInputElement = await myPage.$(
    loginFormPasswordInputSelectorExpression,
  );

  await loginFormPasswordInputElement.type(
    'password',
    delay: inputTypeDelayDuration,
  );

  final loginFormSubmitButtonElement = await myPage.$(
    loginFormSubmitButtonSelectorExpression,
  );

  await loginFormSubmitButtonElement.tap();

  await Future.delayed(Duration(seconds: 3));

  // Gracefully close the browser's process
  await browser.close();
}
