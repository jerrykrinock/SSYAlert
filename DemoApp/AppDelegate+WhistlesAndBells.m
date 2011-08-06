#import "AppDelegate+WhistlesAndBells.h"
#import "SSYAlert/SSYAlert.h"
#import "SSYAlert/SSYLabelledTextField.h"
#import "SSYAlert/SSYLabelledPopUp.h"
#import "SSYAlert/SSYLabelledList.h"

@interface NSString (ExceedsLength)

- (NSNumber*)exceedsLength:(NSNumber*)threshold  ;

@end

@implementation NSString (ExceedsLength)

- (NSNumber*)exceedsLength:(NSNumber*)threshold {
	BOOL exceeds = ([self length] > [threshold intValue]) ; 
	NSNumber* answer = [NSNumber numberWithBool:exceeds] ;
	return answer ;
}

@end


@implementation AppDelegate (WhistlesAndBells) 

- (void)setButtons2Push3Pop {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	[alert setButton2Title:@"Push Config"] ;
	[alert setButton3Title:@"Pop Config"] ;
}


- (void)config0 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert cleanSlate] ;
	
	[alert setTitleText:@"Demo of SSYAlert's Configurations Stack"] ;
	[alert setSmallTextAlignment:NSLeftTextAlignment] ;
	
	[alert setSmallText:@"SSYAlert stores a stack of configurations, which in this demo app are created by several different methods.  Use the \"Push\" and \"Pop\" buttons to navigate the configurations stack."] ;
	[alert setButton1Title:@"Quit App"] ;
	[self setButtons2Push3Pop] ;
	[alert display] ;
}

- (void)run0 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
/*DB?Line*/ NSLog(@"1300: ") ;
	[alert runModalDialog] ;
}

- (void)config1 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert cleanSlate] ;
	
	[alert setTitleText:@"Whistles and Bells"] ;
	[alert setSmallText:@"This configuration shows many of the whistles and bells of the SSYAlert class.  This window is created in 28 lines of code, with no nib.  Just don't go overboard with controls!"] ;
	[alert setSmallTextAlignment:NSLeftTextAlignment] ;		
	[alert setShowsProgressBar:YES] ;
	[alert setIndeterminate:NO] ;
	[alert setDoubleValue:0] ;
	[alert setMaxValue:4.0] ;
	[alert setHelpAnchor:@"TooManyControls"] ;
	[alert setWindowTitle:@"Sheep Systems, San Jose CA"] ;
	[alert setIconStyle:SSYAlertIconCritical] ;
	[alert setCheckboxTitle:@"Don't show me this any more!"] ;
	[alert setCheckboxState:NSOnState] ;

	// Add a labelled list (table view)
	SSYLabelledList* list = [SSYLabelledList listWithLabel:@"Which planets would you like to visit?  (Hold down the \xe2\x8c\x98 or 'shift' key to select more than one.)"
												   choices:[NSArray arrayWithObjects: @"Mercury", @"Venus", @"Earth", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", nil]
											maxTableHeight:500.0] ;
	[alert addOtherSubview:list
				   atIndex:0] ;

	// Add a non-secure labelled text field
	SSYLabelledTextField* nameControl = [SSYLabelledTextField labelledTextFieldSecure:NO
																   validationSelector:@selector(exceedsLength:)
																	 validationObject:[NSNumber numberWithInt:3]
																	 windowController:alert
																		 displayedKey:@"Your name:"
																	   displayedValue:@"Validator wants 3+ characters"
																			 editable:YES
																		 errorMessage:@"Name must exceed 3 characters before you can do any work."] ;
	[alert addOtherSubview:nameControl
				   atIndex:1] ;

	// Add a secure labelled text field
	SSYLabelledTextField* passwordControl = [SSYLabelledTextField labelledTextFieldSecure:YES
																	   validationSelector:NULL
																		 validationObject:nil
																		 windowController:nil
																			 displayedKey:@"New password:"
																		   displayedValue:nil
																				 editable:YES
																			 errorMessage:nil] ;
	[alert addOtherSubview:passwordControl
				   atIndex:2] ;

	// Add a secure labelled popup button
	SSYLabelledPopUp* animalControl = [SSYLabelledPopUp popUpControlWithLabel:@"Favorite Animal:"] ;
	[alert addOtherSubview:animalControl
				   atIndex:3] ;
	[animalControl setChoices:[NSArray arrayWithObjects:
							   @"Rabbit", @"Bird", @"Pig", nil]] ;
	[alert setButton1Title:@"Do Work"] ;
	[self setButtons2Push3Pop] ;
	[alert display] ;
}


- (void)run1 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	int alertReturn ;
	[alert runModalSession] ;
	while ([alert modalSessionRunning]) {
/*DB?Line*/ NSLog(@"4122: rmd") ;
		
		alertReturn = [alert alertReturn] ;
		if (alertReturn == NSAlertDefaultReturn) {
			// Work
			
			if ([alert.progressBar doubleValue] > 0.99 * [alert.progressBar maxValue]) {
				[alert setDoubleValue:0] ;
			}
			else {
				[alert incrementDoubleValueBy:1.0] ;
			}
		}
		else {
			[alert endModalSession] ;
		}		
	}
	
	// Demonstrate retrieving data:
	NSArray* otherSubviews = alert.otherSubviews ;
	// If we are popping back, otherSubviews might be empty
	if (otherSubviews.count > 2) {
		NSLog(@"  Selected Planets: %@", [[otherSubviews objectAtIndex:0] selectedValues]) ;
		NSLog(@"              Name: %@", [[otherSubviews objectAtIndex:1] stringValue]) ;
		NSLog(@"          Password: %@", [[otherSubviews objectAtIndex:2] stringValue]) ;
		NSLog(@"      Animal Index: %d", [[otherSubviews objectAtIndex:3] selectedIndex]) ;
		NSLog(@"     Show any more? %d", [alert checkboxState]) ;
	}
}	

- (void)config2 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert cleanSlate] ;
	
	[alert setTitleText:@"Using allowsShrinking: and rightColumnMinimumWidth:"] ;
	[alert setSmallTextAlignment:NSLeftTextAlignment] ;
	[alert setSmallText:@"If your smallText message has just a few words like this..."] ;	
	
	[alert setAllowsShrinking:NO] ;
	[alert setRightColumnMinimumWidth:450] ;
	
	[alert setButton1Title:@"Quit App"] ;
	[self setButtons2Push3Pop] ;
	[alert display] ;
}

- (void)run2 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert runModalDialog] ;
}

- (void)config3 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert setSmallText:@"and then you change it to have many more words like this, the window needs to get taller.  But then if you later set it to have fewer words again, it would resize to a smaller size and then the window would get smaller again.  This will give the user a headache.  So if we are going to do be increasing and decreasing the text content repeatedly, we setAllowsShrinking:NO.\n\nAlso, if we have many lines of text, we setRightColumnMinimumWidth: to exceed the default of 250, so our window does not become too tall and skinny.  Push Config to see what happens next."] ;
	[alert setButton1Title:@"Quit App"] ;
	[self setButtons2Push3Pop] ;
	[alert display] ;
}

- (void)run3 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert runModalDialog] ;
}

- (void)config4 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert setSmallText:@"You see the text view did not get any smaller.  (Unless you popped configurations, which sets allowsShrinking back to the default value of NO, but did not pop enough to rerun config2 which resets it to YES.)"] ;
	[alert setButton1Title:@"Quit App"] ;
	[self setButtons2Push3Pop] ;
	[alert display] ;
}


- (void)run4 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert runModalDialog] ;
}

- (void)config5 {
	// No-op here.  We'll create and set an NSError in -run6.
}


- (void)run5 {
	// [alert cleanSlate] ; // Not needed in this case since alertError:
	
	NSString* description = @"This is a simulated error which will be displayed using one of the -[SSYAlertError alertError:xxx] methods, which are improved replacements for the -[NSResponder presentError:xxx] methods." ;
	NSString* suggestion = @"Clicking the button in the lower left will create a description of the NSError and mailto: the programmer's email given in Info.plist key SSYAlert_ErrorSupportEmail.\n\nNote that, unlike Apple's -presentError: methods, +[SSYAlert alertError:] allows only three buttons." ;
	NSArray* buttons = [NSArray arrayWithObjects:@"Quit App", @"Push Config", @"Pop Config", nil] ;
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  description, NSLocalizedDescriptionKey,
							  suggestion, NSLocalizedRecoverySuggestionErrorKey,
							  buttons, NSLocalizedRecoveryOptionsErrorKey,
							  @"Your own value", @"YourOwnKey",
							  nil] ;
	
	NSError* error = [[NSError alloc] initWithDomain:@"SSYAlert Demo Error Domain"
												code:911
											userInfo:userInfo] ;
	
	
	// Once you've created the NSError and set your email address into
	// the Info.plist dictionary key SSYAlert_ErrorSupportEmail, as with
	// Apple's -presentError:, it takes just one line of code to display it.
	[SSYAlert alertError:error] ;
}	

- (void)config6 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[alert cleanSlate] ;
	
	[alert setTitleText:@"Indeterminate Progress"] ;
	[alert setSmallTextAlignment:NSCenterTextAlignment] ;
	[alert setSmallText:@"Progress bars will animate fine while the main thread is sleeping, but not during modal dialogs.\nGoing once..."] ;
	[alert setShowsProgressBar:YES] ;
	[alert setIndeterminate:YES] ;
	[alert setProgressBarShouldAnimate:YES] ;	
	[alert setButton1Title:@"Quit App"] ;
	[self setButtons2Push3Pop] ;
	[alert display] ;
}

- (void)run6 {
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]] ;
	[alert setSmallText:@"Progress bars will animate fine while the main thread is sleeping, but not during modal dialogs.\nGoing twice....."] ;
	[alert display] ;
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]] ;
	[alert setSmallText:@"Progress bars will animate fine while the main thread is sleeping, but not during modal dialogs.\nGoing thrice......."] ;
	[alert display] ;
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]] ;
	[alert setSmallText:@"Progress bars will animate fine while the main thread is sleeping, but not during modal dialogs.\nBeginning modal dialog."] ;
	[alert display] ;
	[alert runModalDialog] ;
}	

#define NUM_CONFIGS 7

- (void)showWhistlesAndBells {
/*DB?Line*/ NSLog(@"9734: ") ;
	SSYAlert* alert = [SSYAlert sharedAlert] ;
	
	while (YES) {
		NSInteger nextConfig = [[alert configurations] count] ;
		if (nextConfig >= NUM_CONFIGS) {
			// Whoops
			nextConfig = NUM_CONFIGS - 1 ;
			NSBeep() ;
		}
		
		
		if (nextConfig < NUM_CONFIGS) {
			[alert pushConfiguration] ;
			NSLog(@"After pushing, stack has %d configurations", [[alert configurations] count]) ;
		}
		else {
			NSBeep() ;
		}
		
		// Configure the configuration
		NSString* selectorName = [NSString stringWithFormat:@"config%d", nextConfig] ;
		SEL selector = NSSelectorFromString(selectorName) ;
		NSLog(@"%@ will perform %@", [self class], selectorName) ;
		[self performSelector:selector] ;
		
		while (YES) {
/*DB?Line*/ NSLog(@"10463: ") ;
			if (nextConfig >= 0) {
				// Run the next configuration
				NSString* selectorName = [NSString stringWithFormat:@"run%d", nextConfig] ;
				SEL selector = NSSelectorFromString(selectorName) ;
				NSLog(@"%@ will perform %@", [self class], selectorName) ;
				[self performSelector:selector] ;		
				[alert endModalSession] ; // In case run%d did a session instead of a dialog
			}
			else {
				[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.7]] ;
				NSBeep() ;
				NSString* msg = @"Notice that the SSYAlert disappeared because you popped off the last visible configuration.  We just waited a couple seconds to show you that.\n\nClick \"OK\" to restart the demo." ;
				// This gives us a chance to demo one of the all-in-one class methods.
				// The next line of code is the equivalent of NSRunAlertPanel().
				// It's a little easier to use, and it's not as easy to make a mistake
				// which will cause a crash.  Just remember the nil sentinel on buttons:
				[SSYAlert runModalDialogTitle:nil     // title:nil defaults to localized "Alert"
									  message:msg
									  buttons:nil] ;  // buttons:nil defaults to one localized "OK" button
				break ;
			}
			
			NSInteger replyValue = [alert alertReturn] ;				   
			
			if (replyValue == NSAlertDefaultReturn) {
				// Quit
				[NSApp terminate:self] ;
			}
			else if (replyValue == NSAlertAlternateReturn) {
				// Back to the outer loop
				break ;
			}
			else {
				// It is safe to sent SSYAlert -popConfiguration even if there
				// are no configurations to pop
				[alert popConfiguration] ;
				NSLog(@"After popping, stack has %d configurations", [[alert configurations] count]) ;
				
				nextConfig-- ;
			}
		}
	}
}	

@end