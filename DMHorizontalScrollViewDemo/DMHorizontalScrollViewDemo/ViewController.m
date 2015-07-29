//
//  ViewController.m
//  DMHorizontalScrollViewDemo
//
//  Created by Dream on 15/6/19.
//  Copyright (c) 2015年 GoSing. All rights reserved.
//

#import "ViewController.h"
#import "DMHorizontalScrollView.h"

@interface ViewController () <DMHorizontalScrollViewDataSource, DMHorizontalScrollViewDelegate>

@property (weak, nonatomic) IBOutlet DMHorizontalScrollView *m_horView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DMHorizontalScrollView *view = [[DMHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 300, [[UIScreen mainScreen] bounds].size.width, 40)];
    [self.view addSubview:view];
    view.delegate = self;
    view.dataSource = self;
    view.backgroundColor = [UIColor cyanColor];
}

#pragma mark - DMHorizontalScrollViewDataSource
/**
 *  总数
 *
 *  @param view
 *
 *  @return 总数
 */
- (NSInteger)numberOfView:(DMHorizontalScrollView *)view
{
    return 10;
}

/**
 *  每个view的宽度
 *
 *  @param view  view
 *  @param index 序号
 *
 *  @return view的宽度
 */
- (CGFloat)horizontalScrollView:(DMHorizontalScrollView *)view viewWidthAtIndex:(NSInteger)index
{
    return 60;
}


/**
 *  显示的子view
 *
 *  @param view  view
 *  @param index 序号
 *  @param size  view大小
 *
 *  @return 子view
 */
- (UIView *)horizontalScrollView:(DMHorizontalScrollView *)view contentViewAtIndex:(NSInteger)index viewSize:(CGSize)size
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = (CGRect){0, 0, size};
    label.text = [@(index) description];
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat r = arc4random() % 100 / 100.0;
    CGFloat g = arc4random() % 100 / 100.0;
    CGFloat b = arc4random() % 100 / 100.0;
    label.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    
    return label;
}

/**
 *  每一项空隙宽度
 *
 *  @return 空隙宽度
 */
- (CGFloat)spaceWidth:(DMHorizontalScrollView *)view
{
    return 4;
}

#pragma mark - DMHorizontalScrollViewDelegate
- (void)horizontalScrollView:(DMHorizontalScrollView *)view didSelectAtIndex:(NSInteger)index
{
    NSLog(@"didSelected:%@", @(index));
}

- (void)horizontalScrollView:(DMHorizontalScrollView *)view didSelectAtView:(UIView *)selectView didSelectAtIndex:(NSInteger)index
{
    NSLog(@"didSelected:%@, didSelectAtView:%@", @(index), view);
}

@end
