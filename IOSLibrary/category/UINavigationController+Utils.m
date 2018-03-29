//
//  UINavigationController+Utils.m
//  SeaBasic
//
//  Created by 罗海雄 on 15/11/12.
//

#import "UINavigationController+Utils.h"
#import <objc/runtime.h>
#import "UIColor+Utils.h"
#import "UIView+Utils.h"
#import "SeaBasic.h"

///导航栏透明视图
@interface SeaNavigationBarAlphaOverlayView : UIView

///阴影
@property(nonatomic,readonly) UIView *shadowView;

@end

@implementation SeaNavigationBarAlphaOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _shadowView = [[UIView alloc] init];
        _shadowView.translatesAutoresizingMaskIntoConstraints = NO;
        _shadowView.backgroundColor = [UIColor sea_colorFromHex:@"C7C6CB"];
        [self addSubview:_shadowView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_shadowView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_shadowView]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_shadowView(0.5)]-0-|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

@end

///透明视图key
static char SeaAlphaOverlayKey;

@implementation UINavigationController (Utils)

#pragma mark- transparent

///导航栏透明功能的视图
- (SeaNavigationBarAlphaOverlayView*)sea_alphaOverlay
{
    SeaNavigationBarAlphaOverlayView *overlay = objc_getAssociatedObject(self, &SeaAlphaOverlayKey);
    if(!overlay)
    {
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        CGRect frame = self.navigationBar.bounds;
        frame.size.height += statusHeight;
        frame.origin.y = - statusHeight;
        overlay = [[SeaNavigationBarAlphaOverlayView alloc] initWithFrame:frame];
        overlay.backgroundColor = self.navigationBar.barTintColor;
        
        
        
        if(@available(iOS 11, *)){
            ///ios 11 overlay会一直被放在最前面
            overlay.top = 0;
            UIView *view = [self.navigationBar.subviews firstObject];
            [view insertSubview:overlay atIndex:0];
        }else{
            [self.navigationBar insertSubview:overlay atIndex:0];
        }
        
        [self setSea_alphaOverlay:overlay];
    }
    
    return overlay;
}

///设置导航栏透明功能的视图
- (void)setSea_alphaOverlay:(SeaNavigationBarAlphaOverlayView*) alphaOverlay
{
    objc_setAssociatedObject(self, &SeaAlphaOverlayKey, alphaOverlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///设置导航栏透明度 范围 0 ~ 1.0
- (void)sea_setNavigationBarAlpha:(CGFloat) alpha
{
    UIView *overlay = [self sea_alphaOverlay];
    
    if(alpha < 0)
        alpha = 0;
    if(alpha >= 1.0)
        alpha = 1.0;
    
    [overlay setAlpha:alpha];
}


///恢复导航栏原有状态
- (void)sea_restoreNavigationBar
{
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.sea_alphaOverlay.hidden = YES;
}

///启动导航栏透明功能
- (void)sea_openNavigationBarAlpha
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = YES;
    [self.navigationBar setShadowImage:[UIImage new]];
    self.sea_alphaOverlay.hidden = NO;
}

@end

