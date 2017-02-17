//
//  ViewController.m
//  WebPageParser
//
//  Created by wpstarnice on 2016/11/26.
//  Copyright © 2017年 p All rights reserved.
//

#import "ViewController.h"
#import "TagParser.h"
#import "HTMLTagParser.h"
#import "XMLTagParser.h"

@interface ViewController ()

@property(nonatomic,copy)NSString *xmlContent;
@property(nonatomic,copy)NSString *htmlContent;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testXmlParser];
    
    [self testHtmlParser];
}

-(void)testXmlParser{

    NSArray *tagNames = @[@"head",@"body",@"para",@"text",@"image",@"source",@"styles",@"width",@"float",@"horizontal-line",@"color",@"align",@"attach",@"resource",@"filename"];
    
    [tagNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XMLTagParser *parser = [XMLTagParser parserWithWebPageContent:self.xmlContent tagName:obj];
        for (TagModel * tmp in parser.tags) {
            NSLog(@"<%@> value is :%@\n\n",tmp.tagName,tmp.tag);
        }
    }];
}

-(void)testHtmlParser{

    NSArray *tagNames = @[@"meta",@"img"];
    
    [tagNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HTMLTagParser *parser = [HTMLTagParser parserWithWebPageContent:self.htmlContent tagName:obj];
        
        
        [parser.tags enumerateObjectsUsingBlock:^(TagModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"<%@> value is :%@\n\n",tagNames[idx],obj.tag);
        }];
        
    }];
}

-(NSString *)xmlContent{
        
    static NSString* xmlStr = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSString *xmlFile = [[NSBundle mainBundle] pathForResource:@"xmldemo" ofType:@"xml"];
        xmlStr = [NSString stringWithContentsOfFile:xmlFile
                                           encoding:(NSUTF8StringEncoding)
                                              error:nil];
    });

    return xmlStr;
}

-(NSString *)htmlContent{
    
    static NSString* htmlStr = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"htmldemo" ofType:@"html"];
        htmlStr = [NSString stringWithContentsOfFile:htmlFile
                                           encoding:(NSUTF8StringEncoding)
                                              error:nil];
    });
    
    return htmlStr;
}

@end
