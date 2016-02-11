//
//  VideoSlideVC.m
//
//  Created by hugh
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlideHomeVideoVC.h"
#import "UserSettings.h"

@interface SlideHomeVideoVC() {
    UIImageView *_posterImage;
    UIButton *_playButton;
    UIButton *_pauseButton;
    UIButton *_nextSlideButton;
    UIButton *_prevSlideButton;
    FoundationMovieView *_videoView;
    BOOL _isFirstSlide;
    BOOL _isLastSlide;
    BOOL _videoComplete;
}


@end

@implementation SlideHomeVideoVC

@synthesize bufferingImage = _bufferingImage;
@synthesize isPlaying = _isPlaying;

- (void)dealloc {
    [_videoView cleanupPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFirstSlide = [[_slideModel.slideData objectForKey:@"isFirstSlide"] boolValue];
    _isLastSlide = [[_slideModel.slideData objectForKey:@"isLastSlide"] boolValue];
        
    //create video player
    _videoView = [[FoundationMovieView alloc] initWithFrame:CGRectMake(0, -38.0, 1024, 748)];
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:[_slideModel.slideData objectForKey:@"videoUrl"] ofType:@"mov"];
    [_videoView loadPath:videoPath autoPlay:YES]; 
    _videoView.hidden = NO;
    _videoView.alpha = 1.0;
    _videoView.delegate = self;
    [self.view addSubview:_videoView];
    
    //create poster image
    UIImage *image = [UIImage imageNamed:[_slideModel.slideData objectForKey:@"posterUrl"]];
    _posterImage = [[UIImageView alloc] initWithImage:image];
    _posterImage.hidden = YES;
    [self.view addSubview:_posterImage];
    
    //create play button
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 1024, 748)];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"home_btn_play.png"] forState:UIControlStateNormal]; 
    [_playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = YES;
    [self.view addSubview:_playButton];
    
    _pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 1024, 748)]; 
    [_pauseButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.hidden = NO;
    [self.view addSubview:_pauseButton];
    
    //set next and last slides
    if (!_isFirstSlide) {
        _prevSlideButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height / 2 - 57, 57, 57)];
        [_prevSlideButton setBackgroundImage:[UIImage imageNamed:@"home_btn_arrowLeft.png"] forState:UIControlStateNormal]; 
        [_prevSlideButton addTarget:self action:@selector(prevSlideButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_prevSlideButton];
    }
    
    if (!_isLastSlide) {
        _nextSlideButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 87, self.view.frame.size.height / 2 - 57, 57, 57)];
        [_nextSlideButton setBackgroundImage:[UIImage imageNamed:@"home_btn_arrowRight.png"] forState:UIControlStateNormal]; 
        [_nextSlideButton addTarget:self action:@selector(nextSlideButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextSlideButton];
    }
    
    if ([_slideModel.slideData objectForKey:@"bufferImageUrl"]) {
        [_bufferingImage setImage:[UIImage imageNamed:[_slideModel.slideData objectForKey:@"bufferImageUrl"]]];
    }
        
    _isPlaying = YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_videoView cleanupPlayer];
    self.bufferingImage = nil;
    
}

- (BOOL)isPlaying {
    return _isPlaying;
}

#pragma mark - gesture handlers

- (void)playButtonTapped:(id)sender { 
        
    if (!_playButton.hidden) {
        _posterImage.hidden = YES;
        _playButton.hidden = YES;
        _pauseButton.hidden = NO;
        _isPlaying = YES;
        [self playVideo];
        
        if (_videoComplete && _isLastSlide) {
            [_delegate gotoSlideWithName:kSlideHome andOverrideTransition:kPresentationTransitionCut];
        }
        
    }else{
        _playButton.hidden = NO;
        _pauseButton.hidden = YES;
        _isPlaying = NO;
        [self pauseVideo];
    }
}

- (void)prevSlideButtonTapped:(id)sender {
    [_videoView cleanupPlayer];
    [_delegate gotoPreviousSlide];
}

- (void)nextSlideButtonTapped:(id)sender {
    [_videoView cleanupPlayer];
    [_delegate gotoNextSlide];
}

//- (void)willGotoNextSlide {
//    self.isInManualMode = YES;
//}
//
//- (void)willgotoPrevSlide {
//    self.isInManualMode = YES;
//}

- (void)restartVideo {
    _isPlaying = YES;
    _bufferingImage.hidden = YES;
    _posterImage.hidden = YES;
    _playButton.hidden = YES;
    _pauseButton.hidden = NO;
    [_videoView seekTo:0];
    [_videoView play];
}

- (void)pauseVideo {
    [_videoView pause];
}

- (void)playVideo {
    [_videoView play];
}

#pragma mark - FoundationMovieViewDelegate Methods

- (void)foundationMovieView:(FoundationMovieView *)foundationMovieView playerIsReady:(AVPlayer *)player {
    
}

- (void)foundationMoviePlayerDidFinish:(FoundationMovieView *)foundationMovieView {
    
    _videoComplete = YES;
    
//    if (_isLastSlide) {
//        self.isInManualMode = YES;
//    }
    
    if (_isLastSlide) {
        _posterImage.hidden = NO;
        _playButton.hidden = NO;
        _pauseButton.hidden = YES;
        [_videoView seekTo:0];
    }else{
        [_delegate gotoSlideWithName:_slideModel.nextSlideName andOverrideTransition:kPresentationTransitionCut];
    }
}

@end
