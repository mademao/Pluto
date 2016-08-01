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

    NSMutableArray *a = [NSMutableArray arrayWithCapacity:1];
//    [a addObject:nil];
    
    [PlutoLog pltClearCrashBeforeDay:0];
    
}

@end
