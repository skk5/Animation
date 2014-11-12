//
//  AnimationView.m
//  GoogleAnimation

#import "AnimationView.h"

@interface AnimationView ()

@property(nonatomic, assign) CGFloat circleAngleMin;
@property(nonatomic, assign) CGFloat circleAngleMax;
@property(nonatomic, assign) CGFloat rotateX;
@property(nonatomic, assign) CGFloat rotateY;

@property(nonatomic, assign) RotateDirection currentDirection;

@property(nonatomic, strong) UIColor *fromColor;
@property(nonatomic, strong) UIColor *toColor;

@end

@implementation AnimationView
- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    
    _fromColor = colors[0];
    _toColor = colors[1 % colors.count];
}

//- (void)setCircleAngleMin:(CGFloat)circleAngleMin
//{
//    _circleAngleMin = circleAngleMin;
//    [self setNeedsDisplay];
//}
//
//- (void)setCircleAngleMax:(CGFloat)circleAngleMax
//{
//    _circleAngleMax = circleAngleMax;
//    [self setNeedsDisplay];
//}
//
//- (void)setRotateX:(CGFloat)rotateX
//{
//    _rotateX = rotateX;
//    [self setNeedsDisplay];
//}
//
//- (void)setRotateY:(CGFloat)rotateY
//{
//    _rotateY = rotateY;
//    [self setNeedsDisplay];
//}

- (void)beginAnimate
{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animate)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animate
{
    CGFloat step = 0.05f;
    switch (_currentDirection) {
        case UpToDown:
            _rotateX += step;
            
            if(_rotateX > M_PI) {
                _rotateX = M_PI;
                _currentDirection = (_currentDirection + 1) % 4;
            }
            break;
        case LeftToRight:
            _rotateY -= step;
            
            if(_rotateY < 0) {
                _rotateY = 0;
                _currentDirection = (_currentDirection + 1) % 4;
            }
            break;
        case DownToUp:
            _rotateX -= step;
            
            if(_rotateX < 0) {
                _rotateX = 0;
                _currentDirection = (_currentDirection + 1) % 4;
            }
            break;
        case RightToLeft:
            _rotateY += step;
            
            if(_rotateY > M_PI) {
                _rotateY = M_PI;
                _currentDirection = (_currentDirection + 1) % 4;
            }
            break;
        default:
            break;
    }
    
    _fromColor = _colors[_currentDirection % _colors.count];
    _toColor = _colors [(_currentDirection + 1) % _colors.count];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //清除
    CGContextClearRect(context, self.bounds);
    
    //保存状态
    CGContextSaveGState(context);
    
    //调转坐标系
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, CGRectGetWidth(self.bounds) * 0.5f, CGRectGetHeight(self.bounds) * -0.5f);
    
    size_t count = 100;
    CGPoint *points = malloc(sizeof(CGPoint) * count);
    for(size_t i = 0; i < count; i++) {
        CGFloat x = cosf(_rotateY) * cosf(M_PI * i / (count - 1) - ((_currentDirection == UpToDown || _currentDirection == DownToUp)? 0 : M_PI_2)) * _radius;
        CGFloat y = cosf(_rotateX) * sinf(M_PI * i / (count - 1) - ((_currentDirection == UpToDown || _currentDirection == DownToUp) ? 0 : M_PI_2)) * _radius;
        *(points + i) = CGPointMake(x, y);
    }
    
    
    NSString *tips = nil;
    
    CGMutablePathRef fromPath = CGPathCreateMutable();
    CGMutablePathRef toPath = CGPathCreateMutable();

    switch (_currentDirection) {
        case UpToDown:
        {
            CGPathAddArc(toPath, NULL, 0, 0, _radius, 0, M_PI, NO);
            CGPathAddLines(toPath, NULL, points, count);
            
            CGPathAddLines(fromPath, NULL, points, count);
            CGPathAddArc(fromPath, NULL, 0, 0, _radius, M_PI, 2 * M_PI, NO);
            
            tips = @"UpToDown";
        }
            break;
        case LeftToRight:
        {
            CGPathAddArc(toPath, NULL, 0, 0, _radius, M_PI_2, M_PI + M_PI_2, NO);
            CGPathAddLines(toPath, NULL, points, count);
            
            CGPathAddLines(fromPath, NULL, points, count);
            CGPathAddArc(fromPath, NULL, 0, 0, _radius, M_PI + M_PI_2, M_PI_2, NO);
            
            tips = @"LeftToRight";
        }
            break;
        case DownToUp:
        {
            CGPathAddArc(toPath, NULL, 0, 0, _radius, M_PI, 2 * M_PI, NO);
            CGPathAddLines(toPath, NULL, points, count);
            
            CGPathAddLines(fromPath, NULL, points, count);
            CGPathAddArc(fromPath, NULL, 0, 0, _radius, 0, M_PI, NO);
            
            tips = @"DownToUp";
        }
            break;
        case RightToLeft:
        {
            CGPathAddArc(toPath, NULL, 0, 0, _radius, M_PI_2, M_PI_2 + M_PI, YES);
            CGPathAddLines(toPath, NULL, points, count);
            
            CGPathAddLines(fromPath, NULL, points, count);
            CGPathAddArc(fromPath, NULL, 0, 0, _radius, M_PI_2, M_PI_2 + M_PI, NO);
            
            tips = @"RightToLeft";
        }
            break;
        default:
            break;
    }

    UILabel *label = (UILabel *)[self viewWithTag:0x100];
    if(!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor whiteColor];
        label.tag = 0x100;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    label.text = tips;
    
    
    CGContextSetFillColorWithColor(context, _fromColor.CGColor);
    CGContextAddPath(context, fromPath);
    CGContextEOFillPath(context);
    CFRelease(fromPath);
    
    CGContextSetFillColorWithColor(context, _toColor.CGColor);
    CGContextAddPath(context, toPath);
    CGContextEOFillPath(context);
    CFRelease(toPath);
    
    
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    CGPathAddLines(shadowPath, NULL, points, count);
    CGPathCloseSubpath(shadowPath);
    
    CGContextSetFillColorWithColor(context, [[UIColor grayColor] colorWithAlphaComponent:(sinf(_rotateX) + sinf(_rotateY)) * 0.3].CGColor);
    CGContextAddPath(context, shadowPath);
    CGContextFillPath(context);
    
    CFRelease(shadowPath);
    
    free(points);
    
    CGContextRestoreGState(context);
}

@end
