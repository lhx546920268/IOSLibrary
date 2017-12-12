//
//  SeaProgressView.m

//

#import "SeaProgressView.h"
#import "SeaBasic.h"

@interface SeaProgressView ()<CAAnimationDelegate>
//原来的进度
@property(nonatomic,assign) float previousProgress;

//进度条layer
@property(nonatomic,strong) CAShapeLayer *progressLayer;

@end

@implementation SeaProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        _style = SeaProgressViewStyleStraightLine;
        [self initialization];
    }

    return self;
}

/**构造方法
 *@param frame 位置大小
 *@param style 进度条样式
 *@return 一个实例
 */
- (id)initWithFrame:(CGRect)frame style:(SeaProgressViewStyle) style
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _style = style;
        [self initialization];
    }
    
    return self;
}

- (void)initialization
{
    _openProgress = YES;
    _progressColor = [UIColor greenColor];
    _trackColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    switch (_style)
    {
        case SeaProgressViewStyleCircle :
        {
            _progressLineWidth = 10.0;
        }
            break;
        case SeaProgressViewStyleRoundCakesFromEmpty :
        {
            _progressLineWidth = 3.0;
        }
            break;
        default:
            break;
    }

    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];

    self.hideAfterFinish = YES;
    self.hideWidthAnimated = YES;

    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.progressLayer];

    [self setupStyle];

    [(CAShapeLayer*)self.layer setFillColor:[UIColor clearColor].CGColor];

    [self updateProgressLayer];
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupStyle];
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- property setup

- (void)setOpenProgress:(BOOL)openProgress
{
    if(_openProgress != openProgress)
    {
        _openProgress = openProgress;
        self.hidden = !_openProgress;
        if(!_openProgress)
        {
            [self reset];
        }
    }
}

- (void)setProgressColor:(UIColor *)progressColor
{
    if(![_progressColor isEqualToColor:progressColor])
    {
        if(progressColor == nil)
            progressColor = [UIColor greenColor];
        
        _progressColor = progressColor;
        
        [self setupStyle];
        
        [self updateProgressLayer];
    }
}

- (void)setTrackColor:(UIColor *)trackColor
{
    if(![_trackColor isEqualToColor:trackColor])
    {
        if(trackColor == nil)
            trackColor = [UIColor clearColor];

        _trackColor = trackColor;
        
        [self setupStyle];
        [self updateProgressLayer];
    }
}

- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    if(_progressLineWidth != progressLineWidth)
    {
        _progressLineWidth = progressLineWidth;
        [self setupStyle];
        
        [self updateProgressLayer];
    }
}

- (void)setShowPercent:(BOOL)showPercent
{
    if(_showPercent != showPercent)
    {
        _showPercent = showPercent;
        
        if(_style != SeaProgressViewStyleCircle)
            return;
        
        if(_showPercent)
        {
            if(!self.percentLabel)
            {
                _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
                _percentLabel.textColor = [UIColor blackColor];
                _percentLabel.font = [UIFont fontWithName:SeaMainFontName size:20.0];
                _percentLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_percentLabel];
            }
        }
        else if(self.percentLabel)
        {
            [self.percentLabel removeFromSuperview];
            _percentLabel = nil;
        }
    }
}

- (void)setProgress:(float)progress
{
    if(!_openProgress)
        return;
    if(_progress != progress)
    {
        if(self.hidden)
        {
            self.hidden = NO;
            self.alpha = 1.0;
        }
        if(progress > 1.0)
        {
            progress = 1.0;
        }
        else if(progress < 0)
        {
            progress = 0;
        }
        
        self.previousProgress = MAX(0, _progress > 1.0 ? 0 : _progress);
        _progress = progress;
        
        if(self.previousProgress > _progress)
        {
            self.previousProgress = 0;
        }
        
        [self updateProgress];
    }
}

//设置样式
- (void)setupStyle
{
    CAShapeLayer *layer = (CAShapeLayer*)self.layer;
    
    switch (_style)
    {
        case SeaProgressViewStyleCircle :
        {
            self.progressLayer.lineWidth = _progressLineWidth;
            self.progressLayer.strokeColor = self.progressColor.CGColor;
            layer.lineWidth = _progressLineWidth;
            layer.strokeColor = _trackColor.CGColor;
        }
            break;
        case SeaProgressViewStyleStraightLine :
        {
            self.progressLayer.strokeColor = self.progressColor.CGColor;
            self.progressLayer.lineWidth = self.height;
            layer.lineWidth = self.height;
            layer.strokeColor = _trackColor.CGColor;
        }
            break;
        case SeaProgressViewStyleRoundCakesFromEmpty :
        {
            self.progressLayer.fillColor = self.progressColor.CGColor;
            layer.strokeColor = _trackColor.CGColor;
            layer.lineWidth = _progressLineWidth;
        }
            break;
        case SeaProgressViewStyleRoundCakesFromFull :
        {
            self.progressLayer.fillColor = self.progressColor.CGColor;
            layer.strokeColor = _trackColor.CGColor;
            layer.lineWidth = _progressLineWidth;
        }
            break;
    }
}

//更新进度条
- (void)updateProgress
{
    switch (_style)
    {
        case SeaProgressViewStyleStraightLine :
        case SeaProgressViewStyleCircle :
        {
            if(self.percentLabel)
            {
                self.percentLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_progress * 100)];
            }
            
            self.progressLayer.strokeEnd = _progress;
            
            //动画显示进度条
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathAnimation.duration = 0.25;
            pathAnimation.fromValue = @(_previousProgress);
            pathAnimation.toValue = @(_progress);
            pathAnimation.removedOnCompletion = YES;
            
            //进度条圆满隐藏
            if(_progress >= 1.0)
            {
                pathAnimation.delegate = self;
            }
            
            [self.progressLayer addAnimation:pathAnimation forKey:@"progress"];
        }
            break;
        case SeaProgressViewStyleRoundCakesFromEmpty :
        {
            //动画帧数量
            NSInteger frames = ceil(0.25 * 60);
            NSMutableArray *animatedPaths = [NSMutableArray arrayWithCapacity:frames];
            
            //起始弧度 、目标弧度
            CGFloat startAngle = - M_PI_2;
            CGFloat endAngle = - M_PI_2 +  M_PI * 2 * _progress;
            
            //当前最新的弧度
            CGFloat lastAngle = - M_PI_2 +  M_PI * 2 * _previousProgress;
            
            //圆心、半径
            CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
            CGFloat radius = MIN(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
            
            for(NSInteger i = 1;i <= frames;i ++)
            {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:lastAngle + ((endAngle - lastAngle) / frames * i)clockwise:YES];
                [path addLineToPoint:center];
                [path closePath];
                [animatedPaths addObject:(id)path.CGPath];
            }
            
            //添加动画
            self.progressLayer.path = (__bridge CGPathRef)[animatedPaths lastObject];
            
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            animation.values = animatedPaths;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.25;
            animation.removedOnCompletion = YES;
            //进度条圆满隐藏
            if(_progress >= 1.0)
            {
                animation.delegate = self;
            }
            [self.progressLayer addAnimation:animation forKey:@"path"];
        }
            break;
        case SeaProgressViewStyleRoundCakesFromFull :
        {
            //动画帧数量
            NSInteger frames = ceil(0.25 * 60);
            NSMutableArray *animatedPaths = [NSMutableArray arrayWithCapacity:frames];
            
            //起始弧度 、目标弧度
            CGFloat startAngle = - M_PI_2;
            CGFloat endAngle = - M_PI_2 +  M_PI * 2 * (1 - _progress);
            
            //当前最新的弧度
            CGFloat lastAngle = - M_PI_2 +  M_PI * 2 * (1 - _previousProgress);
            
            //圆心、半径
            CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
            CGFloat radius = MIN(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
            
            for(NSInteger i = 1;i <= frames;i ++)
            {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:lastAngle + ((endAngle - lastAngle) / frames * i)clockwise:YES];
                [path addLineToPoint:center];
                [path closePath];
                [animatedPaths addObject:(id)path.CGPath];
            }
            
            //添加动画
            self.progressLayer.path = (__bridge CGPathRef)[animatedPaths lastObject];
            
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            animation.values = animatedPaths;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.25;
            animation.removedOnCompletion = YES;
            //进度条圆满隐藏
            if(_progress >= 1.0)
            {
                animation.delegate = self;
            }
            [self.progressLayer addAnimation:animation forKey:@"path"];
        }
            break;
        default:
            break;
    }
}

//动画结束，隐藏进度条
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.hideAfterFinish)
    {
        if(self.hideWidthAnimated)
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.alpha = 0.0;
            }completion:^(BOOL finsh){
                
                self.hidden = YES;
                [self reset];
            }];
        }
        else
        {
            self.hidden = YES;
            [self reset];
        }
    }
}

#pragma mark- private method

//重新设置
- (void)reset
{
    _previousProgress = 0;
    _progress = 0;
}

//更新进度条样式
- (void)updateProgressLayer
{
    CGRect rct = self.bounds;
    UIBezierPath *path = nil;
    
    switch (_style)
    {
        case SeaProgressViewStyleStraightLine :
        {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, self.height / 2.0)];
            [path addLineToPoint:CGPointMake(self.width, self.height / 2.0)];
        }
            break;
        case SeaProgressViewStyleCircle :
        {
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rct.size.width / 2.0, rct.size.height / 2.0) radius:MIN(rct.size.width / 2.0, rct.size.height / 2.0) - _progressLineWidth / 2.0 startAngle:-M_PI_2 endAngle:3 * M_PI_2  clockwise:YES];
        }
            break;
        case SeaProgressViewStyleRoundCakesFromEmpty :
        case SeaProgressViewStyleRoundCakesFromFull :
        {
            CGPoint point = CGPointMake(rct.size.width / 2.0, rct.size.height / 2.0);
            
            path = [UIBezierPath bezierPath];
            [path addArcWithCenter:point radius:MIN(rct.size.width / 2.0, rct.size.height / 2.0) - _progressLineWidth / 2.0 startAngle:-M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
            
        }
            break;
    }
    
    if(_style != SeaProgressViewStyleRoundCakesFromEmpty && _style != SeaProgressViewStyleRoundCakesFromFull)
    {
        self.progressLayer.path = path.CGPath;
    }
    
    [(CAShapeLayer*)self.layer setPath:path.CGPath];
    [self updateProgress];
}


@end
