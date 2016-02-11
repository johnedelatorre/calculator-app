//
//  SlideStartScreenVC.m
//  Blocpad
//
//  Created by hugh
//
//

#import "SlideStartScreenVC.h"

#define kPopupOriginX   35
#define kPopupOriginY   216
@interface SlideStartScreenVC ()

@end

@implementation SlideStartScreenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. Set contract name and location

    NSString *text;
    
    if ([DataModel sharedInstance].accountData != nil) {
        text = [[DataModel sharedInstance].accountData objectForKey:@"groupName"];
        NSLog(@"GroupName=%@", text);
        self.groupNameLabel.text = text;
        text = [[DataModel sharedInstance].accountData objectForKey:@"city"];

        NSString *locFormatter = @"%@, %@ %@";

        NSString *location;
        location = [NSString stringWithFormat:locFormatter, text,
                    [[DataModel sharedInstance].accountData objectForKey:@"state"],
                    [[DataModel sharedInstance].accountData objectForKey:@"zipcode"]];
        self.locationLabel.text = location;

//        if ([[DataModel sharedInstance].accountData objectForKey:@"state"] != nil) {
//            NSString *loc =@"%@, %@";
//            self.locationLabel.text = [NSString stringWithFormat:loc, text, [[DataModel sharedInstance].accountData objectForKey:@"state"]];
//        } else {
//            self.locationLabel.text = text;
//        }
        
    }
    
    self.timestampLabel.text = [DataModel sharedInstance].timestampText;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePopupNotificationHandler:)
                                                 name:@"closePopupNotification"
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- IBActions

- (IBAction)previousSlide
{
    [_delegate gotoPreviousSlide];
}


- (IBAction)nextSlide
{
    [_delegate gotoNextSlide];
}

- (IBAction)firstSlide
{
    [DataModel sharedInstance].accountData = nil;
    [_delegate gotoFirstSlide];
}

- (IBAction)openGrowthPopup
{
    NSLog(@"%s", __FUNCTION__);
    CGRect popupFrame = CGRectMake(kPopupOriginX, kPopupOriginY, self.growthPopup.frame.size.width, self.growthPopup.frame.size.height);
    self.growthPopup.bounds = self.view.bounds;
    self.growthPopup.frame = popupFrame;
    [self.view addSubview:self.growthPopup];
}


- (IBAction)openVolumePopup
{
    NSLog(@"%s", __FUNCTION__);

    CGRect popupFrame = CGRectMake(kPopupOriginX, kPopupOriginY, self.growthPopup.frame.size.width, self.growthPopup.frame.size.height);
    self.volumePopup.bounds = self.view.bounds;
    self.volumePopup.frame = popupFrame;
    [self.view addSubview:self.volumePopup];

}

- (IBAction)closePopup
{
    NSLog(@"%s", __FUNCTION__);
    
    NSNotification* closePopupNotification = [NSNotification notificationWithName:@"closePopupNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:closePopupNotification];

    
}
#pragma mark -- Notification Handlers

- (void)closePopupNotificationHandler:(NSNotification*)notification
{
#ifdef DEBUGX
    NSLog(@"%s", __FUNCTION__);
#endif
    [self.volumePopup removeFromSuperview];
    [self.growthPopup removeFromSuperview];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
    
    
//    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
//    UIView* hitView = [self.view hitTest:locationPoint withEvent:event];
//    NSLog(@"hitView.tag = %i", hitView.tag);
//    if (hitView.tag < 100) {
//        NSNotification* closePopupNotification = [NSNotification notificationWithName:@"closePopupNotification" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:closePopupNotification];
//    }
}



@end
