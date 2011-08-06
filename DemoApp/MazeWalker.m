#import "MazeWalker.h"
#import "NSInvocation+Quick.h"
#import "SSYAlert.h"
#import "AppDelegate.h"

@implementation MazeWalker

@synthesize name ;
@synthesize distance ;
@synthesize isCancelled ;
@synthesize goFast ;

-(void)main {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	
	NSString* title = [NSString stringWithFormat:@"Message from thread %@", [[NSThread currentThread] threadDictionary]] ;
	NSString* cancelButton = [NSString stringWithFormat:@"Kill %@", self.name] ;
	NSArray* buttonsArray = [NSArray arrayWithObjects:@"Go Slow", cancelButton, @"Go Fast", nil] ;

	while (!self.isCancelled) {
		// Set random timeToNextDecision in range 2 to 8 seconds 
		float period = 2.0 + 6.0*((float)random()/0x7fffffff) ;

		if (self.goFast) {
			period /= 3.0 ;
		}
		
		NSDate* nextTime = [NSDate dateWithTimeIntervalSinceNow:period] ;
		[NSThread sleepUntilDate:nextTime] ;
		
		[self setDistance:(self.distance + 10.0)] ;
		NSString* msg = [NSString stringWithFormat:@"%@ has travelled %0.1f miles.  What now?",
						 self.name, self.distance] ;
		
		// SSYAlert is not thread-safe, which means it cannot be invoked from a non-main
		// thread.  However, we can do so with not too much inconvenience by invoking
		// it via +[NSInvocation invokeOnMainThreadTarget:selector:retainArguments:waitUntilDone:argumentAddresses
		// which is available in NSInvocation+Quick.h.
		NSInvocation* invocation = [NSInvocation invokeOnMainThreadTarget:[SSYAlert class] 
									// Note: Above, we are sending a class ("+") message, so target is the class object.
															  selector:@selector(runModalDialogTitle:message:buttonsArray:)
													   retainArguments:YES
														 waitUntilDone:YES
													 argumentAddresses:&title, &msg, &buttonsArray] ;
		NSInteger alertReturn ;
		[invocation getReturnValue:&alertReturn] ;
		
		// The above is a little more complicated than the main-thread way of doing it,
		// which would be only this one line of code:
		// [SSYAlert runModalDialogTitle:title message:msg buttons:button1, button2, button3, nil] ;
				
		
		switch (alertReturn) {
			case NSAlertDefaultReturn:
				self.goFast = NO ;
				break ;
			case NSAlertAlternateReturn:
				self.isCancelled = YES ;
				break ;
			case NSAlertOtherReturn:
				self.goFast = YES ;
				break ;
		}
		
		NSLog(@"DebugLog: cancelled=%d  goFast=%d ", self.isCancelled, self.goFast) ;

	}
	
	NSLog(@"%@ has been killed.", self.name) ;
	
	AppDelegate* appDelegate = [NSApp delegate] ;
	
	if (appDelegate.operationQueue.operations.count == 1) {
		// That 1 remaining operation running is us, 
		// and we are about to end
		NSString* msg = @"All players are dead.  Game over." ;

		// See note above "SSYAlert is not thread-safe..."
		[NSInvocation invokeOnMainThreadTarget:[SSYAlert class]
									  selector:@selector(runModalDialogTitle:message:buttonsArray:)
							   retainArguments:YES
								 waitUntilDone:YES
							 argumentAddresses:NULL, &msg, NULL] ;
		
		// Start over
		[appDelegate applicationDidFinishLaunching:nil] ;
	}
	[pool release] ;
}

@end

