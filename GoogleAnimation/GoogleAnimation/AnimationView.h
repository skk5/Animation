//
//  AnimationView.h
//  GoogleAnimation

#import <UIKit/UIKit.h>

typedef NS_ENUM(UInt8, RotateDirection)
{
    UpToDown = 0x00,
    RightToLeft,
    DownToUp,
    LeftToRight
};

@interface AnimationView : UIView

@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, strong) NSArray *colors;

- (void)beginAnimate;

@end
