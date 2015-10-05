//
//  URLTag.h
//  MarkNoteParserOC
//
//  Created by marknote on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {Link, Image} ReferenceType;

@interface URLTag : NSObject

@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSString* title;

-(id)initWithString:(NSString*) surl;

@end



