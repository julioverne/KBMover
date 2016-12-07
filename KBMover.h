#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import <notify.h>
#import <substrate.h>
#import <libactivator/libactivator.h>
#import <CommonCrypto/CommonCrypto.h>

#define PLIST_PATH_Settings "/var/mobile/Library/Preferences/com.julioverne.kbmover.plist"

@interface UIInputSetHostView : UIView
@end

@interface UIInputSetContainerView : UIView
@end

@interface UIKeyboardLayoutStar : UIView
{
	UIView *_keyplaneView;
}
@end

@interface UIKeyboardImpl : UIView
{
	NSMutableDictionary *m_keyedLayouts;
	UIKeyboardLayoutStar *m_layout;
}
+ (id)sharedInstance;
+ (id)keyboardWindow;
+ (id)keyboardScreen;
+ (id)activeInstance;
- (void)setFrame:(CGRect)arg1;
+ (void)setPersistentOffset:(CGPoint)arg1;
@end


