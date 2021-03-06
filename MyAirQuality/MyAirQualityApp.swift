
import SwiftUI

import Amplify
import AmplifyPlugins

@main
struct MyAirQualityApp: App {
    // add a default initializer and configure Amplify
    public init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func configureAmplify() {
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
            Amplify.Logging.logLevel = .info
            print("Initialized Amplify");
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }
}
