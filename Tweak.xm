#import <UIKit/UIKit.h>

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

#define comTypeId @"com.coord-e.copybundleid"

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property(nonatomic, copy) NSString *type;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
@property(readonly, nonatomic) NSString *applicationBundleIdentifier;
@end

@interface SBUIAppIconForceTouchController : NSObject
- (void)dismissAnimated:(_Bool)arg1 withCompletionHandler:(id)arg2;
- (void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(id)arg2;
@end

%hook SBUIAppIconForceTouchControllerDataProvider

- (NSArray*)applicationShortcutItems {
    NSArray* res = %orig;
    if(res == nil)
      res = [NSArray new];

    SBSApplicationShortcutItem *copyAction = [%c(SBSApplicationShortcutItem) new];
    copyAction.localizedTitle = @"Copy Bundle ID";
    copyAction.localizedSubtitle = self.applicationBundleIdentifier;
    copyAction.type = comTypeId;

    return [res arrayByAddingObject: copyAction];
}

%end

%hook SBUIAppIconForceTouchController

- (void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(SBSApplicationShortcutItem*)arg2 {
  if([arg2.type isEqualToString:comTypeId]) {
    [%c(UIPasteboard) generalPasteboard].string = arg2.localizedSubtitle;
    presentToast(@"✓ Copied!", 0.2);
    [self dismissAnimated:YES withCompletionHandler:nil];
  } else {
    %orig;
  }
}

%end
