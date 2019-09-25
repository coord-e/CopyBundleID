#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Interfaces.h"
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

%hook SBUIAppIconForceTouchControllerDataProvider

- (NSArray*)applicationShortcutItems {
  if (!config.isEnabled) {
    return %orig;
  }

  NSArray* res = %orig;
  if(res == nil)
    res = [NSArray new];

  SBSApplicationShortcutCustomImageIcon* icon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:iconData];

  SBSApplicationShortcutItem *copyAction = [%c(SBSApplicationShortcutItem) new];
  copyAction.localizedTitle = @"Copy Bundle ID";
  copyAction.localizedSubtitle = self.applicationBundleIdentifier;
  copyAction.type = actionTypeId;
  copyAction.icon = icon;

  return [res arrayByAddingObject: copyAction];
}

%end

%hook SBUIAppIconForceTouchController

- (void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(SBSApplicationShortcutItem*)arg2 {
  if([arg2.type isEqualToString:actionTypeId]) {
    [%c(UIPasteboard) generalPasteboard].string = arg2.localizedSubtitle;

    if (config.isSoundEnabled) {
      AudioServicesPlayAlertSound(1007);
    }
    if (config.isAlertEnabled) {
      presentToast(@"✓ Copied!", 0.2);
    }

    [self dismissAnimated:YES withCompletionHandler:nil];
  } else {
    %orig;
  }
}

%end

%ctor {
  initialize();
  %init;
}
