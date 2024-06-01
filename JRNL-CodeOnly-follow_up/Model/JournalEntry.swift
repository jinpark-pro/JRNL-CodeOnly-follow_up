//
//  JournalEntry.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-05-19.
//

import UIKit
import MapKit

class JournalEntry: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let lat = latitude,
              let long = longitude else {
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    // MARK: - Properties
    let date: Date
    let rating: Int
    let entryTitle: String
    let entryBody: String
    let photo: UIImage?
    let latitude: Double?
    let longitude: Double?
    
    // MARK: - Initialization
    init?(rating: Int, title: String, body: String, photo: UIImage? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        if title.isEmpty || body.isEmpty || rating < 0 || rating > 5 {
            return nil
        }
        self.date = Date()
        self.rating = rating
        self.entryTitle = title
        self.entryBody = body
        self.photo = photo
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var title: String? {
        date.formatted(.dateTime.year().month().day())
    }
    var subtitle: String? {
        entryBody
    }
}
