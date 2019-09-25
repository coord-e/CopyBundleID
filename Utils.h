#ifndef COPYBUNDLEID_UTILS_H
#define COPYBUNDLEID_UTILS_H

#import "CopyBundleID.h"

static UIViewController* obtainBaseController() {
  UIViewController *base = [UIApplication sharedApplication].keyWindow.rootViewController;
  while (base.presentedViewController != nil && !base.presentedViewController.isBeingDismissed) {
    base = base.presentedViewController;
  }
  return base;
}

static void presentToast(NSString* message, float duration) {
  UIViewController* controller = obtainBaseController();
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                message:message
                                                preferredStyle:UIAlertControllerStyleAlert];

  [controller presentViewController:alert animated:YES completion: ^{
    dispatch_time_t time = dispatch_walltime(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
      [alert dismissViewControllerAnimated:YES completion:nil];
    });
  }];
}

static BOOL unwrap(CFPropertyListRef val, BOOL default_) {
  return val ? [(__bridge id)val boolValue] : default_;
}

static void loadPrefs() {
  CFPreferencesAppSynchronize(preferenceId);
  config.isEnabled      = unwrap(CFPreferencesCopyAppValue(CFSTR("enabled"), preferenceId), YES);
  config.isSoundEnabled = unwrap(CFPreferencesCopyAppValue(CFSTR("enableSound"), preferenceId), YES);
  config.isAlertEnabled = unwrap(CFPreferencesCopyAppValue(CFSTR("enableAlert"), preferenceId), YES);
}

static void loadIconData() {
  iconData = [NSData dataWithContentsOfFile: @"/Library/Application Support/CopyBundleID/icon@3x.png"];
}

static void initialize() {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                  NULL,
                                  (CFNotificationCallback)loadPrefs,
                                  notificationId,
                                  NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
  loadIconData();
}

#endif
