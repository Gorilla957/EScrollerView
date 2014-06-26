//
//  ViewController.m
//  Demo
//
//  Created by Ethan on 13-5-15.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 150)
                                                          ImageArray:[NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil]
                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33", nil]];
    scroller.delegate=self;
    [self.view addSubview:scroller];
    [scroller release];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
