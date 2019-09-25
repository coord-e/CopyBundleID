@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
@property(readonly, nonatomic) NSString *applicationBundleIdentifier;
@end

@interface SBUIAppIconForceTouchController : NSObject
- (void)dismissAnimated:(_Bool)arg1 withCompletionHandler:(id)arg2;
- (void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(id)arg2;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImagePNGData:(id)arg1;
@end
