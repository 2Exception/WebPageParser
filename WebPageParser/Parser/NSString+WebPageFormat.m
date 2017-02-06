//
//  NSString+WebPageFormat.m
//  WebPageParser
//
//  Created by wpstarnice on 2017/2/6.
//  Copyright © 2017年 p All rights reserved.
//

#import "NSString+WebPageFormat.h"
#import "RegExCategories.h"

@implementation NSString (WebPageFormat)

-(BOOL)isHtmlFormat{
    
    NSArray* matches = [self matchesWithDetails:RX( @"<(S*?)[^>]*>.*?|<.*? />")];
    
    return ([matches count]);
}

- (BOOL)isXMLFormat{
    
    /*XML序言 <?xml version="1.0"?>*/
    if ([self isEqualToString:@""]){
        return YES;
    }
    
    NSArray* matches = [self matchesWithDetails:RX(@"<[?]xml.*[?]>")];
    
    return ([matches count]);
}

@end
