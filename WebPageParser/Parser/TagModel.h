//
//  TagModel.h
//  WebPageParser
//
//  Created by wpstarnice on 2016/12/17.
//  Copyright © 2017年 p All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum WebPageType {
    WebPageTypeHtml,
    WebPageTypeXml
} WebPageType;

@interface TagModel : NSObject

/*tag content*/
@property (nonatomic, copy)NSString *tag;

/*tag name*/
@property (nonatomic, copy)NSString *tagName;

@property (nonatomic, assign)WebPageType type;

+ (TagModel *)initWithTag:(NSString *)tag type:(WebPageType)type;

+ (TagModel *)initWithTag:(NSString *)tag type:(WebPageType)type tagName:(NSString *)tagName;

/**
 no matter xml or html ,this method always return right content

 @param name tag name

 @return tag value
 */
- (NSString *)attributeValueForName:(NSString *)name;

/**
 this method is used based on known xml format
 
 @param name tag name
 
 @return tag value
 */
- (NSString *)elementValueForName:(NSString *)name;

/**
 no matter xml or html ,this method always set value for name pair by itself
 
 @param value tag value
 @param name  tag name
 
 */
- (void)setAttributeValue:(NSString *)value forName:(NSString *)name;

/**
 this method sets value for name based on known xml format
 
 @param value tag value
 @param name  tag name
 */
- (void)setElementValue:(NSString *)value forName:(NSString *)name;

/**
 no matter xml or html ,this method always remove attribute by itself
 
 @param name  tag name
 
 */
- (void)removeAttribute:(NSString *)name;

/**
 this method sets value for name based on known xml format
 
 @param name tag name
 
**/
- (void)removeElement:(NSString *)name;

@end
