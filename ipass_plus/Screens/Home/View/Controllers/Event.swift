import Foundation

struct Event {
    let imageName: String
    let title: String
    let date: String
    let tag: String
    
    static func getMockData() -> [Event] {
//        return (1...100).map { i in
//            Event(imageName: "header", title: "Event \(i)", date: "29 Nov, 2021", tag: "Concert")
//        }
        
        return (1...8).map { i in
            Event(imageName: "header", title: "Event \(i)", date: "29 Nov, 2021", tag: "Concert")
        }
    }
}
