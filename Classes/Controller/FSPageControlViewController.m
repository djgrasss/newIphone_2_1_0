 //
//  FSPageControlViewController.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-10-27.
//
//

#import "FSPageControlViewController.h"
#import "FSDeepPictureVeiwController.h"
#import "FSDeepBaseViewController.h"
#import "FSSinaBlogShareViewController.h"
#import "FSNetEaseBlogShareViewController.h"
#import "FSPeopleBlogShareViewController.h"
#import <MessageUI/MessageUI.h>
#import "NTESNBSMSManager.h"
#import "LygTencentShareViewController.h"
#define FSPAGECONTROL_VIEW_HEIGHT 24.0f

#define BUFFER_MAX_CONTROLLER_COUNT 3

#define BUFFER_FOCUS_OFFSET 2

typedef enum PageControllerSlide {
    PageControllerSlide_FromLeftToRight,
    PageControllerSlide_FromRightToLeft
} PageControllerSlide;

@interface FSPageControlViewController ()
- (void)removeAllController;
- (void)showPageControllerWithPageNum:(NSInteger)pageNum;
@end

@implementation FSPageControlViewController
@synthesize pageCount = _pageCount;
@synthesize pageNumber = _pageNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pageCount = 0;
        _pageNumber = -1;
        _isPopoNext = NO;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _pageCount = 0;
        _pageNumber = -1;
        _isParentController = NO;
    }
    return self;
}

- (void)dealloc {
    [_indexPaths removeAllObjects];
    [_svContainer release];
    [self removeAllController];
    [_buffers removeAllObjects];
    [_buffers release];
    [_refreshButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HiddenNavigationItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isPopoNext" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deep_returnCurrentPage" object:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)indexPathWithPageNum:(NSInteger)pageNum {
    if (_indexPaths == nil) {
        _indexPaths = [[NSMutableDictionary alloc] init];
    }
    NSNumber *pageKey = [[NSNumber alloc] initWithInt:pageNum];
    NSIndexPath *result = [_indexPaths objectForKey:pageKey];
    if (result == nil) {
        result = [NSIndexPath indexPathForRow:pageNum inSection:0];
        [_indexPaths setObject:result forKey:pageKey];
    }
    [pageKey release];
    
    return result;
}
#pragma mark -
#pragma mark FSBaseContainerViewDelegate

-(void)fsBaseContainerViewTouchEvent:(FSBaseContainerView *)sender{
//    if ([sender isEqual:self.view]) {
//        switch (_fsNewsContainerView.touchEvenKind) {
//            case TouchEvenKind_FaverateSelect:
//                [self fav];
//                break;
//            case TouchEvenKind_ShareSelect:
//                _fsNewsContainerView.userInteractionEnabled = NO;
//                [self share];
//                break;
//            case TouchEvenKind_Commentsend:
//                [self commentUpdata:_fsNewsContainerView.comment_content];
//                break;
//            case TouchEvenKind_ScrollUp:
//                [self swipeUpAction];
//                break;
//            case TouchEvenKind_ScrollDown:
//                [self swipeDownAction];
//                break;
//            case TouchEvenKind_PopCommentList:
//                [self swipeDownAction];
//                [self showCommentList];
//                break;
//            default:
//                break;
//        }
//        ;
//    }
    
    if ([sender isEqual:_fsShareIconContainView]) {
        switch (_fsShareIconContainView.shareSelectEvent) {
            case ShareSelectEvent_return:
                break;
            case ShareSelectEvent_sina:
                NSLog(@"分享到新浪微博");
            {
                FSSinaBlogShareViewController *fsSinaBlogShareViewController = [[FSSinaBlogShareViewController alloc] init];
                
                fsSinaBlogShareViewController.withnavTopBar                  = YES;
                fsSinaBlogShareViewController.title                          = @"新浪微博分享";
                fsSinaBlogShareViewController.shareContent = [self shareContent];
                [self presentViewController:fsSinaBlogShareViewController animated:YES completion:nil];
                [fsSinaBlogShareViewController release];
            }
                
                break;
            case ShareSelectEvent_netease:
                NSLog(@"分享到网易微博");
                FSNetEaseBlogShareViewController *fsNetEaseBlogShareViewController = [[FSNetEaseBlogShareViewController alloc] init];
                fsNetEaseBlogShareViewController.withnavTopBar                     = YES;
                fsNetEaseBlogShareViewController.shareContent                      = [self shareContent];
                [self presentViewController:fsNetEaseBlogShareViewController animated:YES completion:nil];
                [fsNetEaseBlogShareViewController release];
                //}
                
                break;
            case ShareSelectEvent_weixin:
              //  [self sendShareWeiXin:0];
                break;
            case ShareSelectEvent_friend:
            {
                //[self sendShareWeiXin:1];
            }
                
                break;
            case ShareSelectEvent_peopleBlog:
                NSLog(@"分享到人民微博");
                FSPeopleBlogShareViewController *fsPeopleBlogShareViewController = [[FSPeopleBlogShareViewController alloc] init];
                fsPeopleBlogShareViewController.withnavTopBar                    = YES;
                fsPeopleBlogShareViewController.shareContent = [self shareContent];
                //[self.navigationController pushViewController:fsPeopleBlogShareViewController animated:YES];
                [self presentViewController:fsPeopleBlogShareViewController animated:YES completion:nil];
                //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
                [fsPeopleBlogShareViewController release];
                //}
                
                break;
            case ShareSelectEvent_mail:
                NSLog(@"邮件分享");
//                if ([MFMailComposeViewController canSendMail]) {
//                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//                    picker.mailComposeDelegate = self;
//                    [picker setSubject:_fs_GZF_NewsContainerDAO.cobj.title];
//                    
//                    NSArray *toRecipients = [NSArray arrayWithObject:@"[email][/email]"];
//                    [picker setToRecipients:toRecipients];
//                    NSString *emailBody = [self shareContent];
//                    [picker setMessageBody:emailBody isHTML:NO];
//                    [self presentModalViewController:picker animated:YES];
//                    [picker release];
//                }
//                else{
//                    FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
//                    informationMessageView.parentDelegate = self;
//                    [informationMessageView showInformationMessageViewInView:self.view
//                                                                 withMessage:@"请先设置您的邮箱再分享，谢谢！"
//                                                            withDelaySeconds:2.0f
//                                                            withPositionKind:PositionKind_Vertical_Horizontal_Center
//                                                                  withOffset:0.0f];
//                    
//                    [self performSelector:@selector(shearWithMail) withObject:nil afterDelay:1.5];
//                }
                
                break;
            case ShareSelectEvent_message:
                NSLog(@"短信分享");
                [NTESNBSMSManager sharedSMSManager].smsBody = [self shareContent];
                [NTESNBSMSManager sharedSMSManager].pushNavigation = self.navigationController;
                [[NTESNBSMSManager sharedSMSManager] pushSMSComposer];
                break;
            case ShareSelectEvent_tencent:
            {
                LygTencentShareViewController *fsSinaBlogShareViewController = [[LygTencentShareViewController alloc] init];
                fsSinaBlogShareViewController.withnavTopBar                  = YES;
                fsSinaBlogShareViewController.title                          = @"腾讯微博分享";
                fsSinaBlogShareViewController.shareContent                   = [self shareContent];
                [self presentViewController:fsSinaBlogShareViewController animated:YES completion:nil];
                [fsSinaBlogShareViewController release];
            }
                break;
            default:
                break;
        }
        NSLog(@"。。。。。。。。。");
        //_fsNewsContainerView.userInteractionEnabled = YES;
        _fsShareIconContainView.isShow = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6];
        _fsShareIconContainView.frame = CGRectMake(0, self.view.frame.size.height+44, self.view.frame.size.width, [_fsShareIconContainView getHeight]);
        [UIView commitAnimations];
        
    }
}

-(NSString *)shareContent{
    NSString *newsContent;
    NSString *resultStr;
    
    
//    if (self.newsSourceKind == NewsSourceKind_ShiKeNews && _FCObj==nil) {
//        
//        if (self.obj!=nil) {
//            if ([self.obj.news_abstract length]>90) {
//                
//                newsContent = [self.obj.news_abstract substringToIndex:90];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@"　　" withString:@""];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//                newsContent = [NSString stringWithFormat:@"【%@】%@",_fs_GZF_NewsContainerDAO.cobj.title,newsContent];
//            }
//            else{
//                newsContent = [NSString stringWithFormat:@"【%@】%@",_fs_GZF_NewsContainerDAO.cobj.title,self.obj.news_abstract];
//            }
//        }
//        
//        if (self.FavObj!=nil) {
//            if ([self.FavObj.news_abstract length]>90) {
//                newsContent = [self.FavObj.news_abstract substringToIndex:90];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@"　　" withString:@""];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                newsContent = [newsContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//                newsContent = [NSString stringWithFormat:@"【%@】%@",_fs_GZF_NewsContainerDAO.cobj.title,newsContent];
//            }
//            else{
//                newsContent = [NSString stringWithFormat:@"【%@】%@",_fs_GZF_NewsContainerDAO.cobj.title,self.FavObj.news_abstract];
//            }
//        }
//    }
//    else{
//        if ([_fs_GZF_NewsContainerDAO.cobj.content length]>90) {
//            
//            newsContent = [_fs_GZF_NewsContainerDAO.cobj.content substringToIndex:90];
//            NSLog(@"newsContent:%@",newsContent);
//            newsContent = [newsContent stringByReplacingOccurrencesOfString:@"　　" withString:@""];
//            newsContent = [newsContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//            newsContent = [newsContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            newsContent = [newsContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            newsContent = [NSString stringWithFormat:@"【%@】%@",_fs_GZF_NewsContainerDAO.cobj.title,newsContent];
//        }
//        else{
//            newsContent = [NSString stringWithFormat:@"【%@】%@",_fs_GZF_NewsContainerDAO.cobj.title,_fs_GZF_NewsContainerDAO.cobj.content];
//        }
//    }
//    
//    
//    if ([_fs_GZF_NewsContainerDAO.cobj.shortUrl length]>0) {
//        resultStr = [NSString stringWithFormat:@"%@-->详见：%@",newsContent,_fs_GZF_NewsContainerDAO.cobj.shortUrl];
//    }
//    else{
//        resultStr = [NSString stringWithFormat:@"%@",newsContent];
//    }
    
    return resultStr;
}

-(void)onButtonClick:(int)index
{
    if (index == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (CGFloat)pageControlHeight {
    return FSPAGECONTROL_VIEW_HEIGHT;
}

- (void)loadChildView {
    
    
//    UIButton *returnBT = [[UIButton alloc] init];
//    [returnBT setBackgroundImage:[UIImage imageNamed:@"returnbackBT.png"] forState:UIControlStateNormal];
//    //[returnBT setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
//    returnBT.titleLabel.font = [UIFont systemFontOfSize:12];
//    [returnBT addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
//    [returnBT setTitleColor:COLOR_NEWSLIST_TITLE_WHITE forState:UIControlStateNormal];
//    returnBT.frame = CGRectMake(0, 0, 55, 30);
//    
//    //self.navigationItem.leftBarButtonItem
//    
//    
//    UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithCustomView:returnBT];
//    self.navigationItem.leftBarButtonItem = returnButton;
//    [returnButton release];
//    [returnBT release];
    
    _pageControlView = [[FSDeepPageControllView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - FSPAGECONTROL_VIEW_HEIGHT, self.view.frame.size.width, FSPAGECONTROL_VIEW_HEIGHT)];
    _pageControlView.delegate = self;
    //_pageControlView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_pageControlView];
    [_pageControlView release];
    
    _pageNumber = -1;
    
    _svContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _svContainer.delegate = self;
    _svContainer.pagingEnabled = YES;
    [_svContainer setShowsHorizontalScrollIndicator:NO];
    [_svContainer setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_svContainer];
        
    [self.view bringSubviewToFront:_pageControlView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(HiddenNavigationItem:)
												 name:@"HiddenNavigationItem" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(isPopoNext:)
												 name:@"isPopoNext" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deep_returnCurrentPage:)
												 name:@"deep_returnCurrentPage" object:nil];
    
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshCurrentPage:)];
    _refreshButton.tintColor = [UIColor blackColor];
}

-(void)returnBack:(id)sender{
    
    _pageControlView.alpha = 1.0f;
    if (_isPopoNext == YES) {
        _isPopoNext = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deep_returnCurrentPage" object:self userInfo:nil];
        //发送消息？？？？？？deep_returnCurrentPage
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCurrentPage" object:self userInfo:nil];
}

- (void)HiddenNavigationItem:(NSNotification*)aNotification {
    
	self.navigationItem.rightBarButtonItem = _refreshButton;
    _pageControlView.alpha = 0.0f;
    
}

-(void)isPopoNext:(NSNotification*)aNotification{
    
    _isPopoNext = YES;
    _isParentController = YES;
    _pageControlView.alpha = 0.0f;
}

-(void)refreshCurrentPage:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deep_refreshCurrentPage" object:self userInfo:nil];
}

-(void)deep_returnCurrentPage:(NSNotification *)sender{
    NSLog(@"deep_returnCurrentPage。。。。。。");
    //[self.navigationController popViewControllerAnimated:YES];
    if (_isParentController == NO) {
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (Class)pageControllerClassWithPageNum:(NSInteger)pageNum {
    return nil;
}

- (void)initializePageController:(UIViewController *)viewController withPageNum:(NSInteger)pageNum {
    
}

- (void)focusViewController:(UIViewController *)viewController withPageNum:(NSInteger)pageNum {
    [viewController viewDidAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)layoutControllerViewWithRect:(CGRect)rect {
    _pageControlView.frame = CGRectMake(0.0f, rect.size.height - FSPAGECONTROL_VIEW_HEIGHT, rect.size.width, FSPAGECONTROL_VIEW_HEIGHT);
    _svContainer.frame = CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
    _svContainer.contentSize = CGSizeMake(_pageCount * _svContainer.frame.size.width, _svContainer.frame.size.height);
    NSArray *pageKeys = [_buffers allKeys];
    for (NSNumber *pageKey in pageKeys) {
        UIViewController *viewCtrl = [_buffers objectForKey:pageKey];
        if (viewCtrl) {
            CGSize oldSize = viewCtrl.view.frame.size;
            viewCtrl.view.frame = CGRectMake(0.0f, 0.0f, _svContainer.frame.size.width * [pageKey intValue], _svContainer.frame.size.height);
            if ([viewCtrl respondsToSelector:@selector(layoutControllerViewWithRect:)] && !CGSizeEqualToSize(oldSize, viewCtrl.view.frame.size)) {
                [(id)viewCtrl layoutControllerViewWithRect:CGRectMake(0.0f, 0.0f, viewCtrl.view.frame.size.width, viewCtrl.view.frame.size.height)];
            }
        }
    }
}

- (void)setPageControllerCount:(NSInteger)value {
    
    if (_buffers == nil) {
        _buffers = [[NSMutableDictionary alloc] init];
    }
    
    [self removeAllController];

    _pageCount = value;
    _pageControlView.pageCount = _pageCount;
    _svContainer.contentSize = CGSizeMake(_pageCount * _svContainer.frame.size.width, _svContainer.frame.size.height);
    
    _pageNumber = -1;
    NSLog(@"setPageControllerCount:%d",value);
    if (value > 0 ) {
        [_svContainer.delegate scrollViewDidScroll:_svContainer];
    }

}


- (void)removeAllController {
    NSArray *pageKeys = [_buffers allKeys];
    for (NSNumber *pageKey in pageKeys) {
        UIViewController *viewCtrl = [_buffers objectForKey:pageKey];
        if (viewCtrl) {
            [viewCtrl.view removeFromSuperview];
        }
    }
    
    [_buffers removeAllObjects];
}

#pragma -
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat moveLengs = scrollView.contentOffset.x - scrollView.frame.size.width*_pageNumber;
    
    if ((moveLengs < scrollView.frame.size.width*0.1 && moveLengs > 0) || (moveLengs > 0-scrollView.frame.size.width*0.1 && moveLengs < 0)) {
        return;
    }
    
    NSInteger curPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    if (curPage == _pageNumber) {
        return;
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    _pageNumber = curPage;
    
    [self showPageControllerWithPageNum:_pageNumber];
    NSLog(@"scrollViewDidScroll scrollViewDidScroll");
    
    NSInteger beginPageNum = _pageNumber - BUFFER_FOCUS_OFFSET;
    NSInteger endPageNum = _pageNumber + BUFFER_FOCUS_OFFSET;
    
    if (beginPageNum < 0) {
        beginPageNum = 0;
    }
    
    if (endPageNum > _pageCount - 1) {
        endPageNum = _pageCount - 1;
    }
    
    NSArray *pageKeys = [_buffers allKeys];
    for (NSNumber *pageKey in pageKeys) {
        NSInteger pageKeyValue = [pageKey intValue];
        if (pageKeyValue < beginPageNum || pageKeyValue > endPageNum) {
            FSDeepBaseViewController *viewCtrl = [_buffers objectForKey:pageKey];
            //if (viewCtrl.canDELETE) {
            NSLog(@"viewCtrl.view:%@",viewCtrl.view);
                [viewCtrl.view removeFromSuperview];
                [_buffers removeObjectForKey:pageKey];
            //}
        }
    }
    
    for (int pageIdx = beginPageNum; pageIdx <= endPageNum; pageIdx++) {
        if (pageIdx == _pageNumber) {
            continue;
        }
        
        //[self performSelector:@selector(afterDelayShowPagecontrollerWithPageNum:) withObject:[NSNumber numberWithInteger:pageIdx] afterDelay:0.5f];
        [self showPageControllerWithPageNum:pageIdx];
    }
    
    //_svContainer.contentSize = CGSizeMake(_pageCount * _svContainer.frame.size.width, _svContainer.frame.size.height);
//    
//    FSLog(@"scrollView.subviews:%@", [_svContainer subviews]);
    FSLog(@"controllers:%@", _buffers);  
}

-(void)afterDelayShowPagecontrollerWithPageNum:(NSNumber *)page{
    
    [self showPageControllerWithPageNum:[page integerValue]];
}

- (void)showPageControllerWithPageNum:(NSInteger)pageNum {
    NSNumber *pageKey = [[NSNumber alloc] initWithInt:pageNum];
    UIViewController *viewCtrl = [_buffers objectForKey:pageKey];
    //NSLog(@"showPageControllerWithPageNum:%d",pageNum);
    if (!viewCtrl) {
        NSLog(@"viewCtrl:%@",viewCtrl);
        viewCtrl = [[[self pageControllerClassWithPageNum:pageNum] alloc] init];
        //初始化参数
        //NSLog(@"viewCtrl1:%@",viewCtrl);
        [self initializePageController:viewCtrl withPageNum:pageNum];
        //NSLog(@"viewCtrl2:%@",viewCtrl);
        [_svContainer addSubview:viewCtrl.view];
        viewCtrl.view.frame = CGRectMake(pageNum * _svContainer.frame.size.width, 0.0f, _svContainer.frame.size.width, _svContainer.frame.size.height);
        if ([viewCtrl respondsToSelector:@selector(layoutControllerViewWithRect:)]) {
            [(id)viewCtrl layoutControllerViewWithRect:CGRectMake(0.0f, 0.0f, _svContainer.frame.size.width, _svContainer.frame.size.height)];
        }
        [_buffers setObject:viewCtrl forKey:pageKey];
        [viewCtrl viewWillAppear:NO];
        [viewCtrl viewDidAppear:NO];
        [viewCtrl release];
    }
    
    if (pageNum == _pageNumber) {
//        if ([viewCtrl isKindOfClass:[FSDeepPictureVeiwController class]]) {
//            _pageControlView.isBlackGround = YES;
//        }
//        else{
//            _pageControlView.isBlackGround = NO;
//        }
        _pageControlView.pageIndex = _pageNumber;
        [self focusViewController:viewCtrl withPageNum:_pageNumber];
    }

    [pageKey release];
}

@end
