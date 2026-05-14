Future<void> delayFunction(int seconds, {void Function()? function}) async {
  await Future.delayed(Duration(seconds: seconds));
  function?.call();
}
