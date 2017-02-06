//
//  WebPageParserDelegate.h
//  WebPageParser
//
//  Created by wpstarnice on 2017/2/6.
//  Copyright © 2017年 p All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebPageParserDelegate <NSObject>

+ (id)parserWithWebPageContent:(NSString *)content tagName:(NSString *)tagName;

@optional

@property (nonatomic, copy)  NSString *webContent;
@property (nonatomic, copy)  NSString *tagName;
@property (nonatomic, strong)NSArray *tagMatches;
@property (nonatomic, strong)NSArray *tags;// contains TagModel

@end
