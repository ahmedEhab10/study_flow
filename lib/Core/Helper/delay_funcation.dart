void delayFunction(int seconds, {Function? function}) async {
  await Future.delayed(Duration(seconds: seconds), () {
    function!();
  });
}
