//
//  Parser.m
//  WebPageParser
//
//  Created by wpstarnice on 2017/1/18.
//  Copyright © 2017年 p All rights reserved.
//

#import "TagParser.h"
#import "XMLTagParser.h"
#import "HTMLTagParser.h"
#import "NSString+WebPageFormat.h"

@implementation TagParser

+ (id)parserWithWebPageContent:(NSString *)content tagName:(NSString *)tagName{
  
    if (content.length == 0){
        return nil;
    }
    
    if ([content isXMLFormat]) {
        
        return [XMLTagParser parserWithWebPageContent:content tagName:tagName];
        
    }else{
        
        return [HTMLTagParser parserWithWebPageContent:content tagName:tagName];
    }
}

@end
