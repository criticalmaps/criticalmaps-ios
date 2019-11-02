import CriticalMapsKit
import Foundation

struct SaveToDiskStore: DataStore {
    func update(with response: ApiResponse) {
        print(response)
        // TODO: save to disk
    }
}

struct NoLocationProvider: LocationProvider {
    var currentLocation: Location?
    
    static var accessPermission: LocationProviderPermission {
        return .disabled
    }
}

struct NoIdProvider: IDProvider {
    var id: String = ""
}

let store = SaveToDiskStore()

let requestManager = RequestManager(dataStore: store, locationProvider: NoLocationProvider(), networkLayer: NetworkOperator(), idProvider: NoIdProvider(), url: Constants.apiEndpoint)
    

// TODO: add support for timeframes and other arguments
 

RunLoop.main.run()
