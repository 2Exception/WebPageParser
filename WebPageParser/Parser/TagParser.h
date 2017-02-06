//
//  TagParser.h
//  WebPageParser
//
//  Created by wpstarnice on 2017/1/18.
//  Copyright © 2017年 p All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"
#import "WebpageParserDelegate.h"

@interface TagParser : NSObject<WebPageParserDelegate>

+(id)parserWithWebPageContent:(NSString *)content tagName:(NSString *)tagName;

@end
