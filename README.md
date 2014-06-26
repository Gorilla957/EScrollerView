EScrollerView
=============


一个可以自动滚动的跑马灯（幻灯、图片滚动）

作者博客：http://www.cnblogs.com/bandy/

![image](https://raw.githubusercontent.com/jxd001/EScrollerView/master/Untitled3.gif )
#Step 1

<pre>
#import "EScrollerView.h"
@interface ViewController : UIViewController<EScrollerViewDelegate>

@end
</pre>

#Step 2

<pre>
EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 150)
                                                          ImageArray:[NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil]
                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33", nil]];
scroller.delegate=self;
[self.view addSubview:scroller];
</pre>

#Step 3

<pre>
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
}
</pre>

#Good luck


