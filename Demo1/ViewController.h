//
//  ViewController.h
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/09.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMSlideshowView.h"

@interface ViewController : UIViewController

@property (nonatomic) TMSlideshowView *slideshowView;
@property (nonatomic) UIButton *btn;

- (void)tappedBtn:(UIButton *)sender;

@end

