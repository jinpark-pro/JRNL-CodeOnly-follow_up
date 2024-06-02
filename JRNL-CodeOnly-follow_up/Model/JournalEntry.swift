//
//  JournalEntry.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-05-19.
//

import UIKit
import MapKit

class JournalEntry: NSObject, MKAnnotation, Codable {
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
    var photo: UIImage? {
        get {
            guard let data = photoData else { return nil }
            return UIImage(data: data)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 1.0)
        }
    }
    private var photoData: Data?
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
//        self.photo = photo
        self.photoData = photo?.jpegData(compressionQuality: 1.0)
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var title: String? {
        date.formatted(.dateTime.year().month().day())
    }
    var subtitle: String? {
        entryBody
    }
    
    enum CodingKeys: String, CodingKey {
        case date, rating, entryTitle, entryBody, photoData, latitude, longitude
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        rating = try container.decode(Int.self, forKey: .rating)
        entryTitle = try container.decode(String.self, forKey: .entryTitle)
        entryBody = try container.decode(String.self, forKey: .entryBody)
        photoData = try container.decode(Data.self, forKey: .photoData)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(rating, forKey: .rating)
        try container.encode(entryTitle, forKey: .entryTitle)
        try container.encode(entryBody, forKey: .entryBody)
        try container.encode(photoData, forKey: .photoData)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
        
}
