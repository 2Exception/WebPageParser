## WebPageParser
A delightful  xml and html parsing relish for iOS

####How to use
For parsing html, we can use:
```objc
NSString *webFile = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"xml"];
NSString *webStr = [NSString stringWithContentsOfFile:webFile
                                           encoding:(NSUTF8StringEncoding)
                                              error:nil];
HTMLTagParser *parser = [HTMLTagParser parserWithWebPageContent:webStr tagName:obj];
```
Or If needing parsing xml, we can use the method:
```objc
XMLTagParser *parser = [XMLTagParser parserWithWebPageContent:self.xmlContent tagName:obj];
```
In addition, if we could't know the type of webpage is html or xml,we can use
```objc
TagParser *parser = [TagParser parserWithWebPageContent:self.xmlContent tagName:obj];
```
####The Third Dependency 
RegExCategories
