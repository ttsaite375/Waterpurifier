//
//  MHWaterWaveView.m
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterWaveView.h"

#define kUnitCount 200

@implementation MHWaterWaveView
{
    CADisplayLink* _displayLink;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGContextBeginPath(ctx);
    CGPathMoveToPoint(path, NULL, 0, self.amplitude);
    CGFloat unitx = CGRectGetWidth([UIScreen mainScreen].bounds) / kUnitCount;
    for (NSUInteger i=0; i<kUnitCount; i++) {
        CGFloat delta = sin(M_PI / self.frequency * i + self.phase) * self.amplitude;
        CGPathAddLineToPoint(path, NULL, i * unitx, self.amplitude - delta);
    }
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), self.amplitude);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, 0, CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextFillPath(ctx);
    
    CGPathRelease(path);
    
    CGContextRestoreGState(ctx);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    NSLog(@"%s", __FUNCTION__);
    [self setNeedsDisplay];
}

- (void)displayHandler
{
    self.phase += M_PI / 200.0 * self.velocity;
    [self setNeedsDisplay];
}

- (void)startWaveAnimation
{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayHandler)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopWaveAnimation
{
    [_displayLink invalidate];
    _displayLink = nil;
}

@end
