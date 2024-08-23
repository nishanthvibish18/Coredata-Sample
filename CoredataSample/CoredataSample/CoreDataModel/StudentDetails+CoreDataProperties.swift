//
//  StudentDetails+CoreDataProperties.swift
//  CoredataSample
//
//  Created by Nishanth on 09/07/24.
//
//

import Foundation
import CoreData


extension StudentDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentDetails> {
        return NSFetchRequest<StudentDetails>(entityName: "StudentDetails")
    }

    @NSManaged public var name: String?
    @NSManaged public var rollnumber: String?
    @NSManaged public var department: String?
    @NSManaged public var age: String?
    @NSManaged public var marks: String?
}

extension StudentDetails : Identifiable {

}
