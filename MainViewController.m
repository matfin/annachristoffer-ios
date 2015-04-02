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
#import "MenuViewController.h"

#define PANEL_WIDTH 64

@interface MainViewController ()
@property (nonatomic, strong) ACNavigationController *mainNavigationController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) ListViewController *listViewController;
@property (nonatomic, assign) BOOL rightViewIsShowing;
@end

@implementation MainViewController

@synthesize mainNavigationController;
@synthesize menuViewController;
@synthesize listViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listViewController = [[ListViewController alloc] init];
    self.mainNavigationController = [[ACNavigationController alloc] initWithRootViewController:listViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRevealMenuView) name:@"menuBarButtonWasPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRevealMenuView) name:@"menuBarToggleWasCalled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panToRevealMenuView:) name:@"navigationBarWasPanned" object:nil];
    [self setupViews];
}

#pragma mark - setting up the child views

- (void)setupViews {
    [self.view addSubview:self.mainNavigationController.view];
    [self.mainNavigationController.view setFrame:self.view.frame];
    [self addChildViewController:self.mainNavigationController];
    [self.mainNavigationController didMoveToParentViewController:self];
}

- (UIView *)sideMenuView {
    if(self.menuViewController == nil) {
        self.menuViewController = [MenuViewController new];
        [self.menuViewController.view setFrame:CGRectMake(PANEL_WIDTH, 0, self.view.frame.size.width - PANEL_WIDTH, self.view.frame.size.height)];
        [self.view addSubview:self.menuViewController.view];
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
    }
    
    return self.menuViewController.view;
}

- (void)panToRevealMenuView:(NSNotification *)panNotification {
    /**
     *  Stop and clear out any existing animations that may be running
     */
    [self.mainNavigationController.view.layer removeAllAnimations];
    UIPanGestureRecognizer *panGestureRecogniser = (UIPanGestureRecognizer *)panNotification.object;
    CGPoint translatedPoint = [panGestureRecogniser translationInView:self.mainNavigationController.view];
    CGFloat translatedX = 0;
    
    if([panGestureRecogniser state] == UIGestureRecognizerStateBegan) {
        UIView *menuView = [self sideMenuView];
        [self.view sendSubviewToBack:menuView];
        [self.mainNavigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mainNavigationController.view.layer setShadowOpacity:0.8f];
        [self.mainNavigationController.view.layer setShadowOffset:CGSizeMake(2, 2)];
    }
    if([panGestureRecogniser state] == UIGestureRecognizerStateChanged) {
        /**
         *  This is to prevent the main navigation controller from being dragged to the right
         */
        if(self.mainNavigationController.view.frame.origin.x + translatedPoint.x >= 0) {
            translatedX = 0;
        }
        /**
         *  This is to prevent the main navigation controller from being dragged too far to the left
         */
        else if(self.mainNavigationController.view.frame.origin.x + translatedPoint.x <= (0 - (self.mainNavigationController.view.frame.size.width - PANEL_WIDTH))) {
            translatedX = 0 - (self.tabBarController.view.frame.size.width - PANEL_WIDTH);
        }
        /**
         *  This will set the translation point each time a pan gesture changes - when the finger is dragged
         */
        else {
            translatedX = self.mainNavigationController.view.frame.origin.x + translatedPoint.x;
        }
        
        /**
         *  Setting up the new frame according to the tranlsation point
         */
        CGRect newFrame = CGRectMake(translatedX, self.mainNavigationController.view.frame.origin.y, self.mainNavigationController.view.frame.size.width, self.mainNavigationController.view.frame.size.height);
        
        /**
         *  And setting the transation on the frame of the view for the main navigation controller
         */
        [self.mainNavigationController.view setFrame:newFrame];
        /**
         *  Rest the translation point for the gesture recogniser when the frame has been updated
         */
        [panGestureRecogniser setTranslation:CGPointMake(0, 0) inView:self.mainNavigationController.view];
    }
    
    if([panGestureRecogniser state] == UIGestureRecognizerStateEnded) {
        
        /**
         *  Calculating the frame for the main navigation controllers position, 
         *  to decide whether or not to reveal or hide the right side view
         */
        
        CGFloat dropX = self.mainNavigationController.view.frame.origin.x;
        if(0 - dropX > (self.mainNavigationController.view.frame.size.width / 2)) {
            self.rightViewIsShowing = NO;
        }
        else {
            self.rightViewIsShowing = YES;
        }
        [self toggleRevealMenuView];
    }
}

- (void)toggleRevealMenuView {
    UIView *menuView = [self sideMenuView];
    [self.view sendSubviewToBack:menuView];
    
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
