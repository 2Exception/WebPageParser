//
//  XMLTagParser.m
//  WebPageParser
//
//  Created by wpstarnice on 2017/2/6.
//  Copyright © 2017年 p All rights reserved.
//

#import "XMLTagParser.h"
#import "TagModel.h"

@implementation XMLTagParser

@synthesize webContent;
@synthesize tagName;
@synthesize tagMatches;
@synthesize tags;

+ (id)parserWithWebPageContent:(NSString *)content tagName:(NSString *)tagName{
    
    XMLTagParser *parser = [[XMLTagParser alloc] init];
    parser.webContent = content;
    parser.tagName = tagName;
    [parser parse];
    
    return parser;
}

- (void)parse{
    
    /*tagName format: "<"+tagName+"[^>]*?((>.*?</"+tagName+">)|(/>))"*/
    NSError *error = nil;
    NSString *pattern = [NSString stringWithFormat:@"<+%@+[^>]*?((>[\\s|\\S]*?</+%@+>)|(/>))", self.tagName, self.tagName];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    self.tagMatches = [regex matchesInString:self.webContent
                                     options:0
                                       range:NSMakeRange(0, [self.webContent length])];
    
    NSMutableArray *_tags = [NSMutableArray arrayWithCapacity:self.tagMatches.count];
    for (NSTextCheckingResult *match in self.tagMatches) {
        NSRange range = [match range];
        NSString *tag = [self.webContent substringWithRange:range];
        TagModel *model = [TagModel initWithTag:tag type:WebPageTypeXml tagName:self.tagName];

        [_tags addObject:model];
    }
    self.tags = _tags;
}

@end
