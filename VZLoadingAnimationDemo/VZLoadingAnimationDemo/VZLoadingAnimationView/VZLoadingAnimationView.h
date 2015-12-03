//
//  VZLoadingAnimationView.h
//  VZLoadingAnimationDemo
//
//  Created by victor zhang on 15/12/3.
//  Copyright © 2015年 victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcLayer : CALayer

@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) BOOL clockwise;

@end

@interface VZLoadingAnimationView : UIView

-(void)startAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

-(void)stopAnimation;

@end
