//
//  MarkNoteParser.m
//  MarkNoteParserOC
//
//  Created by marknote on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import "MarkNoteParser.h"
#import "NSString+Addition.h"

const unichar headerChar = '#';





@implementation MarkNoteParser
@synthesize outputString = _output;

-(id) init{
    self = [super init];
    
    bInTable = false;
    _output = [NSMutableString stringWithCapacity:0];
    isInParagraph = false;
    isAfterEmptyLine = false;
    tableColsAlignment = [NSMutableArray array];
    blockEndTags = [NSMutableArray array];
    isCurrentLineNeedBr = false;
    arrReferenceInfo = [NSMutableArray array];
    arrReferenceUsage = [NSMutableArray array];
    return self;
}

//var nOldBulletLevel = 0
/*var nCurrentBulletLevel = 0



*/

+(NSString*) toHtml:(NSString*)input{
    MarkNoteParser* instance = [[MarkNoteParser alloc]init];
    //instance.output = ""
    [instance parse:input];
    return instance.outputString;
}


-(void) parse :(NSString*)input{
    //[self proceedHTMLTags:input];
    [ self proceedCodeBlock:input];
    [self proceedReference];
}


-(void) proceedReference{
    for (ReferenceUsageInfo* refer in arrReferenceUsage) {
        NSPredicate *predicte = [NSPredicate predicateWithFormat:
                                 @"key like [c] %@", refer.key.lowercaseString];
        NSArray* hitted = [arrReferenceInfo filteredArrayUsingPredicate:predicte];
        if (hitted.count > 0) {
            ReferenceDefinition* found = hitted[0];
            NSString* actual = @"";
            switch (refer.type) {
            case Link:
                if (found.url.title.length > 0) {
                    actual = [NSString stringWithFormat: @"<a href=\"%@\" title=\"%@\">%@</a>",found.url.url,found.url.title,refer.title];
                } else {
                    actual = [NSString stringWithFormat: @"<a href=\"%@\">%@</a>",found.url.url,refer.title];
                   
                }
                    break;
            case Image:
                if (found.url.title.length > 0){
                    actual = [NSString stringWithFormat: @"<img src=\"%@\" alt=\"%@\" title=\"%@\"/>",found.url.url,refer.title,found.url.title];
                    
                    
                } else {
                    actual = [NSString stringWithFormat: @"<img src=\"%@\" alt=\"%@\"/>",found.url.url,refer.title];
                  
                }
                    break;
            }
            _output = [NSMutableString stringWithString:  [_output stringByReplacingOccurrencesOfString:[refer placeHolder] withString:actual]];
            
        }
    }
}

-(void) proceedCodeBlock:(NSString*)string{
   
    //NSString* preProceeded = [input stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    //preProceeded = [preProceeded stringByReplacingOccurrencesOfString:@"\n" withString:@"  \n"];
    
    //NSArray<NSString*>* lines = [preProceeded componentsSeparatedByString:@"\n" ];
    //BOOL isInCodeBlock = false;
    
    //NSMutableString *nonCodeblockString = [[NSMutableString alloc] init];
    
    //for rawline in lines {
    //NSUInteger pos = [input indexOf:@"\n```"];
    int blockCount = 0;
    NSRange searchRange = NSMakeRange(0,string.length);
    NSString *codeTag = @"```";
    NSRange foundRange;
    NSRange proceedRange;
    while (searchRange.location < string.length) {
        searchRange.length = string.length - searchRange.location;
        foundRange = [string rangeOfString:codeTag options:NSLiteralSearch range:searchRange];
        if (foundRange.location != NSNotFound) {
            blockCount ++;
            // found an occurrence of the substring! do stuff here
            proceedRange = NSMakeRange(searchRange.location , foundRange.location - searchRange.location);
            
            //isInCodeBlock = !isInCodeBlock; // code block flag
            searchRange.location = foundRange.location + foundRange.length;
            
        } else {
            // no more substring to find
            //break;
            proceedRange = searchRange;//NSMakeRange(searchRange.location, foundRange.location);
        }
        //if (proceedRange.length == 0) continue;
        //NSString* stringBeforeTag =  [string substringWithRange:proceedRange];
        
        
        // proceed contents before code
        if (blockCount % 2 == 1) { // code block just begins
            if(proceedRange.length >0 ){
                [self proceedHTMLTags:[string substringWithRange:proceedRange]];
            }
            NSString* cssClass = @"no-highlight";
            
            if(searchRange.location < string.length) {
                NSRange rangeOfNewLine = [string rangeOfString:@"\n" options:NSLiteralSearch range:
                                         NSMakeRange(searchRange.location, string.length - searchRange.location) ] ;//[[string substringWithRange:searchRange] rangeOfString: @"\n"];
                if (rangeOfNewLine.location != NSNotFound) {
                    NSRange cssRange = NSMakeRange(searchRange.location , rangeOfNewLine.location - searchRange.location );
                    searchRange.location += cssRange.length;
                    NSString *codeName = [[string substringWithRange:cssRange] trim];
                    if (codeName.length>0) {
                        cssClass = [NSString stringWithFormat:  @"prettyprint lang-%@",codeName];
                    }
                    
                }
            }
            
            [_output appendFormat:@"<pre class=\"%@\">\n",cssClass];
        } else { // code block ends
            if (blockCount > 0 && foundRange.location != NSNotFound) {
                
                if(proceedRange.length >0 ){
                    [_output appendString:[string substringWithRange:proceedRange]];
                }
                
                [_output appendString:@"</pre>\n"];
            } else {
                if(proceedRange.length >0 ){
                    [self proceedHTMLTags:[string substringWithRange:proceedRange]];
                }
            }
        }
        
        if (foundRange.location == NSNotFound) {
            break;
        }

    }
    
    
    /*for (int i = 0; i < lines.count; i++){
        NSString* line = lines[i];
        
        if  ([line indexOf:@"```"] == 0) {
            isInCodeBlock = !isInCodeBlock; // code block flag
            
            
            if (isInCodeBlock) {
                [self proceedHTMLTags:nonCodeblockString];
                [nonCodeblockString setString:@""];

                NSString* cssClass = @"no-highlight";
                line = [line trim];
                if (line.length > @"```".length) {
                    //prettyprint javascript prettyprinted
                    NSString* remaining = [line substringFromIndex:@"```".length];
                    cssClass = [NSString stringWithFormat:  @"prettyprint lang-%@",remaining];
                }
                [output appendFormat:@"<pre class=\"%@\">\n",cssClass];
                continue; // ignor current line
            } else {
                [output appendString:@"</pre>\n"];
            }
        }else {
            if (isInCodeBlock) {
                // current line is code
                [output appendFormat:@"%@\n",line];
            } else {
                // current line is not in code block, put into stack directly
                
                [nonCodeblockString appendFormat:@"%@  \n",line];
            }
        }
    }
    
    [self proceedHTMLTags:nonCodeblockString];
    [nonCodeblockString setString:@""];*/


}

-(void) proceedHTMLTags:(NSString*)input{
    NSUInteger currentPos = 0;
    NSUInteger tagBegin = [input indexOf:@"<"];
    if (tagBegin !=NSNotFound) {
        if (tagBegin >= 1) {
            NSString* tmp = [input substringWithRange:NSMakeRange(currentPos, tagBegin  - currentPos)];
            [self proceedNoHtml:tmp];
            
        }
        //currentPos = tagBegin
        if (tagBegin < input.length - 1) {
            NSString* left = [input substringWithRange:NSMakeRange(tagBegin, input.length  - tagBegin)];
          
            NSUInteger endTag = [left indexOf:@">"];
            if (endTag != NSNotFound) {
                // found
                if ([left characterAtIndex: endTag - 1] == '/') {
                    //auto close: <XXX />
                    [_output appendString: [left substringToIndex: endTag + 1]];
                    if (endTag < left.length - 2 ){
                        [self proceedHTMLTags:[left substringFromIndex: endTag + 1 ]];
                    }
                } else {
                    // there is a close tag
                    currentPos = endTag;
                    if (endTag <= left.length - 1) {
                        left = [left substringFromIndex: endTag + 1 ];
                        endTag = [left indexOf:@">"];
                        if (endTag !=NSNotFound ){
                            [_output appendString:[ input substringWithRange:NSMakeRange(tagBegin, endTag + currentPos + 2)]];
                                                  //substring(tagBegin, end: tagBegin + endTag + currentPos + 1) //+
                            if (endTag < left.length - 1) {
                                left = [left substringFromIndex:endTag + 1 ];
                                //.substringFromIndex(left.startIndex.advancedBy( endTag + 1 ))
                                [self proceedHTMLTags:left];
                                return;
                            }
                        } else {
                            [self proceedNoHtml:input];
                            return;
                        }
                    } else {
                        [_output appendString: input];
                        return;
                    }
                }
            }else {
                // not found
                [self proceedNoHtml:left];
            }
        }
    }else {
        [self proceedNoHtml:input];
    }
}
-(void) proceedNoHtml:(NSString*)input{
    
    //NSArray<NSString*>* lines = [input componentsSeparatedByString:@"\n" ];
    NSString* preProceeded = [input stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    preProceeded = [preProceeded stringByReplacingOccurrencesOfString:@"\n" withString:@"  \n"];
    
    NSArray<NSString*>* lines = [preProceeded componentsSeparatedByString:@"\n" ];
    //for rawline in lines {
    for (int i = 0; i < lines.count; i++){
        isCurrentLineNeedBr = true;
        
        NSString* line = [lines[i] trim];
        
      
        if (bInTable && line.length > 0) {
            [self handleTableLine:line isHead:false];
        } else {
            // not in block
            if  (line.length == 0) {
                // empty line
                [self closeTags];
                [self closeParagraph];
                [self closeTable];
                isAfterEmptyLine = true;
                isCurrentLineNeedBr = false;
                continue;
            }else {
                isAfterEmptyLine = false;
            }
            
            if ([line indexOf:@"- "] == 0
                || [line indexOf:@"* "] == 0
                || [line indexOf:@"+ "] == 0 ){
                    if (nCurrentBulletLevel == 0 ){
                        [_output  appendString:@"<ul>\n"];
                        [blockEndTags addObject:@"</ul>\n"];
                        nCurrentBulletLevel = 1;
                        isCurrentLineNeedBr = false;
                        
                    }
                    [_output appendString:@"<li>"];
                NSString* newline = [line substringWithRange:NSMakeRange(@"- ".length, line.length - @"- ".length)];
                //.substring("- ".length, end: line.length - 1)
                [self handleLine:newline];
                [_output appendString:@"</li>\n"];
                continue;
                } else {
                    if (nCurrentBulletLevel > 0) {
                        nCurrentBulletLevel = 0;
                        [_output appendString:@"</ul>\n"];
                    }
                }
            
         
            
            if (i + 1 <= lines.count - 1) {
                NSString* nextLine = [lines[i + 1] trim];
                if ([nextLine contains3PlusandOnlyChars:@"="]){
                    [_output appendFormat: @"<h1>%@</h1>\n",line ];
                    i++;
                    continue;
                } else if ([nextLine contains3PlusandOnlyChars:@"-"]){
                    [_output appendFormat: @"<h2>%@</h2>\n",line ];
                    i++;
                    continue;
                } else if ( [nextLine indexOf:@"|"] != NSNotFound
                           && [line indexOf:@"|"] != NSNotFound
                           && [[[[nextLine stringByReplacingOccurrencesOfString:@"|" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""]
                                stringByReplacingOccurrencesOfString:@":" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""].length ==0 )
                           
                    
                {
                    
                    [self beginTable:nextLine];
                    [self handleTableLine:line isHead:true];
                    i++;
                    continue;
                }
            }
            
            
            [self handleLine:line];
            if  (isCurrentLineNeedBr
                && lines.count > 1
                && lines[i].length > 2
                
                && [[lines[i] substringFromIndex:lines[i].length - 2] isEqualToString:@"  "] ){
                    [_output appendString:@"<br/>"];
                }
            
            //output += "</p>"
        }
    }//end for
    [self closeTags];
    [self closeParagraph];
    
}





-(void) parseInLine:(NSString*)line {
    int len = (int)line.length;
    //int start = 0;
    for (int i = 0; i < len && i>=0 ; i++) {
        
        unichar ch = [line characterAtIndex:i];
        
        switch (ch) {
        case '*':
        case '_':
        case '~':
            {
                if (i + 1 > len - 1) {
                    [_output appendFormat:@"%c", ch];
                    return;
                }
                NSString* strong = @"strong";
                if (ch == '~') {
                    strong = @"del";
                }
                if ([line characterAtIndex:i + 1] == ch) {
                    //possible **
                    NSString* remaining = [line substringFromIndex:  i + 2];
                    i += [self scanClosedChar: [MarkNoteParser charArray:ch len: 2]
                                        inStr: remaining
                                          tag: strong] + 1;
                } else {
                    NSString* remaining = [line substringFromIndex:  i + 1];
                    i += [self scanClosedChar: [NSString stringWithFormat:@"%c",ch ]
                                        inStr:remaining
                                          tag: @"em"] ;
                }
            }
            break;
        case '`':
            {NSString* remaining = [line substringFromIndex:  i + 1];
                i += [self scanClosedChar:@"`"
                                    inStr: remaining
                                      tag: @"code"];
                isCurrentLineNeedBr = false;}
                break;
            
        case '!':
            {
                
                if (i >= line.length - 1 || [line characterAtIndex: i + 1] != '[') {
                    
                    [_output appendFormat:@"%c", ch];
                    continue;
                }
                i++;
                NSString* remaining = [line substringFromIndex:  i + 1];
                NSArray<NSNumber*>* posArray = [MarkNoteParser detectPositions:@[@"]",@"(",@")"] inStr: remaining];
                if (posArray.count == 3) {
                    ImageTag* img = [[ImageTag alloc] init];
                    img.alt = [line substringWithRange:NSMakeRange(i + 1,  posArray[0].intValue  )];
                    URLTag* urlTag = [[URLTag alloc]init];
                    urlTag.url = [line substringWithRange:NSMakeRange(i + 1 + posArray[1].intValue + 1,    posArray[2].intValue - posArray[1].intValue -1)];
                    //line.substring( i + 1 + posArray[1] + 1, end: i + 1 + posArray[2] - 1)
                    img.url = urlTag;
                    [_output appendString: [img toHtml]];
                    i +=  posArray[2].intValue + 1;
                }else {
                    // check image reference defintion
                    NSArray<NSNumber*>* posArray2 = [MarkNoteParser detectPositions:@[@"]",@"[",@"]"]
                                                                              inStr: remaining];
                    if (posArray2.count == 3) {
                        //is reference usage
                        NSString* title = [line substringWithRange:NSMakeRange(i + 1, posArray2[0].intValue)];
                        
                        NSString* url = [line substringWithRange:NSMakeRange(i + 1 + posArray2[1].intValue + 1, posArray2[2].intValue - posArray2[1].intValue -1)];
                        //.substring( i + 1 + posArray2[1] + 1, end: i + 1 + posArray2[2] - 1)
                        ReferenceUsageInfo* refer = [[ReferenceUsageInfo alloc] init];
                        refer.type = Image;
                        refer.key = url.lowercaseString;
                        refer.title = title;
                        [arrReferenceUsage addObject:refer];
                        
                        [_output appendString:  [refer placeHolder]];
                        i += posArray2[2].intValue + 1 + 1;
                    }
                }
            }
                break;
            
        case '[':
            {
            NSString* remaining = [line substringFromIndex: i + 1];
            NSArray<NSNumber*>* posArray = [MarkNoteParser detectPositions:@[@"]",@"(",@")"]
                                                                     inStr: remaining];
            if (posArray.count == 3) {
                LinkTag* link = [[LinkTag alloc] init];
                link.text = [line substringWithRange:NSMakeRange(i + 1, posArray[0].intValue) ];
                //.substring(i + 1, end: i + 1 + posArray[0] - 1)
                NSString* surl = [line substringWithRange: NSMakeRange(i + 1 + posArray[1].intValue + 1, posArray[2].intValue - posArray[1].intValue - 1 )];
                URLTag* urlTag = [[URLTag alloc] initWithString:surl];
                
                link.url =  urlTag;
                [_output appendString: [link toHtml] ];
                i +=  posArray[2].intValue + 1;
            }else {
                // check reference defintion
                NSUInteger pos = [remaining indexOf:@"]:"];
                if (pos != NSNotFound && pos < remaining.length - @"]:".length) {
                    // is reference definition
                    ReferenceDefinition* info = [ReferenceDefinition new];
                    info.key = [remaining substringToIndex:pos];
                    //.substringToIndex(remaining.startIndex.advancedBy( pos ))
                    NSString* remaining2 = [remaining substringFromIndex: pos + @"]:".length ];
                    URLTag* urlTag = [[URLTag alloc] initWithString:remaining2];
                    info.url = urlTag;
               
                    [arrReferenceInfo addObject:info];
                    i += pos + @"]:".length + remaining2.length;
                } else {
                    NSArray<NSNumber*>* posArray2 = [MarkNoteParser detectPositions:@[@"]",@"[",@"]"]
                                                                              inStr: remaining];
                    if (posArray2.count == 3) {
                        //is reference usage
                        NSString* title = [line substringWithRange:NSMakeRange(i + 1, posArray2[0].intValue)];
                       
                        NSString* url = [line substringWithRange:NSMakeRange(i + 1 + posArray2[1].intValue + 1, posArray2[2].intValue - posArray2[1].intValue -1 )];
                        
                        ReferenceUsageInfo* refer = [ReferenceUsageInfo new];
                        refer.type = Link;
                        refer.key = url.lowercaseString;
                        refer.title = title;
                        [arrReferenceUsage addObject: refer];
                        [_output appendString: [refer placeHolder]];
                        i +=  pos + posArray2[2].intValue + 1 + 1;
                    }
                }
            }
            }
                break;
        case '\"':
            [_output appendString:@"&quot;"];
                break;
        default:
            //do nothing
            [_output appendFormat:@"%C", ch];
        }
    }
}


-(void) handleLine:(NSString*)rawline {
    
    if ([rawline contains3PlusandOnlyChars:@"-"]
        || [rawline contains3PlusandOnlyChars:@"*"]
        || [rawline contains3PlusandOnlyChars:@"_"]){
        [self closeParagraph];
            [_output appendString:@"<hr>\n"];
        return;
    }
    NSString* line = rawline;
    NSMutableArray* endTags = [NSMutableArray array];
    
    int pos = 0;
    
    if ([line characterAtIndex:0] == '>') {
        [_output appendString:@"<blockquote>"];
        line = [line substringFromIndex:1];
        [endTags addObject:@"</blockquote>"];
    }
    
    int nFindHead = [self calculateHeadLevel:line];
    if (nFindHead > 0) {
        isCurrentLineNeedBr = false;
        
        [_output appendFormat:@"<h%d>",nFindHead];
        [endTags addObject: [NSString stringWithFormat: @"</h%d>",nFindHead]];
        pos += nFindHead;
    } else {
        [self beginParagraph];
    }
    
    //line = this.handleImage(line, sb)
    
    NSString* remaining = [[line substringFromIndex:pos] trim];
    [self parseInLine:remaining];
    //output += "\n"
    
    for (int i = (int)(endTags.count) - 1; i >= 0; i--) {
        [_output appendString: endTags[i]];
    }
    
    //output += "\n"
    
}


-(void) handleTableLine:(NSString*)rawline isHead:(BOOL)isHead {
    if ([rawline characterAtIndex:rawline.length-1] == '|'){
        rawline = [rawline substringToIndex:rawline.length-1];
    }
    if ([rawline characterAtIndex:0] == '|'){
        rawline = [rawline substringFromIndex:1];
    }
    NSArray* cols = [rawline  componentsSeparatedByString:@"|"];
    
    [_output appendString:@"<tr>"];
    int i = 0;
    
    for(NSString* col in cols) {
        NSString* colAlign = tableColsAlignment[i];
        
        if (isHead) {
            NSString* colAlighStr = [NSString stringWithFormat:@"<th %@>",colAlign ];
            [_output appendString: colAlign.length > 0 ? colAlighStr : @"<th>"];
            [self parseInLine:col];
            [_output appendString:@"</th>"];
        } else {
            NSString* colAlighStr = [NSString stringWithFormat:@"<td %@>",colAlign ];
            [_output appendString:colAlign.length > 0 ? colAlighStr : @"<td>"];
            [self parseInLine:col];

            [_output appendString:@"</td>"];
        }
        i++;
    }
    [_output appendString:@"</tr>"];
}

-(void) beginTable:(NSString*)alignmentLine{
    if (!bInTable ){
        bInTable = true;
        [_output appendString:@"<table>"];
        [tableColsAlignment removeAllObjects];
        NSArray<NSString *> * arr = [[alignmentLine trim] componentsSeparatedByString:@"|"];
        for (NSString* col in arr) {
            if ([col indexOf:@":-"] != NSNotFound && [col indexOf:@"-:"] != NSNotFound  ){
                [tableColsAlignment addObject:@"style=\"text-align: center;\""];
            }else if ([col indexOf:@"-:"] != NSNotFound){
                [tableColsAlignment addObject:@"style=\"text-align: right;\""];
            }else {
                [tableColsAlignment addObject:@"" ];
            }
        }
    }
}


-(int) calculateHeadLevel:(NSString*)line{
    int nFindHead = 0;
    //int pos = 0;
    for (int i = 0; i <= 6 && i < [line length]; i++ ){
        //pos = i ;
        if ([line characterAtIndex:i]== headerChar)  {
            nFindHead = i + 1;
        } else {
            break;
        }
    }
    return nFindHead;
}

-(void) closeTags{
    for (int i = (int)blockEndTags.count - 1; i >= 0; i--) {
        [_output appendString: blockEndTags[i]];
        //blockEndTags.removeAtIndex(i)
    }
    //blockEndTags.removeAll(keepCapacity: false)
    [blockEndTags removeAllObjects];
}

-(void) closeParagraph{
    if (isInParagraph) {
        isInParagraph = false;
        [_output appendString: @"</p>\n"];
    }
}

-(void) beginParagraph{
    if (!isInParagraph) {
        isInParagraph = true;
        [_output appendString: @"<p>"];
    }
}


-(void) closeTable{
    if (bInTable) {
        bInTable = false;
        [_output appendString: @"</table>"];
    }
}

-(NSUInteger)  scanClosedChar:(NSString*)ch inStr:(NSString*)inStr tag:(NSString*)tag {
    NSUInteger pos = [inStr indexOf:ch];
    if (pos != NSNotFound) {
        NSString* temp = [inStr substringToIndex:pos];
        [_output appendFormat:@"<%@>%@</%@>",
         tag,
         temp,
         tag];
        return pos + ch.length;
    } else {
        [_output appendString:ch];
        return ch.length - 1;
    }
    
}


+(NSString*)  charArray:(unichar)ch len:(int)len{
    NSMutableString* sb = [[NSMutableString alloc] init];
    for (int i = 0 ; i < len ; i++) {
        [sb appendFormat:@"%c",ch];
    }
    NSString* result = [NSString stringWithString:sb];
    [sb setString: @""];
    return result;
}

+(NSArray<NSNumber*>*)detectPositions:(NSArray<NSString *> *)toFind inStr:(NSString* )inStr{
    NSMutableArray<NSNumber*>* posArray = [NSMutableArray array];// [Int]()
    NSUInteger count = toFind.count;
    int lastPos = 0;
    for (int i = 0; i < count ; i++){
        NSUInteger pos = [[inStr substringFromIndex:lastPos] indexOf:toFind[i]];
        
        if (pos != NSNotFound) {
            lastPos += pos;
            [posArray addObject:[NSNumber numberWithInt:lastPos]  ];
           // [posArray append:lastPos];
        }else {
            return posArray;
        }
    }
    return posArray;
}



@end
