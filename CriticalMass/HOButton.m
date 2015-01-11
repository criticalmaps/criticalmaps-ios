#import "HOButton.h"

@implementation HOButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect buttonFrame = self.frame;
        buttonFrame.size = CGSizeMake(40, 40);
        self.frame = buttonFrame;
        self.layer.cornerRadius = 3;
        [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.layer setBorderWidth:1.0f];
        //[self setTintColor:[UIColor blueColor]];
    }
    return self;
}

@end
