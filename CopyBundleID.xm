#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Interfaces.h"
#import "CopyBundleID.h"
#import "Utils.h"

%hook SBUIAppIconForceTouchControllerDataProvider

- (NSArray*)applicationShortcutItems {
  if (!config.isEnabled) {
    return %orig;
  }

  NSArray* res = %orig;
  if(res == nil) {
    res = [NSArray new];
  } else {
    SBSApplicationShortcutItem* last = [res lastObject];
    if (last != nil && [last.type isEqualToString: actionTypeId]) {
      // already added
      return res;
    }
  }

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
    [UIPasteboard generalPasteboard].string = arg2.localizedSubtitle;

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
