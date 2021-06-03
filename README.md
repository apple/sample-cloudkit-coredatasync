# CloudKit Samples: Core Data with CloudKit

### Goals

This project demonstrates using Core Data with `NSPersistentCloudKitContainer`, which encapsulates the Core Data stack in an application and mirrors persistent stores to a CloudKit private database. Changes made locally are automatically sent to the remote CloudKit database, and remote changes are fetched and brought into local stores across devices through background push notifications.

### Prerequisites

* A Mac with [Xcode 12](https://developer.apple.com/xcode/) (or later) installed is required to build and test this project.
* An iOS device which will receive CloudKit change notifications is required to install and run the app on, as simulators cannot receive remote push notifications.
* An active [Apple Developer Program membership](https://developer.apple.com/support/compare-memberships/) is needed to create a CloudKit container and sign the app to run on a device.

### Setup Instructions

1. Ensure you are logged into your developer account in Xcode with an active membership.
1. In the “Signing & Capabilities” tab of the CoreDataSync target, ensure your team is selected in the Signing section, and there is a valid container selected under the “iCloud” section.
1. Ensure that both the simulator you wish to use and the device you will run the app on are logged into the same iCloud account.

#### Using Your Own iCloud Container

* Create a new iCloud container through Xcode’s “Signing & Capabilities” tab of the CoreDataSync app target.
* Update the `containerIdentifier` property in [Config.swift](CoreDataSync/App/Config.swift) with your new iCloud container ID.

### How it Works

* The `CoreDataSync` model defines a `Contact` entity, which stores a name (`String`) and photo (`UIImage` Transformable).
* The `PersistenceController` class creates an `NSPersistentCloudKitContainer` object with the `CoreDataSync` model.
* The main list view uses the [`@FetchRequest`](https://developer.apple.com/documentation/swiftui/fetchrequest) property wrapper to retrieve Contact objects from the Core Data store.
* Creating new Contacts and deleting existing Contacts is done through normal Core Data operations.
* `NSPersistentCloudKitContainer` syncs with the user’s private database in the iCloud container listed in the app’s entitlements file.

### Example Flow

1. Run the app on a device. After initializing the store, CoreData+CloudKit mirroring will fetch any existing records from the remote private database.
1. Repeat the above on a simulator, and add a new contact through the UI.
1. The device receives a background push notification which is automatically processed by CoreData+CloudKit. Changes are fetched and merged into the local store, and both simulator and device once again show the same content. Deleting a contact by swiping left on a cell produces similar behavior.

Note that because remote push notifications are not supported on simulators, changes on a running device will not be automatically reflected on a running simulator as they are the other way around. Running the app again on a simulator will cause CoreData+CloudKit to sync changes made on a device.

### Things To Learn

* Showing a live list of Core Data managed objects with SwiftUI using the `@FetchRequest` property wrapper.
* Adding and deleting objects with `NSManagedObjectContext`.
* Automatic syncing of Core Data objects with `NSPersistentCloudKitContainer`.
* `NSPersistentCloudKitContainer` processing of push notifications to receive and display updates initiated on another device.
* Storage and decoding of image types in Core Data and CloudKit Private Database.

### Further Reading

* [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer)
* [Mirroring a Core Data Store with CloudKit](https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit)
