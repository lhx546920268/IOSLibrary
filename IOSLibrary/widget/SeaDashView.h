//
//  UBDashView.h

//

#import <UIKit/UIKit.h>

///虚线形状
typedef NS_ENUM(int, SeaDashShape){
    
    ///一条线 default
    SeaDashShapeLine,
    
    ///矩形 可设置圆角
    SeaDashShapeRect,
};

/**
 虚线
 */
@interface SeaDashView : UIView

/**
 是否是垂直，默认NO，水平虚线
 */
@property(nonatomic,assign) BOOL isVertical;

/**
 虚线每段宽度 default is '10.0'
 */
@property(nonatomic,assign) CGFloat dashesLength;

/**
 虚线间隔宽度 default is '5.0'
 */
@property(nonatomic,assign) CGFloat dashesInterval;

/**
 虚线颜色 default is 'grayColor'
 */
@property(nonatomic,strong) UIColor *dashesColor;

/**
 线宽度 default is '1'
 */
@property(nonatomic,assign) CGFloat lineWidth;

/**
 形状
 */
@property(nonatomic,assign) SeaDashShape shape;

/**
 圆角 SeaDashShapeLine 无效
 */
@property(nonatomic,assign) CGFloat cornerRadius;

@end
