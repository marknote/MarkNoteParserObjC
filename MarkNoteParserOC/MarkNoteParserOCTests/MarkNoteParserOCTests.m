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
- (void) htmlEquals:(NSString*) expected actual:(NSString*) actual;
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

- (void) htmlEquals:(NSString*) expected actual:(NSString*) actual {
    XCTAssertEqualObjects(expected,actual);
}

void assertHtmlEauql(NSString* expected,NSString* actual){
    NSString* exp = [expected stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    
    NSString* act = [actual stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    MarkNoteParserOCTests* test = [MarkNoteParserOCTests new];
    [test htmlEquals:exp actual:act];
 
    

}









- (void) testHeading {
    assertHtmlEauql(@"<h1>Hello</h1>", markdown(@"# Hello"));
    assertHtmlEauql(@"<h2>Hello</h2>", markdown(@"## Hello"));
    assertHtmlEauql(@"<h3>Hello</h3>", markdown(@"### Hello"));
    assertHtmlEauql(@"<h4>Hello</h4>", markdown(@"#### Hello"));
    assertHtmlEauql(@"<h5>Hello</h5>", markdown(@"##### Hello"));
    assertHtmlEauql(@"<h6>Hello</h6>", markdown(@"###### Hello"));
}


- (void) testFencedCode {
    assertHtmlEauql(@"<pre class=\"prettyprint lang-swift\">println(&quot;Hello&quot;)\n</pre>\n", markdown(@"```swift\nprintln(\"Hello\")\n```"));
}

- (void) testDefLinks {
    assertHtmlEauql(@"<p><a href=\"www.google.com\">Title</a><br/><br/></p>", markdown(@"[Title][Google]\n [Google]:www.google.com\n"));
    assertHtmlEauql(@"<p><a href=\"www.google.com\" title=\"GoogleSearch\">text</a><br/><br/></p>", markdown(@"[text][Google]\n[Google]:www.google.com \"GoogleSearch\"\n"));
}

- (void) testDefImages {
    assertHtmlEauql(@"<p><img src=\"aaa\" alt=\"Title\"/><br/><br/></p>", markdown(@"![Title][image]\n [image]:aaa\n"));
    assertHtmlEauql(@"<p><img src=\"aaa\" alt=\"text\" title=\"TTTT\"/><br/><br/></p>", markdown(@"![text][image]\n[image]:aaa \"TTTT\"\n"));
    assertHtmlEauql(@"<p><img src=\"https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png\" alt=\"alt text\" title=\"Logo Title Text\"/><br/></p>", markdown(@"![alt text][logo]\n[logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png \"Logo Title Text\""));
}



- (void) testInlineLinks {
    assertHtmlEauql(@"<p><a href=\"www.google.com\">Google</a></p>\n", markdown(@"[Google](www.google.com)"));
    assertHtmlEauql(@"<p><a href=\"www.google.com\" title=\"googlehome\">Google</a></p>\n", markdown(@"[Google](www.google.com \"googlehome\")"));
    
}

- (void)testInlineImages {
    assertHtmlEauql(@"<p><img src=\"url\" alt=\"abc\" /></p>\n", markdown(@"![abc](url)"));
    
}

- (void) testInlineImages2 {
    assertHtmlEauql(@"<p>!<img src=\"url\" alt=\"abc\" /></p>\n", markdown(@"!![abc](url)"));
    
}
- (void) testHRule {
    assertHtmlEauql(@"<hr>\n", markdown(@"-----"));
    assertHtmlEauql(@"<hr>\n", markdown(@"***"));
    assertHtmlEauql(@"<hr>\n", markdown(@"___"));
}
- (void) testLHeading {
    assertHtmlEauql(@"<h1>Hello</h1>\n", markdown(@"Hello\n====="));
    assertHtmlEauql(@"<h2>Hello</h2>\n", markdown(@"Hello\n-----"));
}

- (void) testBlockQuote {
    assertHtmlEauql(@"<blockquote><h3>Hello</h3></blockquote>", markdown(@">### Hello"));
}

- (void)testInlineCode {
    assertHtmlEauql(@"<p><code>Hello</code></p>\n", markdown(@"`Hello`\n"));
}

- (void)testBlockCode {
    assertHtmlEauql(@"<pre class=\"no-highlight\">\nHello\n</pre>\n", markdown(@"``` \r\nHello\r\n```\n"));
}

- (void) testDoubleEmphasis{
    assertHtmlEauql(@"<p><strong>Hello</strong></p>\n", markdown(@"**Hello**"));
    assertHtmlEauql(@"<p><strong>World</strong></p>\n", markdown(@"__World__"));
    assertHtmlEauql(@"<p><del>Hello</del></p>\n", markdown(@"~~Hello~~"));
    
}
- (void) testDoubleEmphasis2 {
    assertHtmlEauql(@"<p>123<strong>Hello</strong>456</p>\n", markdown(@"123**Hello**456"));
    assertHtmlEauql(@"<p>123<strong>World</strong>456</p>\n", markdown(@"123__World__456"));
}

- (void)testEmphasis {
    assertHtmlEauql("<p><em>Hello</em></p>\n", markdown("*Hello*"), "Emphasis Asterisk Pass")
    assertHtmlEauql("<p><em>World</em></p>\n", markdown("_World_"), "Emphasis Underscope Pass")
    assertHtmlEauql("<p>123<em>Hello</em>456</p>\n", markdown("123*Hello*456"), "Emphasis Asterisk Pass")
    assertHtmlEauql("<p>123<em>World</em>456</p>\n", markdown("123_World_456"), "Emphasis Underscope Pass")
    assertHtmlEauql("<p>123<em>Hello</em>456123<em>world</em>456</p>\n", markdown("123*Hello*456123*world*456"), "Emphasis Asterisk Pass")
    assertHtmlEauql("<p>123<em>World</em>456123<em>world</em>456</p>\n", markdown("123_World_456123*world*456"), "Emphasis Underscope Pass")
}

- (void) testBulletList
{
    let input = "A bulleted list:\n- a\n- b\n- c\n"
    let expected = "<p>A bulleted list:<br/><ul><li>a</li><li>b</li><li>c</li></ul></p>"
    let actual = markdown(input).stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    assertHtmlEauql(expected, actual)
}




- (void) testHTMLTag{
    
    let input = "<a name=\"html\"/>"
    let expected = "<a name=\"html\"/>"
    let actual = markdown(input).stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    assertHtmlEauql(expected, actual)
}

- (void) testMixedHTMLTag{
    
    let input = "<a name=\"html\"/>\n## Inline HTML\nYou can also use raw HTML in your Markdown"
    let expected = "<a name=\"html\"/><h2>Inline HTML</h2><p>You can also use raw HTML in your Markdown</p>"
    let actual = markdown(input).stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    assertHtmlEauql(expected, actual)
}

- (void) testHTMLTag2{
    
    let input = "111<a href='abc'>123</a>222"
    let expected = "<p>111</p><a href='abc'>123</a><p>222</p>"
    let actual = markdown(input).stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    assertHtmlEauql(expected, actual)
 }
 

- (void) testEmbeddedHTML{
    let input = @"<span style='color:red'>Don't modify this note. Your changes will be overrided.</span>";
    let expected = @"<span style='color:red'>Don't modify this note. Your changes will be overrided.</span>";
    let actual = markdown(input);
    assertHtmlEauql(expected, actual);
    
}

- (void) testHTMLInCode{
    
    let input = @"```\n&lt;html&gt;\n```\n";
    let expected = @"<pre class=\"no-highlight\">&lt;html&gt;</pre>";
    let actual = markdown(input);
    assertHtmlEauql(expected, actual);
}

- (void) testNewLine{
    
    let input = @"abc  \n123";
    let expected = @"<p>abc<br/>123</p>";
    let actual = markdown(input);
    assertHtmlEauql(expected, actual);
}




- (void) testTable{
    
    let input = @"|a|b|c|\n|------|-----|-----|\n|1|2|3|\n\n\n";
    let expected = @"<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>";
    let actual = markdown(input);
    assertHtmlEauql(expected, actual);
}

- (void) testTableWithoutOuterPipe{
    
    NSString* input = @"a|b|c\n------|-----|-----\n1|2|3\n\n\n";
    NSString* expected = @"<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>";
    NSString* actual = markdown(input);
    assertHtmlEauql(expected, actual);
}

- (void) testTableWithColumnAignment{
    
    NSString* input = @"a|b|c\n------|:-----:|-----:\n1|2|3\n\n\n";
    NSString* expected = @"<table><tr><th>a</th><th style=\"text-align: center;\">b</th><th style=\"text-align: right;\">c</th></tr><tr><td>1</td><td style=\"text-align: center;\">2</td><td style=\"text-align: right;\">3</td></tr></table>";
    NSString* actual = markdown(input);
    assertHtmlEauql(expected, actual);
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
