#import <UIKit/UIKit.h>

@class DMHorizontalScrollView;

#pragma mark - DMHorizontalScrollViewDataSource
/**
 *  数据源代理
 */
@protocol DMHorizontalScrollViewDataSource <NSObject>

@required
/**
 *  总数
 *
 *  @param view
 *
 *  @return 总数
 */
- (NSInteger)numberOfView:(DMHorizontalScrollView *)view;

/**
 *  每个view的宽度
 *
 *  @param view  view
 *  @param index 序号
 *
 *  @return view的宽度
 */
- (CGFloat)horizontalScrollView:(DMHorizontalScrollView *)view viewWidthAtIndex:(NSInteger)index;


/**
 *  显示的子view
 *
 *  @param view  view
 *  @param index 序号
 *  @param size  view大小
 *
 *  @return 子view
 */
- (UIView *)horizontalScrollView:(DMHorizontalScrollView *)view contentViewAtIndex:(NSInteger)index viewSize:(CGSize)size;


@optional
/**
 *  顶部保留高度
 *
 *  @return 高度
 */
- (CGFloat)horizontalScrollViewTopEdge:(DMHorizontalScrollView *)view;

/**
 *  底部保留的高度
 *
 *  @return 高度
 */
- (CGFloat)horizontalScrollViewBottomEdge:(DMHorizontalScrollView *)view;

/**
 *  头部保留的宽度
 *
 *  @return 宽度
 */
- (CGFloat)horizontalScrollViewHeaderEdge:(DMHorizontalScrollView *)view;

/**
 *  尾部保留的宽度
 *
 *  @return 宽度
 */
- (CGFloat)horizontalScrollViewTailEdge:(DMHorizontalScrollView *)view;

/**
 *  每一项空隙宽度
 *
 *  @return 空隙宽度
 */
- (CGFloat)spaceWidth:(DMHorizontalScrollView *)view;

@end


#pragma mark - DMHorizontalScrollViewDelegate
@protocol DMHorizontalScrollViewDelegate <NSObject>

@optional
/**
 *  点击
 *
 *  @param view  view
 *  @param index 序号
 */
- (void)horizontalScrollView:(DMHorizontalScrollView *)view didSelectAtIndex:(NSInteger)index;

@end




#pragma mark - DMHorizontalScrollView
/**
 *  水平滑动view
 */
IB_DESIGNABLE
@interface DMHorizontalScrollView : UIView

/**
 *  数据源代理
 */
@property (nonatomic, weak) IBOutlet id<DMHorizontalScrollViewDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic, weak) IBOutlet id<DMHorizontalScrollViewDelegate> delegate;


/**
 *  加载数据
 */
- (void)reloadData;

@end
