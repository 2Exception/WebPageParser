//
//  TagModel.m
//  WebPageParser
//
//  Created by wpstarnice on 2016/12/17.
//  Copyright © 2017年 p All rights reserved.
//

#import "TagModel.h"

static NSString *const kPattern = @"([ |\r|\n|\t]%@\\s*?=\\s*?\")(.*?)(\")|([ |\r|\n|\t]%@\\s*?=\\s*?\')(.*?)(\')";

@implementation TagModel

#pragma mark - initialize

+ (TagModel *)initWithTag:(NSString *)tag type:(WebPageType)type;{
    
    return [TagModel initWithTag:tag type:type tagName:@""];
}

+ (TagModel *)initWithTag:(NSString *)tag type:(WebPageType)type tagName:(NSString *)tagName{
    
    TagModel *model = [[TagModel alloc] init];
    model.tag = tag;
    model.tagName = tagName;
    model.type = type;
    
    return model;
}

#pragma mark - public

- (NSString *)attributeValueForName:(NSString *)name{
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:_tag
                                                    options:0
                                                      range:NSMakeRange(0, _tag.length)];
    
    if (_type == WebPageTypeHtml){
       
        if (!match) {
            return nil;
        }
        
        NSRange range = [match rangeAtIndex:2];
        if (range.location == NSNotFound) {
            range = [match rangeAtIndex:5];
        }
        
        NSString *value = [_tag substringWithRange:range];
        
        return value;
        
    }else{
        // get attribute value,if fail get element
        if (match){
            
            NSRange range = [match rangeAtIndex:2];
            if (range.location == NSNotFound) {
                range = [match rangeAtIndex:5];
            }
            NSString *value = [_tag substringWithRange:range];
            return value;
            
        }else{
            return [self elementValueForName:name];
        }
    }
    return nil;
}

//for xml
- (NSString *)elementValueForName:(NSString *)name{
    
    if ([name isEqualToString:@"src"]||
        [name isEqualToString:@"path"]){
        
        NSLog(@"elementValue should nerver read src or path");
        assert(0);
    }
    
    NSError *error = nil;
    NSString *pattern = [NSString stringWithFormat:@"(<%@.*?>)([\\s|\\S]*?)(</%@>)",name,name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    if (regex){
        
        NSTextCheckingResult *match = [regex firstMatchInString:_tag
                                                        options:0
                                                          range:NSMakeRange(0,_tag.length)];
        
        if (match){
            
            NSString *elementValue = [_tag substringWithRange:[match range]];
            
            elementValue = [regex stringByReplacingMatchesInString:elementValue
                                                           options:0
                                                             range:NSMakeRange(0, [elementValue length])
                                                      withTemplate:@"$2"];
            
            return elementValue;
        }
    }
    
    return nil;
}

// html set attribute, xml set element
- (void)setAttributeValue:(NSString *)value forName:(NSString *)name{
    
    if (_type == WebPageTypeHtml){
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:_tag
                                                        options:0
                                                          range:NSMakeRange(0, _tag.length)];
        if (!match) {
            
            [self addAttributeValue:value forName:name];
            return;
            
        }else{
            
            NSString *template = nil;
            NSRange range = [match rangeAtIndex:2];
            if (range.location != NSNotFound) {
                template = [NSString stringWithFormat:@"$1%@$3", value];
            } else {
                template = [NSString stringWithFormat:@"$4%@$6", value];
            }
            self.tag = [regex stringByReplacingMatchesInString:self.tag
                                                       options:0
                                                         range:NSMakeRange(0, self.tag.length)
                                                  withTemplate:template];
        }
        
    }else{
        [self setElementValue:value forName:name];
    }
}

//for xml
- (void)setElementValue:(NSString *)aValue forName:(NSString *)aName{
    
    NSError *error = nil;
    NSString *pattern = [NSString stringWithFormat:@"(<%@.*?>)([\\s|\\S]*?)(</%@>)", aName, aName];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (regex){

        NSTextCheckingResult *match = [regex firstMatchInString:self.tag
                                                        options:0
                                                          range:NSMakeRange(0, self.tag.length)];
        if (match){
            
            self.tag = [regex stringByReplacingMatchesInString:self.tag
                                                       options:0
                                                         range:NSMakeRange(0, [self.tag length])
                                                  withTemplate:[NSString stringWithFormat:@"$1%@$3",aValue]];
        }
        else
        {
            [self addElementValue:aValue forName:aName];
        }
    }
}

-(void)removeAttribute:(NSString *)name{
    
    if (_tag == WebPageTypeHtml){
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        self.tag = [regex stringByReplacingMatchesInString:self.tag
                                                   options:0
                                                     range:NSMakeRange(0, self.tag.length)
                                              withTemplate:@" "];
    }else{
        
        [self removeElement:name];
    }
}

- (void)removeElement:(NSString *)name{
    
    NSError *error = nil;
    NSString *pattern = [NSString stringWithFormat:@"\n{0,1}[ ]*<+%@+[^>]*?((>[\\s|\\S]*?</+%@+>)|(/>))", name, name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    self.tag = [regex stringByReplacingMatchesInString:self.tag options:0 range:NSMakeRange(0, self.tag.length) withTemplate:@""];
}

#pragma mark - private

//html ref
- (void)addAttributeValue:(NSString *)value forName:(NSString *)name{
    
    NSString *attribute = [NSString stringWithFormat:@" %@=\"%@\"",name,value];
    NSString *pattern1 = [NSString stringWithFormat:@"(\\s*/>)"];
    NSString *pattern2 = [NSString stringWithFormat:@"(\\s*>)"];
    NSString *pattern = [NSString stringWithFormat:@"%@|%@", pattern1, pattern2];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSString *template = [NSString stringWithFormat:@"%@$1", attribute];
    self.tag = [regex stringByReplacingMatchesInString:self.tag
                                               options:0
                                                 range:NSMakeRange(0, self.tag.length)
                                          withTemplate:template];
}

// xml ref
-(void)addElementValue:(NSString *)value forName:(NSString *)name{
    
    NSError *error = nil;
    NSString *elementToAdd = [NSString stringWithFormat:@"\n<%@>%@</%@>",name,value,name];
    NSString *pattern = @"<.*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self.tag
                                                    options:0
                                                      range:NSMakeRange(0, self.tag.length)];
    
    if (match){
        NSString *tagPre = [self.tag substringWithRange:match.range];
        NSString *tagSuf = [self.tag substringWithRange:NSMakeRange(match.range.location+match.range.length, self.tag.length - match.range.length)];
        self.tag = [NSString stringWithFormat:@"%@%@%@",tagPre,elementToAdd,tagSuf];
    }
}

@end
