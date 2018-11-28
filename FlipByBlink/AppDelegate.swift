import UIKit
import PDFKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let vc:ViewController = window?.rootViewController as? ViewController{
            if let d = PDFDocument(url: url){
                vc.pdfビュー.autoScales = true
                vc.pdfビュー.displayMode = .singlePage
                vc.pdfビュー.backgroundColor = .clear
                vc.pdfビュー.displaysPageBreaks = false
                vc.pdfビュー.document = d
                vc.pdfビュー.goToFirstPage(nil)
            }
            vc.view.backgroundColor = .black
        }
        do{
            try FileManager.default.removeItem(at: url)
        }catch{
            print("remove miss")
        }
        return true
    }

}

