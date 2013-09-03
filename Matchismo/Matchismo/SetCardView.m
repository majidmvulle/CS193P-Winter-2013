//
//  SetCardView.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/28/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGPoint myViewCenter;
@end

@implementation SetCardView

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.6

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.8

#define SQUIGGLE_WIDTH 0.20
#define SQUIGGLE_HEIGHT 0.8

    // pi is approximately equal to 3.14159265359.
#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)


- (CGPoint)myViewCenter
{
    return CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2,
                       self.bounds.origin.y + self.bounds.size.height / 2);
}

- (void)drawRect:(CGRect)rect
{

    CGFloat aWidth = 0.0;
    CGFloat aHeight = 0.0;

    NSString *shape = @"";

    if([self.shape isEqualToString:FIRST_SHAPE]){ //Squiggles
        aWidth = SQUIGGLE_WIDTH;
        aHeight = SQUIGGLE_HEIGHT;
        shape = @"squiggle";
    }else if([self.shape isEqualToString:SECOND_SHAPE]){ //Diamonds
        aWidth = DIAMOND_WIDTH;
        aHeight = DIAMOND_HEIGHT;
        shape = @"diamond";
    }else if([self.shape isEqualToString:THIRD_SHAPE]){  //Ovals
        aWidth = OVAL_WIDTH;
        aHeight = OVAL_HEIGHT;
        shape = @"oval";
    }

    
    CGPoint atPoint = CGPointMake(0, 0);
    CGRect myRect = [self makeRectWithWidth:aWidth andHeight:aHeight atPoint:atPoint];
    UIBezierPath *aPath = [UIBezierPath bezierPath];

    for(int i = 1; i <= self.numberOfCharacters; i++){

        if(self.numberOfCharacters == 3){
            switch (i) {
                case 1:
                    atPoint.x = myRect.origin.x - (myRect.size.width + ((aWidth * self.bounds.size.width) / 2));
                    atPoint.y = myRect.origin.y;
                    break;
                case 2:
                    atPoint.x = 0;
                    atPoint.y = 0;
                    break;

                case 3:
                    atPoint.x = myRect.origin.x + (myRect.size.width + ((aWidth * self.bounds.size.width) / 2));
                    atPoint.y = myRect.origin.y;
                    break;

            }

        }else if(self.numberOfCharacters == 2){
            switch (i) {
                case 1:
                    atPoint.x = myRect.origin.x - myRect.size.width ;
                    atPoint.y = myRect.origin.y;
                    break;
                case 2:
                    atPoint.x = myRect.origin.x + ((aWidth * self.bounds.size.width) / 2);
                    atPoint.y = myRect.origin.y;
                    break;

            }
        }

        if([shape isEqualToString:@"squiggle"]){
            aPath = [self drawSquiggleAtPoint:atPoint];
        }else if([shape isEqualToString:@"diamond"]){
            aPath = [self drawDiamondAtPoint:atPoint];
        }else if([shape isEqualToString:@"oval"]){
            aPath = [self drawOvalAtPoint:atPoint];
        }
            //Color
            //Fill
            //Stroke
        [self addPathAttributes:aPath];
    }

}


- (UIBezierPath *)drawOvalAtPoint:(CGPoint)atPoint
{
    CGRect aRect = [self makeRectWithWidth:OVAL_WIDTH andHeight:OVAL_HEIGHT atPoint:atPoint];

    UIBezierPath *oval = [UIBezierPath bezierPath];

        //90% of OVAL HEIGHT
    [oval moveToPoint:CGPointMake(aRect.origin.x,
                                      aRect.origin.y + 0.9*aRect.size.height)];

    [oval addLineToPoint:CGPointMake(aRect.origin.x,
                                         aRect.origin.y + 0.1*aRect.size.height)];

    [oval addArcWithCenter:CGPointMake(aRect.origin.x + aRect.size.width / 2,
                                           aRect.origin.y + 0.1*aRect.size.height)
                        radius: OVAL_WIDTH * self.bounds.size.width / 2
                    startAngle:pi
                      endAngle:0
                     clockwise:YES];

    [oval addLineToPoint:CGPointMake(aRect.origin.x + aRect.size.width,
                                         aRect.origin.y + 0.9*aRect.size.height)];

    [oval addArcWithCenter:CGPointMake(aRect.origin.x + aRect.size.width / 2,
                                           aRect.origin.y + 0.9*aRect.size.height)
                        radius: OVAL_WIDTH * self.bounds.size.width / 2
                    startAngle:0
                      endAngle:pi
                     clockwise:YES];

    return oval;

}


- (UIBezierPath *)drawSquiggleAtPoint:(CGPoint)atPoint
{
    CGRect aRect = [self makeRectWithWidth:SQUIGGLE_WIDTH andHeight:SQUIGGLE_HEIGHT atPoint:atPoint];

    UIBezierPath *squiggle = [UIBezierPath bezierPath];

    [squiggle moveToPoint:CGPointMake(aRect.origin.x + (aRect.size.width * 0.1),
                                      aRect.origin.y + (aRect.size.height * 0.1))];

    [squiggle addCurveToPoint:CGPointMake(aRect.origin.x + (aRect.size.width * 0.9),
                                          aRect.origin.y + (aRect.size.height * 0.95))
                controlPoint1:CGPointMake(aRect.origin.x + (aRect.size.width * 1.6),
                                          aRect.origin.y + (aRect.size.height * 0.2))
                controlPoint2:CGPointMake(aRect.origin.x - (aRect.size.width * 0.1),
                                          aRect.origin.y + (aRect.size.height * 0.6))];

    [squiggle addCurveToPoint:CGPointMake(aRect.origin.x + (aRect.size.width * 0.1),
                                          aRect.origin.y + (aRect.size.height * 0.1))
                controlPoint1:CGPointMake(aRect.origin.x - (aRect.size.width * 0.3),
                                          aRect.origin.y + (aRect.size.height * 0.8))
                controlPoint2:CGPointMake(aRect.origin.x + (aRect.size.width * 0.8),
                                          aRect.origin.y + (aRect.size.height * 0.4))];

    return squiggle;

}

- (UIBezierPath *)drawDiamondAtPoint:(CGPoint)atPoint
{

    CGRect aRect = [self makeRectWithWidth:DIAMOND_WIDTH andHeight:DIAMOND_HEIGHT atPoint:atPoint];

    UIBezierPath *diamond = [UIBezierPath bezierPath];

    [diamond moveToPoint:CGPointMake(aRect.origin.x + aRect.size.width / 2,
                                     aRect.origin.y)];

        //Draw the lines
    [diamond addLineToPoint:CGPointMake(aRect.origin.x + aRect.size.width,
                                        aRect.origin.y + aRect.size.height / 2)];

    [diamond addLineToPoint:CGPointMake(aRect.origin.x + aRect.size.width / 2,
                                        aRect.origin.y + aRect.size.height)];

    [diamond addLineToPoint:CGPointMake(aRect.origin.x,
                                        aRect.origin.y + aRect.size.height / 2)];
    
    [diamond closePath];

    return diamond;
}

- (UIBezierPath *)createArc
{
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 15)
                                                         radius:10
                                                     startAngle:pi
                                                       endAngle:0
                                                      clockwise:YES];
    return aPath;
}




- (void)setColor:(NSString *)color
{
        //First Color: Green
        //Second Color: Red
        //Third Color: Purple
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShape:(NSString *)shape
{
        //First Shape: Squiggles
        //Second Shape: Diamonds
        //Third Shape: Ovals
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
        //First Shading: Solid
        //Second Shading: Striped
        //Third Shading: Unfilled
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumberOfCharacters:(NSUInteger)numberOfCharacters
{
    _numberOfCharacters = numberOfCharacters;
}


- (CGRect)makeRectWithWidth:(CGFloat)aWidth
                  andHeight:(CGFloat)aHeight
                    atPoint:(CGPoint)thePoint
{
    CGPoint atPoint;

    if(thePoint.x == 0 && thePoint.y == 0){
        atPoint = CGPointMake(self.myViewCenter.x - (aWidth * self.bounds.size.width) / 2,
                              self.myViewCenter.y - (aHeight * self.bounds.size.height) / 2);
    }else{
        atPoint.x = thePoint.x;
        atPoint.y = thePoint.y;
    }

    CGRect aRect = CGRectMake(atPoint.x,
                              atPoint.y,
                              aWidth * self.bounds.size.width,
                              aHeight * self.bounds.size.height);
    
    return aRect;
}

- (void)addPathAttributes:(UIBezierPath *)aPath
{
    UIColor *aColor = [UIColor clearColor];

    if([self.color isEqualToString:FIRST_COLOR]){
        aColor = [UIColor greenColor];
    }else if([self.color isEqualToString:SECOND_COLOR]){
        aColor = [UIColor redColor];
    }else if([self.color isEqualToString:THIRD_COLOR]){
        aColor = [UIColor purpleColor];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    [aPath addClip];

    if([self.shading isEqualToString:FIRST_SHADING]){ //solid
        [aColor setFill];
        [aPath fill];
    }else if([self.shading isEqualToString:SECOND_SHADING]){ //striped
   
            //Draw stripes

        
        UIBezierPath *stripe = [UIBezierPath bezierPath];
        CGFloat xPosition = aPath.bounds.origin.x;
        CGFloat yPosition = aPath.bounds.origin.y;
        CGFloat pathWidth = aPath.bounds.size.width;
        CGFloat pathHeight = aPath.bounds.size.height;

        [stripe moveToPoint:aPath.bounds.origin];
        [stripe addLineToPoint:CGPointMake(xPosition + pathWidth, yPosition)];

        while (yPosition <= pathHeight) {
            yPosition += 0.1 * pathHeight;
            [stripe moveToPoint:CGPointMake(xPosition, yPosition)];
            [stripe addLineToPoint:CGPointMake(xPosition + pathWidth, yPosition)];

        }


        [aColor setStroke];
//        [aColor setFill];

        [stripe stroke];
        [aPath stroke];


    }else if([self.shading isEqualToString:THIRD_SHADING]){ //unfilled
        [aColor setStroke];
        [aPath stroke];
        [[UIColor clearColor]setFill];
        [aPath fill];
    }

    CGContextRestoreGState(context);
}

#pragma mark - Initialization

- (void)setup
{
        //Do initialization here
}

- (void)awakeFromNib
{
    [self setup];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
