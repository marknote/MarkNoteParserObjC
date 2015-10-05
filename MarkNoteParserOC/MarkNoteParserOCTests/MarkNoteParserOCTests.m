//
//  MarkNoteParserOCTests.m
//  MarkNoteParserOCTests
//
//  Created by marknote on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MarkNoteParser.h"

#define let NSString*


@interface MarkNoteParserOCTests : XCTestCase
//- (void) htmlEquals:(NSString*) expected actual:(NSString*) actual;
@end

@implementation MarkNoteParserOCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

NSString* markdown(NSString* input){
    NSString* result = [MarkNoteParser toHtml:input];
    return result;
}

- (void) assertHtmlEauql:(NSString*) expected actual:(NSString*) actual {
    NSString* exp = [expected stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    
    NSString* act = [actual stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    //BOOL suceeded = [exp isEqualToString: act];
    XCTAssertEqualObjects(exp,act);
    //XCTAssertTrue(suceeded);
    //XCTAssertEqual(true, suceeded);
}











- (void) testHeading {
    [self assertHtmlEauql:@"<h1>Hello</h1>" actual:markdown(@"# Hello")];
     [self assertHtmlEauql:@"<h2>Hello</h2>" actual:markdown(@"## Hello")];
      [self assertHtmlEauql:@"<h3>Hello</h3>" actual:markdown(@"### Hello")];
       [self assertHtmlEauql:@"<h4>Hello</h4>" actual:markdown(@"#### Hello")];
        [self assertHtmlEauql:@"<h5>Hello</h5>" actual:markdown(@"##### Hello")];
         [self assertHtmlEauql:@"<h6>Hello</h6>" actual:markdown(@"###### Hello")];
}


- (void) testFencedCode {
    [self assertHtmlEauql:@"<pre class=\"prettyprint lang-swift\">println(&quot;Hello&quot;)\n</pre>\n" actual:markdown(@"```swift\nprintln(\"Hello\")\n```")];
}

- (void) testDefLinks {
    [self assertHtmlEauql:@"<p><a href=\"www.google.com\">Title</a><br/><br/></p>" actual: markdown(@"[Title][Google]\n [Google]:www.google.com\n")];
    [self assertHtmlEauql:@"<p><a href=\"www.google.com\" title=\"GoogleSearch\">text</a><br/><br/></p>" actual: markdown(@"[text][Google]\n[Google]:www.google.com \"GoogleSearch\"\n")];
}

- (void) testDefImages {
    [self assertHtmlEauql:@"<p><img src=\"aaa\" alt=\"Title\"/><br/><br/></p>"actual: markdown(@"![Title][image]\n [image]:aaa\n")];
    [self assertHtmlEauql:@"<p><img src=\"aaa\" alt=\"text\" title=\"TTTT\"/><br/><br/></p>" actual: markdown(@"![text][image]\n[image]:aaa \"TTTT\"\n")];
    [self assertHtmlEauql:@"<p><img src=\"https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png\" alt=\"alt text\" title=\"Logo Title Text\"/><br/></p>" actual: markdown(@"![alt text][logo]\n[logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png \"Logo Title Text\"")];
}



- (void) testInlineLinks {
    [self assertHtmlEauql:@"<p><a href=\"www.google.com\">Google</a></p>\n" actual:  markdown(@"[Google](www.google.com)")];
    [self assertHtmlEauql:@"<p><a href=\"www.google.com\" title=\"googlehome\">Google</a></p>\n" actual: markdown(@"[Google](www.google.com \"googlehome\")")];
    
}

- (void)testInlineImages {
    [self assertHtmlEauql:@"<p><img src=\"url\" alt=\"abc\" /></p>\n" actual:  markdown(@"![abc](url)")];
    
}

- (void) testInlineImages2 {
    [self assertHtmlEauql:@"<p>!<img src=\"url\" alt=\"abc\" /></p>\n" actual:  markdown(@"!![abc](url)")];
    
}
- (void) testHRule {
    [self assertHtmlEauql:@"<hr>\n" actual:markdown(@"-----")];
    [self assertHtmlEauql:@"<hr>\n" actual:markdown(@"***")];
    [self assertHtmlEauql:@"<hr>\n" actual:markdown(@"___")];
}
- (void) testLHeading {
    [self assertHtmlEauql:@"<h1>Hello</h1>\n" actual:markdown(@"Hello\n=====")];
    [self assertHtmlEauql:@"<h2>Hello</h2>\n" actual:markdown(@"Hello\n-----")];
}

- (void) testBlockQuote {
    [self assertHtmlEauql:@"<blockquote><h3>Hello</h3></blockquote>" actual:markdown(@">### Hello")];
}

- (void)testInlineCode {
    [self assertHtmlEauql:@"<p><code>Hello</code></p>\n" actual:markdown(@"`Hello`\n")];
}

- (void)testBlockCode {
    [self assertHtmlEauql:@"<pre class=\"no-highlight\">\nHello\n</pre>\n" actual:markdown(@"``` \r\nHello\r\n```\n")];
}

- (void) testDoubleEmphasis{
    [self assertHtmlEauql:@"<p><strong>Hello</strong></p>\n" actual:markdown(@"**Hello**")];
    [self assertHtmlEauql:@"<p><strong>World</strong></p>\n" actual:markdown(@"__World__")];
    [self assertHtmlEauql:@"<p><del>Hello</del></p>\n" actual:markdown(@"~~Hello~~")];
    
}
- (void) testDoubleEmphasis2 {
    [self assertHtmlEauql:@"<p>123<strong>Hello</strong>456</p>\n" actual:markdown(@"123**Hello**456")];
    [self assertHtmlEauql:@"<p>123<strong>World</strong>456</p>\n" actual:markdown(@"123__World__456")];
}

- (void)testEmphasis {
    [self assertHtmlEauql:@"<p><em>Hello</em></p>\n" actual:markdown(@"*Hello*")];
    [self assertHtmlEauql:@"<p><em>World</em></p>\n" actual:markdown(@"_World_")];
    [self assertHtmlEauql:@"<p>123<em>Hello</em>456</p>\n" actual:markdown(@"123*Hello*456")];
    [self assertHtmlEauql:@"<p>123<em>World</em>456</p>\n" actual:markdown(@"123_World_456")];
    [self assertHtmlEauql:@"<p>123<em>Hello</em>456123<em>world</em>456</p>\n" actual:markdown(@"123*Hello*456123*world*456")];
    [self assertHtmlEauql:@"<p>123<em>World</em>456123<em>world</em>456</p>\n" actual:markdown(@"123_World_456123*world*456")];
}

- (void) testBulletList
{
    let input = @"A bulleted list:\n- a\n- b\n- c\n";
    let expected = @"<p>A bulleted list:<br/><ul><li>a</li><li>b</li><li>c</li></ul></p>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}




- (void) testHTMLTag{
    
    let input = @"<a name=\"html\"/>";
    let expected = @"<a name=\"html\"/>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}

- (void) testMixedHTMLTag{
    
    let input = @"<a name=\"html\"/>\n## Inline HTML\nYou can also use raw HTML in your Markdown";
    let expected = @"<a name=\"html\"/><h2>Inline HTML</h2><p>You can also use raw HTML in your Markdown</p>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}

- (void) testHTMLTag2{
    
    let input = @"111<a href='abc'>123</a>222";
    let expected = @"<p>111</p><a href='abc'>123</a><p>222</p>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
 }
 

- (void) testEmbeddedHTML{
    let input = @"<span style='color:red;'>Don't modify this note. Your changes will be overrided.</span>";
    let expected = @"<span style='color:red;'>Don't modify this note. Your changes will be overrided.</span>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
    
}

- (void) testHTMLInCode{
    
    let input = @"```\n&lt;html&gt;\n```\n";
    let expected = @"<pre class=\"no-highlight\">&lt;html&gt;</pre>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}

- (void) testNewLine{
    
    let input = @"abc  \n123";
    let expected = @"<p>abc<br/>123</p>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}




- (void) testTable{
    
    let input = @"|a|b|c|\n|------|-----|-----|\n|1|2|3|\n\n\n";
    let expected = @"<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>";
    let actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}

- (void) testTableWithoutOuterPipe{
    
    NSString* input = @"a|b|c\n------|-----|-----\n1|2|3\n\n\n";
    NSString* expected = @"<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>";
    NSString* actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}

- (void) testTableWithColumnAignment{
    
    NSString* input = @"a|b|c\n------|:-----:|-----:\n1|2|3\n\n\n";
    NSString* expected = @"<table><tr><th>a</th><th style=\"text-align: center;\">b</th><th style=\"text-align: right;\">c</th></tr><tr><td>1</td><td style=\"text-align: center;\">2</td><td style=\"text-align: right;\">3</td></tr></table>";
    NSString* actual = markdown(input);
    [self assertHtmlEauql:expected actual:actual];
}





- (void) testDetectPositions {
    NSArray<NSNumber*>* expected = @[[NSNumber numberWithInt: 1],
                                     [NSNumber numberWithInt: 2],
                                     [NSNumber numberWithInt: 3]];
    NSArray<NSNumber*>* actual = [MarkNoteParser detectPositions:@[@"1",@"2",@"3"] inStr:@"0123"];
    XCTAssertEqualObjects(expected, actual);
    
}

- (void)testDetectPositions2{
    
    NSArray<NSNumber*>* expected = @[[NSNumber numberWithInt: 2],
                                     [NSNumber numberWithInt: 4],
                                     [NSNumber numberWithInt: 5]];
    NSArray<NSNumber*>* actual = [MarkNoteParser detectPositions:@[@"2",@"4",@"5"] inStr:@"012345"];
    XCTAssertEqualObjects(expected, actual);
    
    
}





@end
