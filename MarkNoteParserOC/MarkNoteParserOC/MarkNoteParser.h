//
//  MarkNoteParser.h
//  MarkNoteParserOC
//
//  Created by bill on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLTag.h"





@interface MarkNoteParser : NSObject

+(NSArray<NSString*>*)detectPositions:(NSArray<NSString *> *)toFind inStr:(NSString* )inStr;

@end
