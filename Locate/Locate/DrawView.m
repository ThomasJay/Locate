//
//  DrawView.m
//  Locate
//
//  Created by Tom Jay on 9/9/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (void)drawRect:(CGRect)rect {
    
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    int size = 20;
    CGRect rectangle = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle);
    
    size = 100;
    CGRect rectangle1 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle1);
    
    size = 200;
    CGRect rectangle2 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);

    CGContextAddEllipseInRect(context, rectangle2);

    size = 300;
    CGRect rectangle3 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle3);

    size = 400;
    CGRect rectangle4 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle4);

    size = 500;
    CGRect rectangle5 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle5);
    
    size = 600;
    CGRect rectangle6 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle6);
    
    size = 700;
    CGRect rectangle7 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle7);
    size = 800;
    CGRect rectangle8 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle8);
    
    size = 900;
    CGRect rectangle9 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle9);
    
    size = 1000;
    CGRect rectangle10 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle10);

    size = 1100;
    CGRect rectangle11 = CGRectMake((width / 2) - (size/2), height - (size / 2),size,size);
    
    CGContextAddEllipseInRect(context, rectangle11);
    
    

    CGContextStrokePath(context);
}

@end
