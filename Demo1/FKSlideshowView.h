//
//  FKSlideshowView.h
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/09.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    FKSlideshowStatusPlaying,
    FKSlideshowStatusPause
} FKSlideshowStatus;

#define FKSlideshowDefaultDuration 0.2f
#define FKSlideshowDefaultFade     0.0f

@interface FKSlideshowView : UIView
{
    UIImage *activeImage;
    UIImageView *firstImageView;
    UIImageView *secondImageView;
    int loopCount;
    NSTimer *timer;
    BOOL initialized;
}

@property (nonatomic) NSArray *images;
@property (nonatomic, assign) FKSlideshowStatus status;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat fade;

- (instancetype)initWithImages:(NSArray *)images;
- (void)play;
- (void)pause;
- (BOOL)playing;

@end
