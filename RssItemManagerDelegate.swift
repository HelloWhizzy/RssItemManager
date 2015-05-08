import Foundation

protocol RssItemManagerDelegate{
    
    func parsingCompletedSuccessfully(paramObject: NSMutableArray);
    func parsingError(paramError:NSError);
    
}
