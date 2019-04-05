//諸設定
//カメラプライバシ
//DocumentTypePDF
//hiddenStatusBar
//upSideDown

import UIKit
import PDFKit
import ARKit
//import WebKit

class ViewController: UIViewController,ARSessionDelegate,ARSCNViewDelegate,UIDocumentPickerDelegate {
    
    @IBOutlet weak var pdfビュー: PDFView!
    
    @IBOutlet weak var sceneビュー: ARSCNView!
    
//    @IBOutlet weak var gifプレビュー: WKWebView!
    
    var ひとつ前に検出された目の開け具合:Double = 0.0
    var まばたきし始めた時刻:Date?
    var まばたきし続けてる時刻:Date?
    
    let 瞼の開け具合の閾値:Double = 0.8
    let 瞼を閉じ続ける時間の閾値:Double = 0.15
    
    var まだページ送りしてない:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        まばたきし始めた時刻 = Date()
        まばたきし続けてる時刻 = Date()
        
        if let サンプルURL = Bundle.main.url(forResource: "サンプル", withExtension: "pdf") {
            if let 開くPDF = PDFDocument(url: サンプルURL) {
                pdfビュー.autoScales = true
                pdfビュー.displayMode = .singlePage
                pdfビュー.backgroundColor = .clear
                pdfビュー.displaysPageBreaks = false
                pdfビュー.pageShadowsEnabled = false
                pdfビュー.document = 開くPDF
            }
        }
        
        sceneビュー.delegate = self
        sceneビュー.session.delegate = self
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneビュー.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneビュー.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
        
//        let gifData = NSData(contentsOfFile: Bundle.main.path(forResource: "demo",ofType:"gif")!)!
//        gifプレビュー.load(gifData as Data, mimeType: "image/gif", characterEncodingName: "utf-8", baseURL: NSURL() as URL)
//        gifプレビュー.isHidden = true
        
    }
    
    @IBAction func nextページ(_ sender: Any) {
        pdfビュー.goToNextPage(nil)
        サンプルの2pならgifを表示する()
    }
    @IBAction func 高速でページ進める(_ sender: Any) {
        pdfビュー.goToNextPage(nil)
    }
    @IBAction func previousページ(_ sender: Any) {
        pdfビュー.goToPreviousPage(nil)
        サンプルの2pならgifを表示する()
    }
    @IBAction func 高速でページ戻す(_ sender: Any) {
        pdfビュー.goToPreviousPage(nil)
    }
    @IBAction func 前回のPDFを開く(_ sender: Any) {
        let fm = FileManager.default
        if let d = PDFDocument(url: URL(string: fm.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!){
            pdfビュー.autoScales = true
            pdfビュー.displayMode = .singlePage
            pdfビュー.backgroundColor = .clear
            pdfビュー.displaysPageBreaks = false
            pdfビュー.document = d
            pdfビュー.goToFirstPage(nil)
        }
        view.backgroundColor = .black
//        gifプレビュー.isHidden = true
    }
    
    
    @IBAction func pickerを呼び出す(_ sender: Any) {
        let ピッカー = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        ピッカー.delegate = self
        self.present(ピッカー, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        pdfビュー.autoScales = true
        pdfビュー.backgroundColor = .clear
        pdfビュー.document = PDFDocument(url: urls.first!)
        pdfビュー.goToFirstPage(nil)
        view.backgroundColor = .black
        
        let fm = FileManager.default
        
        let savePdfUrl = URL(string: fm.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!
        
        do{
            try fm.removeItem(at: savePdfUrl)
        }catch{
            print("前に開いたPDFを削除できなかった")
        }
        
        do{
            try fm.copyItem(at: urls.first!, to: savePdfUrl)
        }catch{
            print("コピー失敗")
        }
//        gifプレビュー.isHidden = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        let 左目の開け具合 = faceAnchor.blendShapes[.eyeBlinkLeft]?.doubleValue
        
        if 左目の開け具合! > 瞼の開け具合の閾値 && ひとつ前に検出された目の開け具合 < 瞼の開け具合の閾値{
            まばたきし始めた時刻 = Date()
        }
        if 左目の開け具合! > 瞼の開け具合の閾値{
            まばたきし続けてる時刻 = Date()
            if まばたきし続けてる時刻!.timeIntervalSince(まばたきし始めた時刻!) > TimeInterval(瞼を閉じ続ける時間の閾値){
                if まだページ送りしてない{
                    DispatchQueue.main.async {
                        self.pdfビュー.goToNextPage(nil)
                        self.サンプルの2pならgifを表示する()
                    }
                    
                    まだページ送りしてない = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.まだページ送りしてない = true
                    }
                }
            }
        }
        
        ひとつ前に検出された目の開け具合 = 左目の開け具合!
        
    }
    
    override var keyCommands: [UIKeyCommand]?{
        let commands = [UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: #selector(右矢印で次のページへ移動(command:))),
                        UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: #selector(左矢印で前のページへ移動(command:)))]
        return commands
    }
    
    @objc func 右矢印で次のページへ移動(command: UIKeyCommand) {
        pdfビュー.goToNextPage(nil)
        サンプルの2pならgifを表示する()
    }

    @objc func 左矢印で前のページへ移動(command: UIKeyCommand) {
        pdfビュー.goToPreviousPage(nil)
        サンプルの2pならgifを表示する()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func サンプルの2pならgifを表示する(){
//        let 今開いているドキュメントURL = pdfビュー.document?.documentURL
//        if 今開いているドキュメントURL != Bundle.main.url(forResource: "サンプル", withExtension: "pdf"){
//            return
//        }
//
//        let 今表示してるページ番号 = pdfビュー.document!.index(for: pdfビュー.currentPage!)
//        if 今表示してるページ番号 != 1{
//            gifプレビュー.isHidden = true
//        }else{
//            gifプレビュー.isHidden = false
//        }
    }
    
}

