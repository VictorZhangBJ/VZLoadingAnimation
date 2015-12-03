//
//  HeaderImageView.h
//  广告条
//
//  Created by ThomasHwak on 13-10-16.
//  Copyright (c) 2013年 ThomasHwak. All rights reserved.
//

#import "HeaderImageView.h"
//#import "UIImageView+WebCache.h"

#define TIME_INTERVAL 3
#define ScreenWidth self.bounds.size.width

#define ScrollViewHeight 200

@implementation KIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.target && [self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
}
@end


@implementation HeaderImageView
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger _pageCount;
    ClickBlock _imageClickBlock;
    NSArray *_urlStringArray;
    NSArray *_titleArray;
    BOOL _isURL;
    NSArray *_imageArray;
    NSTimer *_timer;
    UILabel *_titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(changePage) userInfo:nil repeats:YES];

    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(changePage) userInfo:nil repeats:YES];

    }
    return self;
}

-(void)addImageURLArray:(NSArray *)urlStringArray titleArray:(NSArray *)titleArray imageClicked:(ClickBlock)block
{
    if (urlStringArray && urlStringArray.count !=0) {
        _urlStringArray =[NSArray arrayWithArray:urlStringArray];
        _titleArray = [NSArray arrayWithArray:titleArray];
        _imageClickBlock = block;
        _isURL = YES;
        
        [self addImageArray:_urlStringArray titleArray:_titleArray imageClicked:_imageClickBlock isURLArray:_isURL];
    }
}

-(void)addImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray imageClicked:(ClickBlock)block
{
    if (imageArray && imageArray.count !=0) {
        _urlStringArray = imageArray;
        _titleArray = titleArray;
        _imageClickBlock = block;
        _isURL = NO;
    }
}

-(void)addImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray imageClicked:(ClickBlock)block isURLArray:(BOOL) isURL
{
    _imageClickBlock = block;
        _pageCount = [imageArray count];
    NSMutableArray *newImageArray = [[NSMutableArray alloc]initWithArray:imageArray];
    [newImageArray insertObject:[imageArray lastObject] atIndex:0];
    [newImageArray addObject:[imageArray objectAtIndex:0]];
    
    NSInteger imageCount = [newImageArray count];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    _scrollView.contentSize = CGSizeMake(ScreenWidth*imageCount, 0);
    for(int i=0;i<imageCount;i++){
        KIImageView *imageView = [[KIImageView alloc]init];
        if (isURL == YES) {
            //[imageView sd_setImageWithURL:[NSURL URLWithString:[newImageArray objectAtIndex:i]] placeholderImage:nil];

        }else{
            [imageView setImage:[newImageArray objectAtIndex:i]];
        }
        imageView.frame = CGRectMake(0+ScreenWidth*i, 0, ScreenWidth, self.bounds.size.height);
        [_scrollView addSubview:imageView];
        [imageView addTarget:self action:@selector(imageClick:)];
        
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScrollViewHeight-30, ScreenWidth, 30)];
    [self addSubview:backView];
    backView.backgroundColor = [UIColor blackColor];
    [backView setAlpha:0.4];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,ScrollViewHeight-30, 220, 30)];
    _titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Thin" size:16];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = [_titleArray firstObject];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
#if !__has_feature(objc_arc)
    [label release];
#endif

    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth-110, ScrollViewHeight-30, 100, 30)];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    _pageControl.numberOfPages = imageCount-2;
    [self addSubview:_pageControl];
#if !__has_feature(objc_arc)
    [newImageArray release];
#endif

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/ScreenWidth;
    if (currentPage==_pageCount+1) {
        [scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        [_pageControl setCurrentPage:0];
    }else{
        [_pageControl setCurrentPage:currentPage-1];
    }
    //manually scroll the view should invalid the timer
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:TIME_INTERVAL]];
    _titleLabel.text = [_titleArray objectAtIndex:_pageControl.currentPage];

}

-(void)changePage
{
    NSInteger page = _pageControl.currentPage +1;
    [self setPage:page];
    
}

-(void)setPage:(NSInteger)page
{
    [_scrollView setContentOffset:CGPointMake(ScreenWidth*(page+1), 0) animated:YES];
    if (page==_pageCount) {
        _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage++;
    }
    _titleLabel.text = [_titleArray objectAtIndex:_pageControl.currentPage];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_pageControl.currentPage==0) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    }
}

-(void)imageClick:(KIImageView *)imageView
{
    imageView.tag = _pageControl.currentPage;
    _imageClickBlock(imageView.tag);
    
}
@end
