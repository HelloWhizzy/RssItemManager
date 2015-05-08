//
//  RssItemManager.swift
//  Smart.Works
//
//

import Foundation

class RssItemManager : NSObject, NSXMLParserDelegate {

    enum RSSTAGNAMES : String{
        
        case ITEMTAG = "item"
        case TITLETAG = "title"
        case LINKTAG = "link"
        case COMMENTSLINKTAG = "comments"
        case PUBDATETAG = "pubDate"
        case CREATORTAG = "dc:creator"
        case CATEGORYTAG = "category"
        case GUIDTAG = "guid"
        case EXCERPTTAG = "description"
        case ENCODEDCONTENTTAG = "content:encoded"
        case COMMENTRSSFEEDLINKTAG = "wfw:commentRss"
        case COMMENTSCOUNTTAG = "slash:comments"
        
    };
    

    
    var items:NSMutableArray = NSMutableArray();
    var item:RssItem = RssItem();
    var currentlyparsing:String="";
    var delegate:RssItemManagerDelegate?;

    init(paramurlstring: String, paramdelegate:RssItemManagerDelegate?) {
        
        super.init();
        self.delegate=paramdelegate;
        
        var url:NSURL=NSURL(string:paramurlstring)!;
        let parserobject:NSXMLParser=NSXMLParser(contentsOfURL: url)!;
        
        parserobject.shouldResolveExternalEntities=true;
        parserobject.shouldProcessNamespaces=true;
        parserobject.shouldReportNamespacePrefixes=true;

        parserobject.delegate=self;
        parserobject.parse();
    }
    
    
    func parserDidStartDocument(_parser: NSXMLParser){
        
    }
    func parserDidEndDocument(_parser: NSXMLParser){
        
        self.delegate?.parsingCompletedSuccessfully(items);
        
    }
    func parser(_parser: NSXMLParser,didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?,
        attributes attributeDict: [NSObject : AnyObject]){
            println(elementName);
            if (qualifiedName==RSSTAGNAMES.ITEMTAG.rawValue){
                self.item=RssItem();
            }
            self.currentlyparsing=qualifiedName!;
            
    }
    func parser(_parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?,qualifiedName qName: String?){
        
        if (qName==RSSTAGNAMES.ITEMTAG.rawValue){
            self.items.addObject(item);
        }
        if (qName==RSSTAGNAMES.ENCODEDCONTENTTAG.rawValue){
            self.extractImages(self.item.encodedcontent);
        }

    }
    func parser(_parser: NSXMLParser, parseErrorOccurred parseError: NSError){
        
    }
    func parser(_parser: NSXMLParser,foundCharacters string: String?){
        println(string);

        let string=string!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (self.currentlyparsing==RSSTAGNAMES.TITLETAG.rawValue){
            self.item.title+=string;
        }
        if (self.currentlyparsing==RSSTAGNAMES.COMMENTSLINKTAG.rawValue){
            self.item.commentslink+=string;
        }
        if (self.currentlyparsing==RSSTAGNAMES.PUBDATETAG.rawValue){
            //self.item.pubdate+=string;
            var tempDateFormatter : NSDateFormatter = NSDateFormatter();
            tempDateFormatter.timeZone=NSTimeZone.systemTimeZone();
            tempDateFormatter.locale=NSLocale.currentLocale();
            tempDateFormatter.dateFormat="EEE, dd MMMM yyyy HH:mm:ss Z";
            tempDateFormatter.formatterBehavior=NSDateFormatterBehavior.BehaviorDefault;
            let tempDate=tempDateFormatter.dateFromString(string);
            


            if !(tempDate==nil){
                self.item.pubdate=tempDateFormatter.stringFromDate(tempDate!);
            }
            
        }
        if (self.currentlyparsing==RSSTAGNAMES.LINKTAG.rawValue){
            self.item.link+=string;
        }
        if (self.currentlyparsing==RSSTAGNAMES.CREATORTAG.rawValue){
            self.item.creator+=string;
        }
        if (self.currentlyparsing==RSSTAGNAMES.CATEGORYTAG.rawValue){
            self.item.categories.addObject(string);
        }
        if (self.currentlyparsing==RSSTAGNAMES.GUIDTAG.rawValue){
            self.item.guid+=string;
        }
       // if (self.currentlyparsing==RSSTAGNAMES.EXCERPTTAG.toRaw()){
         //   self.item.excerpt+=string;
       // }
        if (self.currentlyparsing==RSSTAGNAMES.ENCODEDCONTENTTAG.rawValue){
            self.item.encodedcontent+=string;
        }
        if (self.currentlyparsing==RSSTAGNAMES.COMMENTRSSFEEDLINKTAG.rawValue){
            self.item.commentsrssfeedlink+=string;
        }
        if (self.currentlyparsing==RSSTAGNAMES.COMMENTSCOUNTTAG.rawValue){
            self.item.commentcount+=string;
        }
        
        
    }
    func parser(_parser: NSXMLParser, foundCDATA CDATABlock: NSData){
        
       // self.delegate.parsingError(nil : NSError);
        if (self.currentlyparsing==RSSTAGNAMES.ENCODEDCONTENTTAG.rawValue){
            let tempString=NSString(data: CDATABlock, encoding: NSUTF8StringEncoding) as! String;
            self.item.encodedcontent+=tempString;
          //  self.item.encodedcontent=self.item.encodedcontent + tempString;
           // NSString *someString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];

        }
        if (self.currentlyparsing==RSSTAGNAMES.EXCERPTTAG.rawValue){
            let tempString=NSString(data: CDATABlock, encoding: NSUTF8StringEncoding) as! String;
            self.item.excerpt+=tempString;
            println(self.item.excerpt);
            // NSString *someString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
            
        }

    }

    func extractImages(paramhtml: NSString){
        
        var stop:Bool;
        
        let regex=NSRegularExpression(pattern: "(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?", options: NSRegularExpressionOptions.CaseInsensitive, error: nil);
        
        let nsRange : NSRange = NSRange(location: 0, length: paramhtml.length)
        var result : NSTextCheckingResult;
        
        regex!.enumerateMatchesInString(paramhtml as String, options: NSMatchingOptions.ReportCompletion, range: nsRange) { (result, NSMatchingFlags flags, stop) -> Void in
            if (result==nil){
                
            }
            else{
                let img=paramhtml.substringWithRange(result.rangeAtIndex(2));
                self.item.images.addObject(img);
                println(img);
            }

        };
    
    }
    

}
