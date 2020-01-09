import CriticalMapsKit
import Foundation
import Yaap

struct NoLocationProvider: LocationProvider {
    var currentLocation: Location?

    static var accessPermission: LocationProviderPermission {
        .disabled
    }
}

struct NoIdProvider: IDProvider {
    var token: String = ""

    static func hash(id: String, currentDate _: Date) -> String {
        id
    }

    var id: String = ""
}

class SaveToDiskStore: DataStore {
    var outputPath: String
    var outputStream: TextOutputStream
    var errorStream: TextOutputStream

    var snapshotCount = 0

    init(outputPath: String, outputStream: TextOutputStream, errorStream: TextOutputStream) {
        self.outputPath = outputPath
        self.outputStream = outputStream
        self.errorStream = errorStream
    }

    func update(with response: ApiResponse) {
        guard let data = try? JSONEncoder().encode(response) else {
            errorStream.write("Couldn't encode data")
            return
        }

        let url = URL(fileURLWithPath: outputPath)
            .appendingPathComponent("snapshot_\(snapshotCount)")
            .appendingPathExtension("json")

        do {
            try data.write(to: url)

            snapshotCount += 1
            outputStream.write("💾 Saved snapshot nr. \(snapshotCount)")
            outputStream.write("\n")
        } catch {
            errorStream.write("Saving data to disk failed with error: \(error.localizedDescription)")
        }
    }
}

class GenerateSnapshotCommand: Command {
    let name = "SimulationSnapshots"
    let description = "Generates snapshots that can be used to debug the iOS Client"
    let help = Help()
    let version = Version("0.1.0")

    @Argument(documentation: "The output path")
    var output: String

    // TODO: add support for timeframes and other arguments

    func run(outputStream: inout TextOutputStream, errorStream: inout TextOutputStream) throws {
        let store = SaveToDiskStore(outputPath: output, outputStream: outputStream, errorStream: errorStream)

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 15.0
        let session = URLSession(configuration: configuration)

        _ = RequestManager(dataStore: store, locationProvider: NoLocationProvider(), networkLayer: NetworkOperator(dataProvider: session), idProvider: NoIdProvider())
        RunLoop.main.run()
    }
}

let command = GenerateSnapshotCommand()
command.parseAndRun()
