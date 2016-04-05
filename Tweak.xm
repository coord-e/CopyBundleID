#define comTypeId @"com.coord-e.copybundleid"

@interface SBSApplicationShortcutItem : NSObject
@property(nonatomic, copy) NSString *type;
+ (instancetype)staticShortcutItemWithDictionary:(NSDictionary*)arg1 localizationHandler:(NSString* (^)(NSString*, NSString*))arg2;
@end

@interface SBApplicationShortcutMenu : NSObject
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
@end

@interface SBApplicationShortcutMenuItemView : UIView
@property(retain, nonatomic) SBSApplicationShortcutItem *shortcutItem;
@end

%hook SBApplicationShortcutStoreManager

- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
		NSArray* res = %orig;
		if(res == nil)
			res = [NSArray new];

		NSDictionary *info = @{@"UIApplicationShortcutItemTitle": @"Copy Bundle ID",
																									@"UIApplicationShortcutItemSubtitle": arg1,
																									@"UIApplicationShortcutItemType": comTypeId };

		SBSApplicationShortcutItem *copyAction = [%c(SBSApplicationShortcutItem) staticShortcutItemWithDictionary: info localizationHandler: nil];

		return [res arrayByAddingObjectsFromArray: @[copyAction]];
}
%end


%hook SBApplicationShortcutMenuItemView

- (void)_setupViewsWithIcon: (UIImage*)icon title: (NSString*)title subtitle: (NSString*)subtitle
{
								if([self.shortcutItem.type isEqualToString:comTypeId]) {
																UIImage *image = [%c(UIImage) imageNamed: @"/Library/Application Support/CopyBundleID/Resources.bundle/Icon"];
																%orig(image, title, subtitle);
								} else
																%orig;
}

- (id)initWithShortcutItem:(SBSApplicationShortcutItem*)item menuPosition:(int)arg2 orientation:(int)arg3 application:(id)arg4 assetManagerProvider:(id)arg5 monogrammerProvider:(id)arg6 options:(unsigned)arg7
{
	if([item.type isEqualToString:comTypeId]) {
		return %orig(item, arg2, arg3, arg4, arg5, arg6, 0);
	} else
		return %orig;
}

%end

%hook SBApplicationShortcutMenu

- (void)menuContentView: (id)arg1 activateShortcutItem: (UIApplicationShortcutItem*)arg2 index: (long long)arg3
{
								if([arg2.type isEqualToString:comTypeId]) {
																[%c(UIPasteboard) generalPasteboard].string = arg2.localizedSubtitle;
																[self dismissAnimated:YES completionHandler:nil];
								} else
																%orig;
}

%end
