//
//  NSString+Addition.m
//  MarkNoteParserOC
//
//  Created by bill on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString(Addition)

-(NSString*)trim{
    
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}

-(NSUInteger) indexOf:(NSString*) toFind{
    return [self rangeOfString:toFind].location;
}

-(BOOL) contains3PlusandOnlyChars:(NSString*) ch{
    return (self.length >= 3
    && [self indexOf:ch] == 0
            && [self stringByReplacingOccurrencesOfString:ch withString:@""].length == 0);
}



@end
