#import <QuartzCore/QuartzCore.h>
#import "CoverFlowView.h"

@implementation CoverFlowView
@synthesize label;
@synthesize phimg;
@synthesize host;
@synthesize cfLayer;

- (CoverFlowView *) initWithFrame: (CGRect) aRect andCount: (int) count
{
	self = [super initWithFrame:aRect];
	self.cfLayer = [[UICoverFlowLayer alloc] initWithFrame:[[UIScreen mainScreen] bounds] numberOfCovers:count numberOfPlaceholders:1];
	[[self layer] addSublayer:(CALayer *)self.cfLayer];

	// Add the placeholder (image stand-in) layer
	CGRect phrect = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
	self.phimg = [[UIImageView alloc] initWithFrame:phrect];
	[self.cfLayer setPlaceholderImage: [self.phimg layer] atPlaceholderIndex:0];
	
	unsigned int *pharray = malloc(count * sizeof(int));
	for (int i = 0; i < count; i++) pharray[i] = 0;;
	[cfLayer setPlaceholderIndicesForCovers:pharray];
	
	// Add its info (label) layer
	self.label = [[UILabel alloc] init];
	[self.label setTextAlignment:UITextAlignmentCenter];
	[self.label setFont:[UIFont boldSystemFontOfSize:20.0f]];
	[self.label setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
	[self.label setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f]];
	[self.label setNumberOfLines:2];
	[self.label setLineBreakMode:UILineBreakModeWordWrap];
	[self.cfLayer setInfoLayer:[self.label layer]];

	return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self.cfLayer dragFlow:0 atPoint:[[touches anyObject] locationInView:self]];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self.cfLayer dragFlow:1 atPoint:[[touches anyObject] locationInView:self]];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if ([[touches anyObject] tapCount] == 2)
	{
		if (self.host) [self.host doubleTapCallback];
		return;
	}
	
	[self.cfLayer dragFlow:2 atPoint:[[touches anyObject] locationInView:self]];
}

- (void) flipSelectedCover
{
	[self.cfLayer flipSelectedCover];
}

- (BOOL) ignoresMouseEvents 
{
	return NO;
}

- (void) tick 
{
	[self.cfLayer displayTick];
}

- (void) dealloc
{
	if (self.host) [self.host release];
	[self.label release];
	[self.phimg release];
	[self.cfLayer release];
	[super dealloc];
}
@end

