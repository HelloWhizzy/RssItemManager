//
//  Rss.swift
//  Smart.Works
//

import Foundation

class RssItem : NSObject {
    
    
    var title:String = "";
    var link:String = "";
    var commentslink:String = "";
    var pubdate:String = "";
    var creator:String = "";
    var categories:AnyObject = NSMutableArray();
    var images:AnyObject = NSMutableArray();
    var guid:String="";
    var excerpt:String="";
    var encodedcontent:String="";
    var commentsrssfeedlink:String="";
    var commentcount:String="";
    
    var currentlyparsing:String="";
    
    override init() {
        
        super.init();
        
    }
    
}
