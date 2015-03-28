//
//  MainViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "MainViewController.h"
#import "ACNavigationController.h"
#import "ListViewController.h"
#import "InfoViewController.h"

#define PANEL_WIDTH 64

@interface MainViewController ()
@property (nonatomic, strong) ACNavigationController *mainNavigationController;
@property (nonatomic, strong) InfoViewController *infoViewController;
@property (nonatomic, strong) ListViewController *listViewController;
@property (nonatomic, assign) BOOL rightViewIsShowing;
@end

@implementation MainViewController

@synthesize mainNavigationController;
@synthesize infoViewController;
@synthesize listViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listViewController = [[ListViewController alloc] init];
    self.mainNavigationController = [[ACNavigationController alloc] initWithRootViewController:listViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRevealInfoView) name:@"menuBarButtonWasPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panToRevealInfoView:) name:@"navigationBarWasPanned" object:nil];
    
    [self setupViews];
}

#pragma mark - setting up the child views

- (void)setupViews {
    [self.view addSubview:self.mainNavigationController.view];
    [self.mainNavigationController.view setFrame:self.view.frame];
    [self addChildViewController:self.mainNavigationController];
    [self.mainNavigationController didMoveToParentViewController:self];
}

- (UIView *)sideInfoView {
    if(self.infoViewController == nil) {
        self.infoViewController = [InfoViewController new];
        [self.infoViewController.view setFrame:CGRectMake(PANEL_WIDTH, 0, self.view.frame.size.width - PANEL_WIDTH, self.view.frame.size.height)];
        [self.view addSubview:self.infoViewController.view];
        [self addChildViewController:self.infoViewController];
        [self.infoViewController didMoveToParentViewController:self];
    }
    
    return self.infoViewController.view;
}

- (void)panToRevealInfoView:(NSNotification *)panNotification {
    /**
     *  Stop and clear out any existing animations that may be running
     */
    [self.mainNavigationController.view.layer removeAllAnimations];
    UIPanGestureRecognizer *panGestureRecogniser = (UIPanGestureRecognizer *)panNotification.object;
    CGPoint translatedPoint = [panGestureRecogniser translationInView:self.mainNavigationController.view];
    CGFloat translatedX = 0;
    
    if([panGestureRecogniser state] == UIGestureRecognizerStateBegan) {
        UIView *infoView = [self sideInfoView];
        [self.view sendSubviewToBack:infoView];
        [self.mainNavigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mainNavigationController.view.layer setShadowOpacity:0.8f];
        [self.mainNavigationController.view.layer setShadowOffset:CGSizeMake(2, 2)];
    }
    if([panGestureRecogniser state] == UIGestureRecognizerStateChanged) {
        
        if(self.mainNavigationController.view.frame.origin.x + translatedPoint.x >= 0) {
            translatedX = 0;
        }
        else if(self.mainNavigationController.view.frame.origin.x + translatedPoint.x <= (0 - (self.mainNavigationController.view.frame.size.width - PANEL_WIDTH))) {
            translatedX = 0 - (self.tabBarController.view.frame.size.width - PANEL_WIDTH);
        }
        else {
            translatedX = self.mainNavigationController.view.frame.origin.x + translatedPoint.x;
        }
        
        CGRect newFrame = CGRectMake(translatedX, self.mainNavigationController.view.frame.origin.y, self.mainNavigationController.view.frame.size.width, self.mainNavigationController.view.frame.size.height);
        
        [self.mainNavigationController.view setFrame:newFrame];
        [panGestureRecogniser setTranslation:CGPointMake(0, 0) inView:self.mainNavigationController.view];
    }
    
    if([panGestureRecogniser state] == UIGestureRecognizerStateEnded) {
        CGFloat dropX = self.mainNavigationController.view.frame.origin.x;
        if(0 - dropX > (self.mainNavigationController.view.frame.size.width / 2)) {
            self.rightViewIsShowing = NO;
        }
        else {
            self.rightViewIsShowing = YES;
        }
        [self toggleRevealInfoView];
    }
    
}

- (void)toggleRevealInfoView {
    UIView *infoView = [self sideInfoView];
    [self.view sendSubviewToBack:infoView];
    
    [UIView animateWithDuration:0.25f delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if(!self.rightViewIsShowing) {
                            /**
                             *  Set the frame for the main navigation controller back left
                             */
                             self.mainNavigationController.view.frame = CGRectMake(0 - (self.view.frame.size.width - PANEL_WIDTH), 0, self.view.frame.size.width, self.view.frame.size.height);
                            /**
                             *  Then set the shadow
                             */
                             [self.mainNavigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
                             [self.mainNavigationController.view.layer setShadowOpacity:0.8f];
                             [self.mainNavigationController.view.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
                             
                         }
                         else {
                            /**
                             *  Resetting things back
                             */
                             self.mainNavigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         
                         /**
                          *  If the state of the right view was showing when this animation completed, then we need to ditch the shadow
                          */
                         if(self.rightViewIsShowing) {
                             [self.mainNavigationController.view.layer setShadowOpacity:0];
                             [self.mainNavigationController.view.layer setShadowOffset:CGSizeMake(0, 0)];
                         }
                         
                         self.rightViewIsShowing = !self.rightViewIsShowing;
                     }
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
