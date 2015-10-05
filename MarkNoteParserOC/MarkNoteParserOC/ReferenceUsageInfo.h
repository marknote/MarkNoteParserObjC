//
//  ReferenceUsageInfo.h
//  MarkNoteParserOC
//
//  Created by bill on 5/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLTag.h"

@interface ReferenceUsageInfo : NSObject


@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* key;
@property (nonatomic,assign) ReferenceType type;


- (NSString*) placeHolder ;







@end
