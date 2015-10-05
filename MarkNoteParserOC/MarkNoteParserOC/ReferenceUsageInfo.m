//
//  ReferenceUsageInfo.m
//  MarkNoteParserOC
//
//  Created by bill on 5/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import "ReferenceUsageInfo.h"

@implementation ReferenceUsageInfo


- (NSString*) placeHolder {
    return [NSString stringWithFormat: @"ReferenceUsageInfo%@%@",self.key,self.title ];
}

@end
