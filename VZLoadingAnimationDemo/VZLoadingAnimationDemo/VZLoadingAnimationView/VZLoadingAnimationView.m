//
//  VZLoadingAnimationView.m
//  VZLoadingAnimationDemo
//
//  Created by victor zhang on 15/12/3.
//  Copyright © 2015年 victor. All rights reserved.
//

#import "VZLoadingAnimationView.h"


@implementation ArcLayer

@dynamic progress;

+(BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat radius = CGRectGetWidth(self.bounds);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGFloat currentOrigin = 
    
}

@end



@interface VZLoadingAnimationView()

@property (nonatomic) ArcLayer *arcLayer;

@end

@implementation VZLoadingAnimationView

-(void)startAnimation
{
    
    
}

-(void)startAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    self.arcLayer = [ArcLayer layer];
    [self.layer addSublayer:self.arcLayer];
    CGFloat lineWidth = 5.0;
    self.arcLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2.0 -lineWidth/2.0 , CGRectGetHeight(self.bounds)/2.0 - lineWidth/2.0);
    self.arcLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidX(self.bounds));
    
    //animation
    self.arcLayer.startAngle = startAngle;
    self.arcLayer.endAngle = endAngle;
    self.arcLayer.clockwise = clockwise;
    self.arcLayer.circle_progress = 1.0;  //end state
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 4.0f;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    
    [self.arcLayer addAnimation:animation forKey:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
