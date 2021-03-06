/**
 The MIT License (MIT)
 
 Copyright (c) 2015 DreamCao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "DMHorizontalScrollView.h"

#ifdef DEBUG
#define DMHORDebug(...)  NSLog(__VA_ARGS__)
#else
#define DMHORDebug(...)
#endif

@interface DMHorizontalScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *m_scrollView;

@property (nonatomic, strong) NSMutableArray *m_viewArray;

@property (nonatomic, assign) CGFloat m_topEdge;
@property (nonatomic, assign) CGFloat m_bottomEdge;
@property (nonatomic, assign) CGFloat m_headerEdge;
@property (nonatomic, assign) CGFloat m_tailEdge;
@property (nonatomic, assign) CGFloat m_spaceWidth;

@end



@implementation DMHorizontalScrollView

#pragma mark - Life Cycle
- (void)dealloc
{
    DMHORDebug(@"%@ dealloc", [[self class] description]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (void)defaultSetting
{
    [self createScrollView];
    
    [self reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (![self.subviews containsObject:self.m_scrollView])
    {
        [self addSubview:self.m_scrollView];
    }

    self.m_scrollView.frame = self.bounds;
}

#pragma mark - ScrollView
- (void)createScrollView
{
    if (nil == self.m_scrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.m_scrollView = scrollView;
        
        scrollView.bounces = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
    }
}

- (void)createScrollSubView
{
    NSInteger count = [self.dataSource numberOfView:self];
    CGFloat topEdge = self.m_topEdge;
    CGFloat bottomEdge = self.m_bottomEdge;
    CGFloat headerEdge = self.m_headerEdge;
    CGFloat tailEdge = self.m_tailEdge;
    CGFloat spaceWidth = self.m_spaceWidth;
    CGFloat frameH = self.bounds.size.height;
    CGFloat x = headerEdge;
    CGFloat y = topEdge;
    CGFloat h = frameH - topEdge - bottomEdge;
    
    for (UIView *view in self.m_viewArray)
    {
        [view removeFromSuperview];
    }
    
    [self.m_viewArray removeAllObjects];
    
    for (UIView *view in self.m_scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    for (NSInteger i=0; i<count; i++)
    {
        CGFloat viewWidth = [self.dataSource horizontalScrollView:self viewWidthAtIndex:i];
        
        UIButton *cell = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.frame = CGRectMake(x, y, viewWidth, h);
        cell.backgroundColor = [UIColor clearColor];

        UIView *contentView = [self.dataSource horizontalScrollView:self contentViewAtIndex:i viewSize:CGSizeMake(viewWidth, h)];
        [cell addSubview:contentView];
        [self.m_viewArray addObject:contentView];
        
        [cell addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.tag = i;
        
        [self.m_scrollView addSubview:cell];
        
        x += viewWidth;
        if ((i+1) < count)
        { //不是最后一个，则加 spaceWidth
            x += spaceWidth;
        }
    }
    
    self.m_scrollView.contentSize = CGSizeMake(x+tailEdge, frameH);
}


/**
 *  加载数据
 */
- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createScrollSubView];
    });
}


/**
 *  设置显示的起始位置
 *
 *  @param position    位置
 *  @param isAnimation 是否动画
 */
- (void)setScrollPosition:(CGPoint)position isAnimation:(BOOL)isAnimation
{
    [self.m_scrollView setContentOffset:position animated:isAnimation];
}


#pragma mark - Event
- (void)cellClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(horizontalScrollView:didSelectAtIndex:)])
    {
        [self.delegate horizontalScrollView:self didSelectAtIndex:btn.tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(horizontalScrollView:didSelectAtView:didSelectAtIndex:)])
    {
        UIView *view = self.m_viewArray[btn.tag];
        [self.delegate horizontalScrollView:self didSelectAtView:view didSelectAtIndex:btn.tag];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

#pragma mark - setter / getter
- (CGFloat)m_topEdge
{
    if ([self.dataSource respondsToSelector:@selector(horizontalScrollViewTopEdge:)])
    {
        _m_topEdge = [self.dataSource horizontalScrollViewTopEdge:self];
    }
    
    return _m_topEdge;
}

- (CGFloat)m_bottomEdge
{
    if ([self.dataSource respondsToSelector:@selector(horizontalScrollViewBottomEdge:)])
    {
        _m_bottomEdge = [self.dataSource horizontalScrollViewBottomEdge:self];
    }
    
    return _m_bottomEdge;
}

- (CGFloat)m_headerEdge
{
    if ([self.dataSource respondsToSelector:@selector(horizontalScrollViewHeaderEdge:)])
    {
        _m_headerEdge = [self.dataSource horizontalScrollViewHeaderEdge:self];
    }
    
    return _m_headerEdge;
}

- (CGFloat)m_tailEdge
{
    if ([self.dataSource respondsToSelector:@selector(horizontalScrollViewTailEdge:)])
    {
        _m_tailEdge = [self.dataSource horizontalScrollViewTailEdge:self];
    }
    
    return _m_tailEdge;
}

- (CGFloat)m_spaceWidth
{
    if ([self.dataSource respondsToSelector:@selector(spaceWidth:)])
    {
        _m_spaceWidth = [self.dataSource spaceWidth:self];
    }
    
    return _m_spaceWidth;
}

- (NSMutableArray *)m_viewArray
{
    if (nil == _m_viewArray)
    {
        _m_viewArray = [NSMutableArray array];
    }
    
    return _m_viewArray;
}

@end
