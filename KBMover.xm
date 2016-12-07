#import "KBMover.h"

BOOL isLandscape;
BOOL stopTouch;
int WidthMax;
int HeightMax;
int orientationNow = 1;


%hook UIInputSetContainerView

%new
- (void)handlePan:(UIPanGestureRecognizer*)panGesture
{
	@autoreleasepool {
		UIGestureRecognizerState state = [panGesture state];
		CGPoint translation = [panGesture translationInView:[panGesture view]];
		CGPoint velocity = [panGesture velocityInView:[panGesture view]];
		
		WidthMax = [[UIScreen mainScreen] bounds].size.width;
		HeightMax = [[UIScreen mainScreen] bounds].size.height;
				
		if(velocity.x >0) {}
		
		CGFloat directionX;
		CGFloat directionY;
		CGFloat velocityX;
		CGFloat velocityY;
		
		switch (orientationNow) {
			case UIInterfaceOrientationPortrait: {
				directionX = translation.x;
				directionY = translation.y;
				velocityX = velocity.x;
				velocityY = velocity.y;
				break;
			}
			case UIInterfaceOrientationLandscapeLeft: {
				directionX = translation.y;
				directionY = -translation.x;
				velocityX = velocity.y;
				velocityY = -velocity.x;
				break;
			}
			case UIInterfaceOrientationLandscapeRight: {
				directionX = -translation.y;
				directionY = translation.x;
				velocityX = -velocity.y;
				velocityY = velocity.x;
				break;
			}
			case UIInterfaceOrientationPortraitUpsideDown: {
				directionX = -translation.x;
				directionY = -translation.y;
				velocityX = -velocity.x;
				velocityY = -velocity.y;
				break;
			}			
			default: {
				directionX = translation.x;
				directionY = translation.y;
				velocityX = velocity.x;
				velocityY = velocity.y;
				break;
			}
		}

		if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
			if (state == UIGestureRecognizerStateBegan) {
				if(stopTouch) {
					stopTouch = NO;
				}
				if(UIView *LayoutsKeys = (UIView *)[%c(UIKeyboardImpl) sharedInstance]) {
					if(LayoutsKeys.frame.size.height != self.frame.size.height) {
						CGRect newFrame = self.frame;
						newFrame.origin.y = self.frame.size.height-LayoutsKeys.frame.size.height;
						newFrame.size.height = LayoutsKeys.frame.size.height;
						newFrame.size.width = LayoutsKeys.frame.size.width;
						self.frame = newFrame;
					}
				}
			}
			if(stopTouch) {
				//return;
			}
			[UIView animateWithDuration:0.2/2 animations:^{
				[[panGesture view] setCenter:CGPointMake([[panGesture view] center].x + directionX, [[panGesture view] center].y + directionY)];
				[panGesture setTranslation:CGPointZero inView:[panGesture view]];
				
				int pointX = [[panGesture view] center].x + translation.x;
				int pointY = [[panGesture view] center].y + translation.y;
				if(isLandscape) {
					if (pointY >= HeightMax-30) {
						if([panGesture view].alpha >= 1) {
						} else {
							stopTouch = YES;
						}
					} else if (pointY <= 30) {
						if([panGesture view].alpha >= 1) {
						} else {
							stopTouch = YES;
						}
					} else {
						if([panGesture view].alpha < 1) {
							stopTouch = YES;
						}
					}
				} else {
					if (pointX >= WidthMax-30) {
						if([panGesture view].alpha >= 1) {
						} else {
							stopTouch = YES;
						}
					} else if (pointX <= 30) {
						if([panGesture view].alpha >= 1) {
						} else {
							stopTouch = YES;
						}
					} else {
						if([panGesture view].alpha < 1) {
							stopTouch = YES;
						}
					}
				}
			}];
			
		} else if (state == UIGestureRecognizerStateEnded) {
			
			if(stopTouch) {
				stopTouch = NO;
				//return;
			}
			[UIView animateWithDuration:0.5/1.5 animations:^{
				CGFloat magnitude = sqrtf((velocityX * velocityX) + (velocityY * velocityY));
				CGFloat slideMult = magnitude / 700;
				float slideFactor = 0.1 * slideMult;				
				
				int pointX = [[panGesture view] center].x + (velocityX * slideFactor) + directionX;
				int pointY = [[panGesture view] center].y + (velocityY * slideFactor) + directionY;
				int Borda = isLandscape?([panGesture view].frame.size.height/2.3):([panGesture view].frame.size.width/2.3);
				
				if(isLandscape) {
					if (pointX > WidthMax-([panGesture view].frame.size.width/2)) {
						pointX = WidthMax-([panGesture view].frame.size.width/2);
					} else if (pointX < ([panGesture view].frame.size.width/2)) {
						pointX = ([panGesture view].frame.size.width/2);
					}
					if (pointY >= HeightMax-100) {
						pointY = HeightMax+(Borda);
						[panGesture view].alpha = 0.5;
					} else if (pointY <= 100) {
						pointY = 0-(Borda);
						[panGesture view].alpha = 0.5;
					} else {
						[panGesture view].alpha = 1.0;
					}
				} else {
					if (pointX >= WidthMax-100) {
						pointX = WidthMax+(Borda);
						[panGesture view].alpha = 0.5;
					} else if (pointX <= 100) {
						pointX = 0-(Borda);
						[panGesture view].alpha = 0.5;
					} else {
						[panGesture view].alpha = 1.0;
					}
					if (pointY <= ([panGesture view].frame.size.height/2) ) {
						pointY = [panGesture view].frame.size.height/2;
					} else if (pointY >= (HeightMax-([panGesture view].frame.size.height/2)) ) {
						pointY = (HeightMax-([panGesture view].frame.size.height/2));
					}
				}				
				[[panGesture view] setCenter:CGPointMake( pointX, pointY)];
			}];
			[panGesture setTranslation:CGPointZero inView:[panGesture view]];
			if([panGesture view].alpha < 1) {
				
			}
		}
	}
}


- (id)initWithFrame:(CGRect)arg1
{
	id orig = %orig;
	
	WidthMax = [[UIScreen mainScreen] bounds].size.width;
	HeightMax = [[UIScreen mainScreen] bounds].size.height;
	
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setCancelsTouchesInView:YES];
	[self addGestureRecognizer:panGesture];
	
	return orig;
}
%end



__attribute__((constructor)) static void initialize_KBMover()
{
	@autoreleasepool {
		%init;
	}
}