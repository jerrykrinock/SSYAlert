#import <Cocoa/Cocoa.h>


@interface MazeWalker : NSOperation {
	NSString* name ;
	float distance ;
	BOOL isCancelled ;
	BOOL goFast ;
}

@property (copy) NSString* name ;
@property (assign) float distance ;
@property (assign) BOOL isCancelled ;
@property (assign) BOOL goFast ;

@end
