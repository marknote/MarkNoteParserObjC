//
//  ImageTag.m
//  MarkNoteParserOC
//
//  Created by marknote on 5/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import "ImageTag.h"
#import "URLTag.h"

@implementation ImageTag

- (NSString*) toHtml {
    if (self.url.title.length > 0 ){
        return [NSString stringWithFormat:  @"<img src=\"%@\" alt=\"%@\" title=\"%@\"/>",self.url.url,self.alt, self.url.title];
    } else {
        return [NSString stringWithFormat:  @"<img src=\"%@\" alt=\"%@\" />",self.url.url,self.alt];
    }
    
}




@end
