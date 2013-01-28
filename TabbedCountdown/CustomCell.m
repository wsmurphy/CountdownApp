//
//  CustomCell.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 12/28/12.
//

#import "CustomCell.h"
#import "Common.h"

@implementation CustomCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0
                                             blue:1.0 alpha:1.0].CGColor;
    CGColorRef lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0
                                                 blue:230.0/255.0 alpha:1.0].CGColor;
    CGColorRef separatorColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0
                                                 blue:208.0/255.0 alpha:1.0].CGColor;
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
    
    CGRect strokeRect = paperRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);
    
    CGContextSetStrokeColorWithColor(context, whiteColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
    
    CGPoint startPoint = CGPointMake(paperRect.origin.x,
                                     paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1,
                                   paperRect.origin.y + paperRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, separatorColor);
}

@end
