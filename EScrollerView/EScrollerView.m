//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "AsyncImageView.h"

@implementation EScrollerView
@synthesize delegate;

- (void)dealloc {
	[scrollView release];
    [noteTitle release];
	delegate=nil;
    if (pageControl) {
        [pageControl release];
    }
    if (imageArray) {
        [imageArray release];
        imageArray=nil;
    }
    if (titleArray) {
        [titleArray release];
        titleArray=nil;
    }
    [super dealloc];
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    return [self initWithFrameRect:rect ImageArray:imgArr TitleArray:titArr TitleHieght:0];
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr TitleHieght:(int)height
{
    if (imgArr.count==0||titArr.count==0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"noimage"];
        return [super initWithFrame:rect];
    }
    
	if ((self=[super initWithFrame:rect])) {
        self.userInteractionEnabled=YES;
        titleArray=[titArr retain];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		imageArray=[[NSArray arrayWithArray:tempArray] retain];
		viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        for (int i=0; i<pageCount; i++) {
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[[UIImageView alloc] init] autorelease];
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            if ([imgURL hasPrefix:@"http://"]) {
                //网络图片 请使用ego异步图片库
                [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"noimage"]];
            }
            else
            {
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [Tool cutImageWithImage:img BySize:CGSizeMake(viewSize.size.width, viewSize.size.height) andKB:200];
                [imgView setImage:img];
            }
            
            [imgView setContentMode:UIViewContentModeScaleToFill];
            
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] autorelease];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];
        
        //说明文字层
        float myHeight = height?height:34;
        
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-myHeight,self.bounds.size.width,myHeight)];
        noteView.userInteractionEnabled = NO;
        [noteView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=myHeight;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),0, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        [noteView addSubview:pageControl];
        
        noteTitle.userInteractionEnabled = NO;
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-pageControlWidth-15, myHeight)];
        [noteTitle setText:[titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        [noteTitle setTextColor:[UIColor whiteColor]];
        [noteView addSubview:noteTitle];
        
        [self addSubview:noteView];
        [noteView release];
	}
    [NSTimer scheduledTimerWithTimeInterval:SLIDETIME target:self selector:@selector(autoShowNextPage) userInfo:nil repeats:YES];
	return self;
}


/// 自动切换到下一个页面
- (void) autoShowNextPage{
    if (pageControl.currentPage + 1 < [titleArray count]) {
        currentPageIndex = pageControl.currentPage + 1;
        [self changeCurrentPage];
    }else{
        currentPageIndex = 0;
        [self changeCurrentPage];
    }
}

/// 用户点击page改变相应的页面
- (void) changeCurrentPage{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * (currentPageIndex+1), scrollView.frame.origin.y) animated:YES];
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    pageControl.currentPage=(page-1);
    int titleIndex=page-1;
    if (titleIndex==[titleArray count]) {
        titleIndex=0;
    }
    if (titleIndex<0) {
        titleIndex=[titleArray count]-1;
    }
    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex==0) {
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1)) {
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }

}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

@end
