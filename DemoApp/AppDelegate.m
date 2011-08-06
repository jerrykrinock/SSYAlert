#import "AppDelegate.h"
#import "AppDelegate+WhistlesAndBells.h"
#import "MazeWalker.h"
#import "SSYAlert.h"

@implementation AppDelegate

- (NSOperationQueue*)operationQueue {
	if (!operationQueue) {
		operationQueue = [[NSOperationQueue alloc] init] ;
	}
	
	return operationQueue ;
}

- (void)dealloc {
	[operationQueue release] ;
	
	[super dealloc] ;
}

- (void)addOperationWithName:(NSString*)name {
	MazeWalker* mazeWalker = [[MazeWalker alloc] init] ;
	[mazeWalker setName:name] ;
	[self.operationQueue addOperation:mazeWalker] ;
}

- (void)loadQueue {
	[self addOperationWithName:@"Tom"] ;
	[self addOperationWithName:@"Dick"] ;
	[self addOperationWithName:@"Suzie"] ;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
/*DB?Line*/ NSLog(@"1069 %s", __PRETTY_FUNCTION__) ;
	NSString* description = @"This is the localized description presented by Apple's -presentError:." ;
	NSString* suggestion = @"This is your error's localizedRecoverySuggestion as presented by Apple's -presentError:.  Later in the demo, you will see +[SSYAlert alertError:], an alternative to this." ;
	NSArray* buttons = [NSArray arrayWithObjects:@"Buttons", @"Number of", @"Unlimited", @"Allows an", @"presentError:", nil] ;
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  description, NSLocalizedDescriptionKey,
							  suggestion, NSLocalizedRecoverySuggestionErrorKey,
							  buttons, NSLocalizedRecoveryOptionsErrorKey,
							  self, NSRecoveryAttempterErrorKey,
							  @"Your own value", @"YourOwnKey",
							  nil] ;
	
/*DB?Line*/ NSLog(@"1833: ") ;
	NSError* error = [[NSError alloc] initWithDomain:@"SSYAlert Demo Error Domain"
												code:911
											userInfo:userInfo] ;

/*DB?Line*/ NSLog(@"1998: ") ;
	// Now we will use Apple's -presentError.
	// To present a modal dialog, this message can be sent to
	// almost any object.  NSApp is handy.
	[NSApp presentError:error] ;

/*DB?Line*/ NSLog(@"2140: ") ;
	NSInteger alertReturn = [SSYAlert runModalDialogTitle:@"What Do You Want To See"
												  message:@"Click 'Whells' to show Whistles and Bells.\n\nClick 'Multithread' to hit SSYAlert from multiple threads."
												  buttons:@"Multithread", @"Whells", nil] ;
/*DB?Line*/ NSLog(@"2408: ") ;
	switch (alertReturn) {
		case NSAlertDefaultReturn:
			[self loadQueue] ;
			break ;
		case NSAlertAlternateReturn:
			[self showWhistlesAndBells] ;
			break ;
	}
}

- (void)attemptRecoveryFromError:(NSError*)error
					 optionIndex:(NSUInteger)index {
	NSLog(@"DebugLog: [%@ %s]:57151.  Clicked button index = %d", [self class], _cmd, index) ;
	NSLog(@"If you were using Apple's -presentError:, you handle recovery here.") ;
}

@end