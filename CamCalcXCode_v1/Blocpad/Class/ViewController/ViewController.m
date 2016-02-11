//
//  ViewController.m
//
//  Created by hugh
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UserSettings.h"
#import "SlideHomeVideoVC.h"

@implementation ViewController
@synthesize popOverNavigation = _popOverNavigation;
@synthesize overlayView = _overlayView;
@synthesize tabBarOverlayView = _tabBarOverlayView;
@synthesize tabBar = _tabBar;
@synthesize navigationButtons = _navigationButtons;
@synthesize espButton = _espButton;
@synthesize selectedButton = _selectedButton;
@synthesize lastSelectedButton = _lastSelectedButton;
@synthesize isOnHomeSlide = _isOnHomeSlide;
@synthesize isOnEspSlide = _isOnEspSlide;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.presentationModel = [PresentationModel presentationModelWithPlistFile:@"mainPresentation.plist"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    _isOnHomeSlide = YES;
    _selectedButton = [_navigationButtons objectAtIndex:0];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self gotoSlideWithName:kSlideHome andOverrideTransition:kPresentationTransitionFadeInFadeOut];
    
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [_overlayView setBackgroundColor:[UIColor blackColor]];
    [_overlayView setAlpha:0];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePopOver)];
    [_overlayView addGestureRecognizer:tapGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.popOverNavigation = nil;
    self.tabBar = nil;
    self.navigationButtons = nil;
    self.espButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark - menu button tap handlers

- (void)setSelectedButton:(UIButton *)selectedButton {
        
    _selectedButton.selected = NO;
    _selectedButton = selectedButton;
    _selectedButton.selected = YES;
}

- (void)onHomeButtonTapped:(id)sender {
    
    if (self.isTransitioning) {
        return;
    }
    
    _lastSelectedButton = sender;

    _isOnHomeSlide = YES;
    _isOnEspSlide = NO;
    _espButton.selected = NO;
    
    if ([self isDifferentSection:kSlideHome]) { 
        [self gotoSlideWithName:kSlideHome andOverrideTransition:kPresentationTransitionFadeInFadeOut];
        self.selectedButton = (UIButton*)sender;
    }
}

- (void)onHerdRiskButtonTapped:(id)sender {
    
    if (self.isTransitioning) {
        return;
    }
    _lastSelectedButton = sender;

    _isOnHomeSlide = NO;
    _isOnEspSlide = NO;
    _espButton.selected = NO;
    
    //[UserSettings sharedInstance].isHomeSlideInManualMode = YES;
    
    if ([self isDifferentSection:kSlideHerdRisk]) { 
        [self gotoSlideWithName:kSlideHerdRisk andOverrideTransition:kPresentationTransitionFadeInFadeOut];
        self.selectedButton = (UIButton*)sender;
    }
}

- (void)onImpactButtonTapped:(id)sender {
    
    if (self.isTransitioning) {
        return;
    }
    _lastSelectedButton = sender;

    _isOnHomeSlide = NO;
    _isOnEspSlide = NO;
    _espButton.selected = NO;
    
    //[UserSettings sharedInstance].isHomeSlideInManualMode = YES;
    
    if ([self isDifferentSection:kSlideImpact]) { 
        [self gotoSlideWithName:kSlideImpact andOverrideTransition:kPresentationTransitionFadeInFadeOut];
        self.selectedButton = (UIButton*)sender;
    }
}

- (void)onSolutionsButtonTapped:(id)sender {
    
    if (self.isTransitioning) {
        return;
    }
    _lastSelectedButton = sender;

    _isOnHomeSlide = NO;
    _isOnEspSlide = NO;
    _espButton.selected = NO;
    
    //[UserSettings sharedInstance].isHomeSlideInManualMode = YES;
    
    if ([self isDifferentSection:kSlideSolutions]) { 
        [self gotoSlideWithName:kSlideSolutions andOverrideTransition:kPresentationTransitionFadeInFadeOut];
        self.selectedButton = (UIButton*)sender;
    }
}

- (void)onESPButtonTapped:(id)sender {
    
    if (self.isTransitioning) {
        return;
    }
    
    //[UserSettings sharedInstance].isHomeSlideInManualMode = YES;
    
    if (_overlayView.alpha == 0 && _tabBarOverlayView.alpha == 0) {

        if (_isOnHomeSlide) {
            [((SlideHomeVideoVC*)self.activeSlide) pauseVideo];
        }
        
        
        
        [self.view insertSubview:_overlayView atIndex:1];
        [_tabBar addSubview:_tabBarOverlayView];
        
        [UIView animateWithDuration:.5 animations:^(void) {
            [_overlayView setAlpha:0.5];
            [_tabBarOverlayView setAlpha:0.5];
        }];
        
        [_popOverNavigation setFrame:CGRectMake(29, 487, _popOverNavigation.frame.size.width, _popOverNavigation.frame.size.height)];
        [_tabBar insertSubview:sender aboveSubview:_tabBarOverlayView];
        [self.view insertSubview:_popOverNavigation atIndex:3];
        
        _lastSelectedButton = _selectedButton;
        self.selectedButton = (UIButton*)sender;
        
    } else {
        [self removePopOver];
    }
}
- (void)onESPTechnicalServicesButtonTapped:(id)sender
{
    [self removePopOver];
    _isOnHomeSlide = NO;
    _lastSelectedButton = _espButton;

    self.selectedButton = _espButton;
    
    [self gotoSlideWithName:kSlideESP andOverrideTransition:kPresentationTransitionFadeInFadeOut];
}

- (void)onESPStompButtonTapped:(id)sender
{
    [self removePopOver];
    _isOnHomeSlide = NO;
    _lastSelectedButton = _espButton;
    self.selectedButton = _espButton;
    
    [self gotoSlideWithName:kSlideESP1 andOverrideTransition:kPresentationTransitionFadeInFadeOut];
}

- (void)onESPRespiSureButtonTapped:(id)sender
{
    [self removePopOver];
    _isOnHomeSlide = NO;
    _lastSelectedButton = _espButton;
    self.selectedButton = _espButton;
     
    [self gotoSlideWithName:kSlideESP2 andOverrideTransition:kPresentationTransitionFadeInFadeOut];
}

- (void)onESPLincomixButtonTapped:(id)sender
{
    [self removePopOver];
    _isOnHomeSlide = NO;
    _lastSelectedButton = _espButton;
    self.selectedButton = _espButton;
     
    [self gotoSlideWithName:kSlideESP3 andOverrideTransition:kPresentationTransitionFadeInFadeOut];
}

- (void)onESPDraxxinButtonTapped:(id)sender
{
    [self removePopOver];
    _isOnHomeSlide = NO;
    _lastSelectedButton = _espButton;
    self.selectedButton = _espButton;
    
    [self gotoSlideWithName:kSlideESP4 andOverrideTransition:kPresentationTransitionFadeInFadeOut];
}
     
- (BOOL)isDifferentSection:(NSString *)slideId 
{
    BOOL isDifferent = NO;
    SlideModel *toSlide = [_presentationModel slideWithName:slideId];
    if (![toSlide.category isEqualToString:_activeSlide.slideModel.category]) {
        isDifferent = YES;
    }
    
    return isDifferent;
}

- (void)removePopOver
{
    self.selectedButton = _lastSelectedButton;

    if (_isOnHomeSlide && ((SlideHomeVideoVC*)self.activeSlide).isPlaying) {
        [((SlideHomeVideoVC*)self.activeSlide) playVideo];
    }
    
    [_overlayView setAlpha:0];
    [_tabBarOverlayView setAlpha:0];
    [_overlayView removeFromSuperview];
    [_tabBarOverlayView removeFromSuperview];
    [_popOverNavigation removeFromSuperview];
}


@end
