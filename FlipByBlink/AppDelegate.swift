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
        print("urlは",url)
        print("optionsは",options)
        
        let udoc = UIDocument(fileURL: url)
        
        print(udoc)
        
        let fm = FileManager.default
        
        let savePdfUrl = URL(string: fm.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!

        do{
            try fm.removeItem(at: savePdfUrl)
        }catch{
            print("前に開いたPDFを削除できなかった")
        }
        
        do{
            try fm.copyItem(at: url, to: savePdfUrl)
        }catch{
            print("コピー失敗")
        }

        if let vc:ViewController = window?.rootViewController as? ViewController{
            if let d = PDFDocument(url: savePdfUrl){
                vc.pdfビュー.autoScales = true
                vc.pdfビュー.displayMode = .singlePage
                vc.pdfビュー.backgroundColor = .clear
                vc.pdfビュー.displaysPageBreaks = false
                vc.pdfビュー.document = d
                vc.pdfビュー.goToFirstPage(nil)
            }
            vc.view.backgroundColor = .black
        }
        return true
    }

}

