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
    [self dismissAnimated:YES withCompletionHandler:nil];
  } else {
    %orig;
  }
}

%end
