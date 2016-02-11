//
//  VideoSlideVC.h
//
//  Created by hugh
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlideViewController.h"
#import "FoundationMovieView.h"

@interface SlideHomeVideoVC : SlideViewController <FoundationMovieViewDelegate> {
    UIImageView *_bufferingImage;
    BOOL _isInManualMode;
}

@property (nonatomic, strong) IBOutlet UIImageView *bufferingImage;
@property (nonatomic, assign) BOOL isPlaying;

- (void)restartVideo;
- (void)pauseVideo;
- (void)playVideo;


@end