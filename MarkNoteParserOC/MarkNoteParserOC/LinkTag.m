//
//  LinkTag.m
//  MarkNoteParserOC
//
//  Created by bill on 5/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import "LinkTag.h"

@implementation LinkTag

- (NSString*) toHtml {
    if (self.url.title.length > 0 ){
        return [NSString stringWithFormat:  @"<a href=\"%@\" title=\"%@\">%@</a>",self.url.url,self.url.title, self.text ];
    } else {
        return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",self.url.url,self.text];
    }
    
}
@end

