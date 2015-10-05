//
//  URLTag.m
//  MarkNoteParserOC
//
//  Created by marknote on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import "URLTag.h"
#import "NSString+Addition.h"

@implementation URLTag

-(id)initWithString:(NSString*) surl{
    
    self = [super init];
    if (self) {
        self.title = @"";
        self.url = @"";
        NSString* trimmed = [surl trim];
        NSArray<NSString *> *arr = [trimmed componentsSeparatedByString:@" "];
        if (arr.count > 1) {
            self.url = arr[0].lowercaseString;
            self.title = [arr[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
           
        } else {
            self.url = arr[0].lowercaseString;
        }
    }
    return self;
    
   
}


-(NSString*) description{
    return self.url;
}
@end


