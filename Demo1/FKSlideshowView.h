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

typedef enum
{
    FKSlideshowTypeCrossfade = 0,
    FKSlideshowTypeSlideLeft,
    FKSlideshowTypeSlideRight,
    FKSlideshowTypeZoomIn,
    FKSlideshowTypeZoomOut,
    FKSlideshowTypeCount
} FKSlideshowType;

#define FKSlideshowDefaultDuration 3.0f
#define FKSlideshowDefaultFade     1.0f
#define FKSlideshowDefaultType     FKSlideshowTypeCrossfade
#define FKSlideshowDefaultZoom     1.5f
#define FKSlideshowDefaultRandom   NO

@interface FKSlideshowView : UIView
{
    UIImage *activeImage;
    UIImageView *firstImageView;
    UIImageView *secondImageView;
    int loopCount;
    NSTimer *timer;
    BOOL initialized;
    BOOL layouted;
}

@property (nonatomic) NSArray *images;
@property (nonatomic, assign) FKSlideshowStatus status;
@property (nonatomic, assign) FKSlideshowType type;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat fade;
@property (nonatomic, assign) CGFloat zoom;
@property (nonatomic, assign) BOOL random;

/**
 * initialize with images
 *
 * @param NSArray<UIImage> images 画像一覧
 * @return FKSlideshowView
 */
- (instancetype)initWithImages:(NSArray *)images;
- (void)play;
- (void)pause;
- (BOOL)playing;

@end
