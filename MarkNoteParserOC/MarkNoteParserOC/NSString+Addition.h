//
//  NSString+Addition.h
//  MarkNoteParserOC
//
//  Created by bill on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Addition)

-(NSString*)trim;
-(NSUInteger) indexOf:(NSString*) toFind;
-(BOOL) contains3PlusandOnlyChars:(NSString*) ch;

@end


