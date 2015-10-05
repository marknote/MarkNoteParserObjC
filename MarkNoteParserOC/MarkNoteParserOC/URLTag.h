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

@end



/*

class ImageTag{
    
    var alt = ""
    var url = URLTag(url:"")
    func toHtml()-> String{
        if url._title.length > 0 {
            return "<img=\"\(url._url)\" alt=\"\(alt)\" title=\"\(url._title)\" />"
        } else {
            return "<img src=\"\(url._url)\" alt=\"\(alt)\" />"
        }
    }
}

class ReferenceDefinition {
    var key = ""
    var url = URLTag(url:"")
}
class ReferenceUsageInfo{
    var title = ""
    var key = ""
    var type = ReferenceType.Link
    func placeHolder() -> String{
        return "ReferenceUsageInfo\(key)\(title)"
    }
}*/
