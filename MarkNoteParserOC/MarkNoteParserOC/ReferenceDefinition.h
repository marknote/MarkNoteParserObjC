//
//  ReferenceDefinition.h
//  MarkNoteParserOC
//
//  Created by bill on 5/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLTag.h"

@interface ReferenceDefinition : NSObject

@property (nonatomic,strong) URLTag* url;
@property (nonatomic,strong) NSString* key;

@end
