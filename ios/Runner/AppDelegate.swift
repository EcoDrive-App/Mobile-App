import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Get .env and read API KEY
    if let envPath = Bundle.main.path(forResource: "Frameworks/App.framework/flutter_assets/.env", ofType: nil) {
        do {
            let envContent = try String(contentsOfFile: envPath)
            let apiKey = envContent
                .components(separatedBy: "GOOGLE_MAPS_API_KEY=")[1]
                .components(separatedBy: "\n")[0]
                .trimmingCharacters(in: .whitespacesAndNewlines)

            GMSServices.provideAPIKey(apiKey)
        } catch {
            print("Error leyendo .env: \(error)")
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
