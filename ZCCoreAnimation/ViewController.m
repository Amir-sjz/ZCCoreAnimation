//
//  ViewController.m
//  ZCCoreAnimation
//
//  Created by 张程 on 16/3/2.
//  Copyright © 2016年 张程. All rights reserved.
//

#import "ViewController.h"
#import "changAnimationView.h"

@interface ViewController ()
{
    BOOL isSelected;
}
@property (nonatomic, strong) changAnimationView *changAView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    isSelected = NO;
    
    CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, 120);
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    _changAView = [[changAnimationView alloc] initWithFrame:button.bounds];
    [button addSubview:_changAView];
    _changAView.userInteractionEnabled = NO;
    
    [button addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:button];
    
}

- (void)startAction
{
    if (isSelected) {
        [_changAView cancel];
    } else {
        [_changAView start];
    }
    
    isSelected = !isSelected;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
