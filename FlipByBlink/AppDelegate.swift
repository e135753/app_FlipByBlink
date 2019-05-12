import UIKit
import PDFKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("🗣 url is ",url)
        print("🗣 options is ",options)
        
        let ud = UIDocument(fileURL: url)
        
        print(ud)
        
        let 🗂 = FileManager.default
        
        let 📍 = URL(string: 🗂.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!

        do{ try 🗂.removeItem(at: 📍)
        }catch{ print("👿") }
        
        do{ try 🗂.copyItem(at: url, to: 📍)
        }catch{ print("👿") }

        if let vc:ViewController = window?.rootViewController as? ViewController{
            if let 📘 = PDFDocument(url: 📍){
                vc.📖.document = 📘
                vc.📖.goToFirstPage(nil)
                vc.📖.autoScales = true
            }
        }
        return true
    }
}
