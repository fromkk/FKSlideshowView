//
//  TMSlideshowView.h
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/09.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TMSlideshowStatusPlaying,
    TMSlideshowStatusPause
} TMSlideshowStatus;

#define TMSlideshowDefaultDuration 7.0f
#define TMSlideshowDefaultFade     1.0f

@interface TMSlideshowView : UIView
{
    NSArray *_images;
    UIImage *activeImage;
    UIImageView *firstImageView;
    UIImageView *secondImageView;
    int loopCount;
    NSTimer *timer;
    BOOL initialized;
}

@property (nonatomic) NSArray *images;
@property (nonatomic, assign) TMSlideshowStatus status;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat fade;

- (instancetype)initWithImages:(NSArray *)images;
- (void)play;
- (void)pause;
- (BOOL)playing;

@end
