//
//  ViewController.m
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/09.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *images = [NSMutableArray array];
    NSString *filename;
    for (int i = 186; i <= 191; i++)
    {
        filename = [NSString stringWithFormat:@"IMG_%04d.jpg", i];
        [images addObject:[UIImage imageNamed:filename]];
        filename = nil;
    }
    
    self.slideshowView = [[FKSlideshowView alloc] initWithImages:images];
    [self.view addSubview:self.slideshowView];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btn addTarget:self action:@selector(tappedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setTitle:@"Pause" forState:UIControlStateNormal];
    [self.view addSubview:self.btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.slideshowView.frame = CGRectMake(20.0, 80.0, self.view.frame.size.width - 40.0, self.view.frame.size.width - 40.0);
    self.btn.frame = CGRectMake((self.view.frame.size.width - 160.0) / 2.0, CGRectGetMaxY(self.slideshowView.frame) + 20.0f, 160.0, 44.0);
}

- (void)tappedBtn:(UIButton *)sender
{
    if (self.slideshowView.playing)
    {
        [self.slideshowView pause];
        [self.btn setTitle:@"Play" forState:UIControlStateNormal];
    } else
    {
        [self.slideshowView play];
        [self.btn setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
