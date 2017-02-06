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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tagNames = @[@"head",@"body",@"para",@"text",@"image",@"source",@"styles",@"width",@"float",@"horizontal-line",@"color",@"align",@"attach",@"resource",@"filename"];
    
    [tagNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
        XMLTagParser *parser = [XMLTagParser parserWithWebPageContent:self.xmlContent tagName:obj];
        for (TagModel * tmp in parser.tags) {
            NSLog(@"<%@> value is :%@\n\n",tmp.tagName,tmp.tag);
        }
    }];
}

-(NSString *)xmlContent{
        
    static NSString* xmlStr = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSString *xmlFile = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"xml"];
        xmlStr = [NSString stringWithContentsOfFile:xmlFile
                                           encoding:(NSUTF8StringEncoding)
                                              error:nil];
    });

    return xmlStr;
}

@end
