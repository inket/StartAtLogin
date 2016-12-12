//
//  AppDelegate.m
//  StartAtLoginHelper
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self launchMainApp];
    [NSApp terminate:nil];
}

- (void)launchMainApp {
    if ([self mainAppIsAlreadyRunning]) {
        NSLog(@"App is already running");
        return;
    } else {
        NSLog(@"Launching app...");
    }

    NSArray* helperPathComponents = [[NSBundle mainBundle].bundlePath pathComponents];
    NSArray* appPathComponents = [helperPathComponents subarrayWithRange:NSMakeRange(0, helperPathComponents.count - 4)];

    NSString* appPath = [NSString pathWithComponents:appPathComponents];
    [[NSWorkspace sharedWorkspace] launchApplication:appPath];
}

- (BOOL)mainAppIsAlreadyRunning {
    NSString* appBundleIdentifier = [self mainAppBundleIdentifier];
    NSArray* runningApps = [[NSWorkspace sharedWorkspace] runningApplications];

    for (NSRunningApplication* runningApp in runningApps) {
        if ([runningApp.bundleIdentifier isEqualToString:appBundleIdentifier]) {
            return YES;
        }
    }

    return NO;
}

- (NSString*)mainAppBundleIdentifier {
    NSString* helperBundleIdentifier = [NSBundle mainBundle].bundleIdentifier;

    NSArray* bundleIdentifierComponents = [helperBundleIdentifier componentsSeparatedByString:@"-"];
    bundleIdentifierComponents = [bundleIdentifierComponents subarrayWithRange:NSMakeRange(0, bundleIdentifierComponents.count - 1)];

    NSLog(@"%@", bundleIdentifierComponents);

    return [bundleIdentifierComponents componentsJoinedByString:@"-"];
}

@end
