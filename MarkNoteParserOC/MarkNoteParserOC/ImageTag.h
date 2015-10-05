//
//  ImageTag.h
//  MarkNoteParserOC
//
//  Created by marknote on 5/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLTag.h"

@interface ImageTag : NSObject

@property (nonatomic,strong) URLTag* url;
@property (nonatomic,strong) NSString* alt;

- (NSString*) toHtml ;




@end
