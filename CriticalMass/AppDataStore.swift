//
//  AppDataStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import CoreData
import UIKit

public protocol FriendsStorage {
    var username: String? { get set }
}

public class AppDataStore: DataStore {
    private var friendsStorage: FriendsStorage

    public init(friendsStorage: FriendsStorage) {
        self.friendsStorage = friendsStorage

        if Feature.friends.isActive {
            loadFriends()
        }
    }

    private var lastKnownResponse: ApiResponse?

    public var userName: String {
        get { friendsStorage.username ?? UIDevice.current.name }
        set { friendsStorage.username = newValue }
    }

    public func update(with result: ApiResponseResult) {
        NotificationCenter.default.post(name: .locationAndMessagesReceived, object: result)
        if let response = try? result.get() {
            if lastKnownResponse?.locations != response.locations {
                NotificationCenter.default.post(name: .positionOthersChanged, object: response)
                updateFriendsLocations(locations: response.locations)
            }
            if lastKnownResponse?.chatMessages != response.chatMessages {
                NotificationCenter.default.post(name: .chatMessagesReceived, object: response)
            }
            lastKnownResponse = response
        }
    }

    public func add(friend: Friend) {
        friends.append(friend)

        let storedFriend = StoredFriend(context: persistentContainer.viewContext)
        storedFriend.name = friend.name

        let keyReference = UUID().uuidString
        try? KeychainHelper.save(keyData: friend.token.data(using: .utf8)!, with: keyReference)
        storedFriend.keyReference = keyReference

        saveContext()

        NotificationCenter.default.post(name: .positionOthersChanged, object: nil)
    }

    public func remove(friend: Friend) {
        // We reload freids to make sure that fetch results controller and friends indeces are in sync
        loadFriends()
        guard let index = friends.firstIndex(of: friend) else {
            return
        }
        friends.remove(at: index)
        guard let storedFriend = friendsFetchResultsController.fetchedObjects?[index] else {
            return
        }
        try? KeychainHelper.delete(with: storedFriend.keyReference!)
        persistentContainer.viewContext.delete(storedFriend)
        saveContext()
    }

    func updateFriendsLocations(locations: [String: Location]) {
        friends = friends.map { friend in
            let hash = IDStore.hash(id: friend.token)
            let location = locations[hash]
            return Friend(name: friend.name, token: friend.token, location: location)
        }
    }

    public private(set) var friends: [Friend] = []

    private lazy var friendsFetchResultsController: NSFetchedResultsController<StoredFriend> = {
        let fetchRequest: NSFetchRequest<StoredFriend> = StoredFriend.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "MainCache")
        return resultsController
    }()

    private func loadFriends() {
        try? friendsFetchResultsController.performFetch()
        friends = friendsFetchResultsController.fetchedObjects?.compactMap { storedFriend in
            guard let name = storedFriend.name,
                  let keyRef = storedFriend.keyReference,
                  let keyData = try? KeychainHelper.load(with: keyRef),
                  let token = String(bytes: keyData, encoding: .utf8)
            else {
                return nil
            }
            return Friend(name: name, token: token)
        } ?? []
    }

    // MARK: CoreData

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CriticalMaps")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
