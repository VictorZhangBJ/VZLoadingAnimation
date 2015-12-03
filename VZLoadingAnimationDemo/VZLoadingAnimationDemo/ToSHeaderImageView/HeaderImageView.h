//
//  HeaderImageView.h
//  广告条
//
//  Created by ThomasHwak on 13-10-16.
//  Copyright (c) 2013年 ThomasHwak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIImageView : UIImageView

-(void)addTarget:(id)target action:(SEL)action;

@property (nonatomic,assign)id target;
@property (nonatomic,assign)SEL action;

@end

typedef void(^ClickBlock)(NSInteger index);

@interface HeaderImageView : UIView<UIScrollViewDelegate>

-(void)addImageURLArray:(NSArray *)urlStringArray
             titleArray:(NSArray *)titleArray
           imageClicked:(ClickBlock)block;

-(void)addImageArray:(NSArray *)imageArray
          titleArray:(NSArray *)titleArray
        imageClicked:(ClickBlock) block;

@end
