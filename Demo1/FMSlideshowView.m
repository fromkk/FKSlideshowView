//
//  FKSlideshowView.m
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/09.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import "FKSlideshowView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FKSlideshowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _initialize];
        self.images = @[];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
        self.images = @[];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        [self _initialize];
        self.images = images;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    layouted = YES;
    
    firstImageView.frame = self.bounds;
    secondImageView.frame = self.bounds;
}

- (void)_initialize
{
    if (initialized)
    {
        return;
    }
    
    self.status = FKSlideshowStatusPause;
    initialized = YES;
    layouted = NO;
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    loopCount = 0;
    
    firstImageView = [[UIImageView alloc] init];
    firstImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    secondImageView = [[UIImageView alloc] init];
    secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    secondImageView.alpha = 0.0f;
    
    activeImageView = firstImageView;
    
    //firstImageView.layer.borderColor = [UIColor redColor].CGColor;
    //firstImageView.layer.borderWidth = 5.0;
    
    //secondImageView.layer.borderColor = [UIColor blueColor].CGColor;
    //secondImageView.layer.borderWidth = 5.0;
    
    [self addSubview:firstImageView];
    [self addSubview:secondImageView];
    
    self.duration = FKSlideshowDefaultDuration;
    self.fade     = FKSlideshowDefaultFade;
    self.type     = FKSlideshowTypeCrossfade;
}

- (void)_fire
{
    loopCount++;
    
    int index = loopCount % self.images.count;
    activeImage = [self.images objectAtIndex:index];
    
    if ( 0 == loopCount % 2 )
    {
        activeImageView = firstImageView;
    } else
    {
        activeImageView = secondImageView;
    }
    activeImageView.image = activeImage;
    
    [self _crossfade];
}

- (void)_crossfade
{
    __weak typeof(self) _wself = self;
    
    [UIView animateWithDuration:self.fade animations:^{
        if (!_wself)
        {
            return;
        }
        
        if ( 0 == loopCount % 2 )
        {
            firstImageView.alpha = 1.0f;
            secondImageView.alpha = 0.0f;
        } else
        {
            firstImageView.alpha = 0.0f;
            secondImageView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        timer = [NSTimer scheduledTimerWithTimeInterval:_wself.duration target:_wself selector:@selector(_fire) userInfo:nil repeats:NO];
    }];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    if (0 < images.count)
    {
        int index = loopCount % images.count;
        activeImage = [images objectAtIndex:index];
        activeImageView.image = activeImage;
    }
}

- (BOOL)playing
{
    return self.status == FKSlideshowStatusPlaying;
}

- (void)play
{
    if ( self.playing )
    {
        return;
    }

    if (timer.isValid)
    {
        [timer invalidate];
    }
    
    self.status = FKSlideshowStatusPlaying;
    timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(_fire) userInfo:nil repeats:NO];
}

- (void)pause
{
    if (!self.playing)
    {
        return;
    }
    
    if (timer.isValid)
    {
        [timer invalidate];
    }
    
    [firstImageView.layer removeAllAnimations];
    [secondImageView.layer removeAllAnimations];
    
    self.status = FKSlideshowStatusPause;
}

- (void)dealloc
{
    if (self.playing) [self pause];
    firstImageView.image = nil;
    secondImageView.image = nil;
    [firstImageView removeFromSuperview];
    [secondImageView removeFromSuperview];
    firstImageView = nil;
    secondImageView = nil;
    activeImage = nil;
    activeImageView = nil;
    self.images = nil;
}

@end
