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
    
    if (self.type == FKSlideshowTypeCrossfade)
    {
        firstImageView.frame = self.bounds;
        secondImageView.frame = self.bounds;
    } else
    {
        [self _imageViewFrameAdjust:firstImageView];
        [self _imageViewFrameAdjust:secondImageView];
    }
}

- (void)setType:(FKSlideshowType)type
{
    _type = type;
    
    [self setNeedsLayout];
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
    
//    firstImageView.layer.borderColor = [UIColor redColor].CGColor;
//    firstImageView.layer.borderWidth = 5.0;
//    
//    secondImageView.layer.borderColor = [UIColor blueColor].CGColor;
//    secondImageView.layer.borderWidth = 5.0;
    
    [self addSubview:firstImageView];
    [self addSubview:secondImageView];
    
    self.duration = FKSlideshowDefaultDuration;
    self.fade     = FKSlideshowDefaultFade;
    self.type     = FKSlideshowDefaultType;
}

- (void)_fire
{
    loopCount++;
    
    if (timer.isValid)
    {
        [timer invalidate];
    }
    
    int index = loopCount % self.images.count;
    activeImage = [self.images objectAtIndex:index];
    
    [self _setActiveImage:activeImage];
    [self _crossfade];
}

- (void)_crossfade
{
    __weak typeof(self) _wself = self;
    
    [self _beforeCrossFade];
    
    [NSTimer scheduledTimerWithTimeInterval:self.fade / 2.0f target:self selector:@selector(_effect) userInfo:nil repeats:NO];
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
        if (!_wself)
        {
            return;
        }
        
        [_wself _afterCrossFade];
        timer = [NSTimer scheduledTimerWithTimeInterval:_wself.duration target:_wself selector:@selector(_fire) userInfo:nil repeats:NO];
    }];
}

- (void)_beforeCrossFade
{
    switch (self.type) {
        case FKSlideshowTypeSlideRight:
            if (0 == loopCount % 2)
            {
                [self _toLeft:firstImageView];
            } else
            {
                [self _toLeft:secondImageView];
            }
            break;
        default:
            break;
    }
}

- (void)_afterCrossFade
{
    switch (self.type) {
        case FKSlideshowTypeSlideLeft:
            if (0 == loopCount % 2)
            {
                [self _toRight:secondImageView];
            } else
            {
                [self _toRight:firstImageView];
            }
            break;
        case FKSlideshowTypeSlideRight:
            if (0 == loopCount % 2)
            {
                [self _toLeft:secondImageView];
            } else
            {
                [self _toLeft:firstImageView];
            }
            break;
        default:
            break;
    }
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    if (0 < images.count)
    {
        int index = loopCount % images.count;
        activeImage = [images objectAtIndex:index];
        [self _setActiveImage:activeImage];
    }
}

- (void)_setActiveImage:(UIImage *)image
{
    if ( 0 == loopCount % 2 )
    {
        firstImageView.image = activeImage;
        [self _imageViewFrameAdjust:firstImageView];
    } else
    {
        secondImageView.image = activeImage;
        [self _imageViewFrameAdjust:secondImageView];
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

- (void)_effect
{
    switch (self.type) {
        case FKSlideshowTypeSlideLeft:
            [self _effectSlideLeft];
            break;
        case FKSlideshowTypeSlideRight:
            [self _effectSlightRight];
            break;
        default:
            break;
    }
}

- (void)_effectSlideLeft
{
    NSLog(@"%s", __FUNCTION__);
    
    [UIView animateWithDuration:self.duration animations:^{
        if (0 == loopCount % 2)
        {
            [self _toLeft:firstImageView];
        } else
        {
            [self _toLeft:secondImageView];
        }
    }];
}

- (void)_effectSlightRight
{
    NSLog(@"%s", __FUNCTION__);
    
    [UIView animateWithDuration:self.duration animations:^{
        if (0 == loopCount % 2)
        {
            [self _toRight:firstImageView];
        } else
        {
            [self _toRight:secondImageView];
        }
    }];
}

- (void)_imageViewFrameAdjust:(UIImageView *)imageView
{
    if (nil == imageView.image || !layouted)
    {
        return;
    }
    
    CGFloat width, height, aspect;
    CGRect frame = imageView.frame;
    if ( imageView.image.size.width > imageView.image.size.height )
    {
        height = self.frame.size.height;
        aspect = height / imageView.image.size.height;
        width  = imageView.image.size.width * aspect;
    } else
    {
        width = self.frame.size.width;
        aspect = width / imageView.image.size.width;
        height = imageView.image.size.height * aspect;
    }
    frame.size.width = width;
    frame.size.height = height;
    frame.origin.y = -(height - self.frame.size.height) / 2.0;
    imageView.frame = frame;
}

- (void)_toLeft:(UIImageView *)imageView
{
    CGRect frame = imageView.frame;
    CGFloat x = self.frame.size.width - imageView.frame.size.width;
    frame.origin.x = x;
    imageView.frame = frame;
}

- (void)_toRight:(UIImageView *)imageView
{
    CGRect frame = imageView.frame;
    frame.origin.x = 0.0;
    imageView.frame = frame;
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
