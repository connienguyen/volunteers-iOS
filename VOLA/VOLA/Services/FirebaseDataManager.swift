//
//  FirebaseDataManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/29/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseAuth.FIRUser
import FirebaseDatabase
import PromiseKit

/// Class for managing reading from and writing to Firebase realtime database
class FirebaseDataManager {
    enum UserTableField: String {
        case email

        var key: String {
            return rawValue
        }
    }

    static let shared = FirebaseDataManager()

    let reference = Database.database().reference()

    private init() { /* intentionally left blank */ }

    /**
        Retrieve user from Firebase realtime database given a `FIRUser`
     
        - Parameters:
            - firebaseUser: Firebase user associated with user in Firebase database table
     
        - Returns: `User` promise populated with data from Firebase account and user database
            if successful
    */
    func userFromTable(firebaseUser: FirebaseAuth.User) -> Promise<User?> {
        return Promise { fulfill, reject in
            reference.table(.users).child(firebaseUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotDict = snapshot.value as? [String: Any] else {
                    // No user with matching UID exists on Firebase database
                    fulfill(nil)
                    return
                }

                let userFromSnapshot = User(firebaseUser: firebaseUser, snapshotDict: snapshotDict)
                guard let userInDatabase = userFromSnapshot else {
                    reject(VLError.failedUserSnapshot)
                    return
                }

                fulfill(userInDatabase)
            }) { (error) in
                reject(error)
            }
        }
    }

    /**
        Create or update a user in the Firebase realtime database given a `FirebaseAuth.User`
     
        - Parameters:
            - firebaseUser: Firebase user to create a new user object in Firebase table for
     
        - Returns: `User` promise populated with data from Firebase account and user database
            if successful
    */
    func updateUserInTable(firebaseUser: FirebaseAuth.User, values: [String: Any]) -> Promise<User> {
        return Promise { fulfill, reject in
            reference.table(.users).child(firebaseUser.uid).setValue(values)
            reference.table(.users).child(firebaseUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotDict = snapshot.value as? [String: Any] else {
                    reject(VLError.invalidFirebaseAction)
                    return
                }

                let userFromSnapshot = User(firebaseUser: firebaseUser, snapshotDict: snapshotDict)
                guard let newUser = userFromSnapshot else {
                    reject(VLError.failedUserSnapshot)
                    return
                }

                fulfill(newUser)
            }) { (error) in
                reject(error)
            }
        }
    }
}

/// MARK:- Extension for Firebase related to reading and writing data regarding events
extension FirebaseDataManager {
    /**
        Retrieve event from Firebase database given an `eventID`
     
        - Parameters:
            - eventID: ID for event to retrieve from Firebase database
     
        - Returns: `Event` model populated with data from Firebase database, if successful
    */
    func getEvent(eventID: String) -> Promise<Event> {
        return Promise { fulfill, reject in
            reference.table(.events).child(eventID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotDict = snapshot.value as? [String: Any],
                    let event = Event(JSON: snapshotDict) else {
                    reject(VLError.failedSnapshot)
                    return
                }

                fulfill(event)
            }, withCancel: { (error) in
                reject(error)
            })
        }
    }
    /**
        Retrieve all available events from the Firebase database
     
        - Returns: `Event` array promise with data from Firebase database if successful
    */
    func getAvailableEvents() -> Promise<[Event]> {
        return Promise { fulfill, reject in
            reference.table(.events).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotDict = snapshot.value as? [String: Any] else {
                    reject(VLError.failedSnapshot)
                    return
                }

                let events = self.eventsFromSnapshot(from: snapshotDict)
                fulfill(events)
            }, withCancel: { (error) in
                reject(error)
            })
        }
    }

    /**
        Convert snapshot dictionary from Firebase into an array of `Event` models
     
        - Parameters:
            - snapshotDict: Snapshot data from Firebase to convert to an array of `Event` models
     
        - Returns: An array of `Event` models populated with data from the Firebase snapshot
    */
    func eventsFromSnapshot(from snapshotDict: [String: Any]) -> [Event] {
        var events: [Event] = []
        for (eventID, data) in snapshotDict {
            if let JSONData = data as? [String: Any], let event = Event(JSON: JSONData) {
                event.eventID = eventID
                events.append(event)
            }
        }
        return events
    }
}
