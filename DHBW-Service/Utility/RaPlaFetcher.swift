//
//  RaPlaFetcher.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 29.01.21.
//

import Foundation
import CoreData

class RaPlaFetcher {
    public class iCalEvent {
        var startDate: Date = Date()    //DTSTART
        var endDate: Date = Date()      //DTEND
        var summary: String = ""        //SUMMARY
        var description: String = ""    //DESCRIPTION
        var location: String = ""       //LOCATION
        var category: String = ""       //CATEGORIES
    }
    
    // Get the RaPla file from the given URL and save the events to CoreData
    public class func getRaplaFileAndSaveToCoreData(from urlString: String) -> Bool {
        let file = getFileAsString(from: urlString)
        
        let eventStrings = splitIntoEvents(file: file)
        
        let eventObjects = convertStringsToObjects(eventStrings: eventStrings)
        
        return saveToCoreData(eventObjects: eventObjects)
    }
    
    // Get the RaPla files from the given URL and return the event objects
    public class func getRaplaFileAndReturnEvents(from urlString: String) -> [iCalEvent] {
        let file = getFileAsString(from: urlString)
        
        let eventStrings = splitIntoEvents(file: file)
        
        return convertStringsToObjects(eventStrings: eventStrings)
    }
    
    // GET the file from the given URL and convert it to a String that is then returned
    private class func getFileAsString(from urlString: String) -> String {
        let url = URL(string: urlString)!
        var file: String = ""
        
        do {
            file = try String(contentsOf: url, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return file
    }
    
    // Split the given ical file string into individual event strings and return them as a list
    private class func splitIntoEvents(file: String) -> [String] {
        let regexOptions: NSRegularExpression.Options = [.dotMatchesLineSeparators]
        // Regex explanation: Matches BEGIN:VEVENT "Any character" END:VEVENT across multiple lines. The *? assures that we receive the
        // maximum amount of matches, i.e. it makes the regex non-greedy as we would otherwise just receive one giant match
        let eventStrings = UtilityFunctions.regexMatches(for: "BEGIN:VEVENT.*?END:VEVENT", with: regexOptions, in: file)
        
        return eventStrings
    }
    
    // Convert an ical event String into an iCalEvent Codable object as defined above
    private class func convertStringsToObjects(eventStrings: [String]) -> [iCalEvent] {
        var events: [iCalEvent] = []
        
        for eventString in eventStrings {
            let lines = eventString.components(separatedBy: .newlines)
            let evt = iCalEvent()
            
            for line in lines {
                var lineWithoutPrefix = line
                if(!line.contains(":")) {
                    continue
                }
                lineWithoutPrefix.removeSubrange(lineWithoutPrefix.startIndex...lineWithoutPrefix.firstIndex(of: ":")!)
                
                if(line.hasPrefix("DTSTART")){
                    //Date format: 20181101T080000
                    let dateFormatter = DateFormatter()
                    if(lineWithoutPrefix.contains("Z")){
                        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
                    } else {
                        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
                    }
                    let date = dateFormatter.date(from: lineWithoutPrefix)!
                    evt.startDate = date
                } else if(line.hasPrefix("DTEND")){
                    let dateFormatter = DateFormatter()
                    if(lineWithoutPrefix.contains("Z")){
                        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
                    } else {
                        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
                    }
                    let date = dateFormatter.date(from: lineWithoutPrefix)!
                    evt.endDate = date
                } else if(line.hasPrefix("SUMMARY")){
                    evt.summary = lineWithoutPrefix
                } else if(line.hasPrefix("DESCRIPTION")){
                    evt.description = lineWithoutPrefix
                } else if(line.hasPrefix("LOCATION")){
                    evt.location = lineWithoutPrefix
                } else if(line.hasPrefix("CATEGORIES")){
                    evt.category = lineWithoutPrefix
                }
            }
            
            events.append(evt)
        }
        
        return events
    }
    
    // Save the given iCalEvent objects to CoreData
    private class func saveToCoreData(eventObjects: [iCalEvent]) -> Bool{
        // Delete old data
        if(UtilityFunctions.deleteAllCoreDataEntitiesOfType(type: "RaPlaEvent")){
            for event in eventObjects {
                let entity = NSEntityDescription.entity(forEntityName: "RaPlaEvent", in: PersistenceController.shared.context)!
                let evt = NSManagedObject(entity: entity, insertInto: PersistenceController.shared.context)
                evt.setValue(event.startDate, forKey: "startDate")
                evt.setValue(event.endDate, forKey: "endDate")
                evt.setValue(event.summary, forKey: "summary")
                evt.setValue(event.description, forKey: "descr")
                evt.setValue(event.location, forKey: "location")
                evt.setValue(event.category, forKey: "category")
            }
            
            PersistenceController.shared.save()
            
            return true
        } else {
            return false
        }
    }
}
