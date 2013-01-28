//
//  Common.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 12/28/12.
//
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

@end

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor,
                        CGColorRef  endColor);

CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint,
                   CGColorRef color);