//
//  MarkNoteParser.h
//  MarkNoteParserOC
//
//  Created by bill on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLTag.h"
#import "LinkTag.h"
#import "ImageTag.h"
#import "ReferenceDefinition.h"
#import "ReferenceUsageInfo.h"




@interface MarkNoteParser : NSObject{
    BOOL bInTable;
    NSMutableString* output;
    int nCurrentBulletLevel ;
    BOOL isInParagraph ;
    BOOL isAfterEmptyLine;
    NSMutableArray<NSString*>* tableColsAlignment ;
    
    NSMutableArray<NSString*>* blockEndTags;
    BOOL isCurrentLineNeedBr ;
    NSMutableArray<ReferenceDefinition*>* arrReferenceInfo ;
    NSMutableArray<ReferenceUsageInfo*>* arrReferenceUsage ;
}

@property (nonatomic,strong) NSMutableString* outputString;

+(NSArray<NSNumber*>*)detectPositions:(NSArray<NSString *> *)toFind inStr:(NSString* )inStr;
+(NSString*) toHtml:(NSString*)input;

@end
