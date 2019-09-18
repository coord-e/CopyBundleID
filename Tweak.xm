#define comTypeId @"com.coord-e.copybundleid"

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property(nonatomic, copy) NSString *type;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
@property(readonly, nonatomic) NSString *applicationBundleIdentifier;
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
