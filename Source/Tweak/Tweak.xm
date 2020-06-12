#import "Tweak.h"
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.minazuki.mysiri.plist"

static BOOL enabled;

static void loadPrefs()
{

     NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

     enabled = [[prefs objectForKey:@"enabled"] boolValue];

}

void updateSettings(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo) {
    loadPrefs();
}

%hook SUICFlamesView

%property (nonatomic, retain) UIImageView *msView;

-(void)layoutSubviews
{
        if (enabled) {

        %orig;
        if (!self.msView) {

            NSString* const imagesDomain = @"com.minazuki.mysiri";
            NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage" inDomain:imagesDomain];
            UIImage *bgImage = [UIImage imageWithData:data];

            self.msView = [[UIImageView alloc] initWithImage: bgImage];
            self.msView.frame = CGRectMake(0,self.frame.size.height/7,self.frame.size.width,self.frame.size.height);
            self.msView.contentMode = UIViewContentModeScaleAspectFit;
            self.msView.userInteractionEnabled = NO;
            [self insertSubview:self.msView atIndex:0];

        }

        } else {
		return %orig;
        }

}

%end

%ctor 
{

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
        NULL, &updateSettings, 
        CFSTR("com.minazuki.mysiri/reload"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    @autoreleasepool {
        loadPrefs();
        %init;
    }
}
