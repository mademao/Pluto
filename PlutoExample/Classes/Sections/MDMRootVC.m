//
//  MDMRootVC.m
//  PlutoExample
//
//  Created by 马德茂 on 16/4/25.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "MDMRootVC.h"
#import "Pluto.h"

@interface MDMRootVC ()

@end

@implementation MDMRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.view.backgroundColor = [UIColor redColor];
    
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"png" ofType:@"png"]];
    NSLog(@"%@", @([imageData plt_getImageFormat]));
}

@end
