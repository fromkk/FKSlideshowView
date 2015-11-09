//
//  FKSlideshowView.m
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/09.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import "FKSlideshowView.h"

@implementation FKSlideshowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


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
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    loopCount = 0;
    
    firstImageView = [[UIImageView alloc] init];
    firstImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    secondImageView = [[UIImageView alloc] init];
    secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    secondImageView.alpha = 0.0f;
    [self addSubview:firstImageView];
    [self addSubview:secondImageView];
    
    self.duration = FKSlideshowDefaultDuration;
    self.fade     = FKSlideshowDefaultFade;

    [self play];
}

- (void)_fire
{
    __weak typeof(self) _wself = self;
    [UIView animateWithDuration:self.fade animations:^{
        if (!_wself)
        {
            return;
        }
        
        int index = loopCount % _wself.images.count;
        activeImage = [_wself.images objectAtIndex:index];
        
        if ( 0 == loopCount % 2 )
        {
            secondImageView.image = activeImage;
            firstImageView.alpha = 0.0f;
            secondImageView.alpha = 1.0;
        } else
        {
            firstImageView.image = activeImage;
            firstImageView.alpha = 1.0f;
            secondImageView.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        loopCount++;
    }];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    if (0 < images.count)
    {
        if (nil == activeImage)
        {
            [self _fire];
        }
    }
}

- (void)setDuration:(CGFloat)duration
{
    _duration = duration;
    
    if (self.playing)
    {
        [self pause];
        [self play];
    }
}

- (void)setFade:(CGFloat)fade
{
    _fade = fade;
    
    if (self.playing)
    {
        [self pause];
        [self play];
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
    timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(_fire) userInfo:nil repeats:YES];
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
    self.images = nil;
}

@end
