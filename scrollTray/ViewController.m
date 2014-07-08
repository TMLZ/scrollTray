//
//  ViewController.m
//  scrollTray
//
//  Created by Tyler Miller on 7/1/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign) CGPoint previousPosition;
@property (weak, nonatomic) IBOutlet UIImageView *appBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *scrollContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollTabImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mustache1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mustache2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mustache4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mustache3ImageView;

@property (strong, nonatomic) UIImageView *latestView;

@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize Pan Gesture Recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.scrollTabImageView addGestureRecognizer:panGestureRecognizer];
    [self.scrollTabImageView  setUserInteractionEnabled:YES];
    

    // Add rotation gesture recognizer
    self.rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_rotate:)];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
    
    // Add pinch gesture recognizer
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_pinch:)];
    [self.view addGestureRecognizer:self.pinchGestureRecognizer];
    self.pinchGestureRecognizer.delegate = self;
    
    
    //// MUSTACHE ONE ////
    // Initialize mustache1 drag gesture
    UIPanGestureRecognizer *panMustacheGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMustachePan:)];
    [self.mustache1ImageView addGestureRecognizer:panMustacheGestureRecognizer];
    [self.mustache1ImageView  setUserInteractionEnabled:YES];
    
    
    //// MUSTACHE TWO ////
    // Initialize mustache2 drag gesture
    UIPanGestureRecognizer *panMustache2GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMustache2Pan:)];
    [self.mustache2ImageView addGestureRecognizer:panMustache2GestureRecognizer];
    [self.mustache2ImageView  setUserInteractionEnabled:YES];
    
    
    //// MUSTACHE THREE ////
    // Initialize mustache1 drag gesture
    UIPanGestureRecognizer *panMustache3GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMustache3Pan:)];
    [self.mustache3ImageView addGestureRecognizer:panMustache3GestureRecognizer];
    [self.mustache3ImageView  setUserInteractionEnabled:YES];
    
    
    //// MUSTACHE FOUR ////
    // Initialize mustache1 drag gesture
    UIPanGestureRecognizer *panMustache4GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMustache4Pan:)];
    [self.mustache4ImageView addGestureRecognizer:panMustache4GestureRecognizer];
    [self.mustache4ImageView  setUserInteractionEnabled:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Open the tray
- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    // Calculate offset
    int difference = 0;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPosition = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        difference = self.previousPosition.y - point.y;
        self.previousPosition = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        difference = self.previousPosition.y - point.y;
    }
    
    // Set Offset
    self.scrollContainerView.center = CGPointMake(self.scrollContainerView.center.x, self.scrollContainerView.center.y - difference);
    
    // You hit the ceiling
    if (self.scrollContainerView.center.y < 518) {
        self.scrollContainerView.center = CGPointMake(160, 518);
    }
    
    // Sit on the bottom
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.scrollContainerView.center.y > 530 && velocity.y > 5) {
            [UIView animateWithDuration:.5 animations:^{
                self.scrollContainerView.center = CGPointMake(160, 598);
                self.scrollTabImageView.image = [UIImage imageNamed:@"tabBg2.png"];
            }];
        }
        
        // Reveal the tray
        else if(self.scrollContainerView.center.y < 800 && velocity.y < -10) {
            [UIView animateWithDuration:.5 animations:^{
                self.scrollContainerView.center = CGPointMake(160, 518);
                self.scrollTabImageView.image = [UIImage imageNamed:@"tabBg1.png"];
            }];
        }
    }
}

- (void)onMustachePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint point = [panGestureRecognizer locationInView:self.view];
//    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Make the new view
        self.latestView = [[UIImageView alloc] initWithImage:((UIImageView *)panGestureRecognizer.view).image];
        
        //Make the view on my finger
        self.latestView.center = point;
        
        [self.view addSubview:self.latestView];
        
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        
        //Move object with finger
        self.latestView.center = point;
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
        
    }
}

- (void)onMustache2Pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint point = [panGestureRecognizer locationInView:self.view];
//    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Make the new view
        self.latestView = [[UIImageView alloc] initWithImage:((UIImageView *)panGestureRecognizer.view).image];
        
        //Make the view on my finger
        self.latestView.center = point;
        
        [self.view addSubview:self.latestView];
        
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        
        //Move object with finger
        self.latestView.center = point;
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
        
    }
}

- (void)onMustache3Pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint point = [panGestureRecognizer locationInView:self.view];
  //  CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Make the new view
        self.latestView = [[UIImageView alloc] initWithImage:((UIImageView *)panGestureRecognizer.view).image];
        
        //Make the view on my finger
        self.latestView.center = point;
        
        [self.view addSubview:self.latestView];
        
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        
        //Move object with finger
        self.latestView.center = point;
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
        
    }
}

- (void)onMustache4Pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint point = [panGestureRecognizer locationInView:self.view];
//    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Make the new view
        self.latestView = [[UIImageView alloc] initWithImage:((UIImageView *)panGestureRecognizer.view).image];
        
        //Make the view on my finger
        self.latestView.center = point;
        
        [self.view addSubview:self.latestView];
        
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        
        //Move object with finger
        self.latestView.center = point;
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
        
    }
}


//Rotation recognizer
- (void) _rotate:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    self.latestView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationGestureRecognizer.rotation);
    NSLog(@"I'm rotating");
}

// Pinch recognizer
- (void) _pinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    self.latestView.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    NSLog(@"I'm pinching");

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"HEY");
    return YES;
}

@end
