//
//  AppDelegate.m
//
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UserSettings.h"
#import "SlideHomeVideoVC.h"
#import "SQLiteDB.h"
#import "CAMCalcLogic.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DataModel sharedInstance].needsLookup = YES;
//    NSLog(@"didFinishLaunchingWithOptions: needsLookup = %@", [DataModel sharedInstance].needsLookup ? @"YES" : @"NO");

    [SQLiteDB installDatabase];
    sleep(2);

    // Initialize DataModel variables
    [DataModel sharedInstance].quarterIdList = [CAMCalcLogic listQuarterIDs];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (_viewController.isOnHomeSlide) {
        [_viewController removePopOver];
        
        if ([_viewController.activeSlide.slideModel.name isEqualToString:kSlideHome]) {
            [((SlideHomeVideoVC*)_viewController.activeSlide) restartVideo];
        }else{
            [_viewController gotoSlideWithName:kSlideHome andOverrideTransition:kPresentationTransitionCut];
        }
    }
    
    _viewController.isTransitioning = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{        
    NSLog(@"%s", __FUNCTION__);
    [DataModel sharedInstance].needsLookup = YES;
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
