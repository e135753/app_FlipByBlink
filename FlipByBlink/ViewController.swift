//諸設定
//カメラプライバシ
//DocumentTypePDF
//hiddenStatusBar
//upSideDown

import UIKit
import PDFKit
import ARKit
import AVKit

class ViewController: UIViewController,ARSessionDelegate,ARSCNViewDelegate,UIDocumentPickerDelegate {
    
    @IBOutlet weak var pdfビュー: PDFView!
    
    @IBOutlet weak var sceneビュー: ARSCNView!
    
    @IBOutlet weak var BGLabel: UILabel!
    
    var ひとつ前に検出された目の開け具合:Double = 0.0
    var まばたきし始めた時刻:Date?
    var まばたきし続けてる時刻:Date?
    
    let 瞼の開け具合の閾値:Double = 0.8
    let 瞼を閉じ続ける時間の閾値:Double = 0.15
    
    var まだページ送りしてない:Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        まばたきし始めた時刻 = Date()
        まばたきし続けてる時刻 = Date()
        
        pdfビュー.autoScales = true
        pdfビュー.displayMode = .singlePage
        pdfビュー.displaysPageBreaks = false
        pdfビュー.pageShadowsEnabled = true
        pdfビュー.isUserInteractionEnabled = false
        
        if let サンプルURL = Bundle.main.url(forResource: "WELCOME", withExtension: "pdf") {
            if let 開くPDF = PDFDocument(url: サンプルURL) {
                pdfビュー.document = 開くPDF
                pdfビュー.goToFirstPage(nil)
            }
        }
        
        sceneビュー.delegate = self
        sceneビュー.session.delegate = self
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneビュー.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneビュー.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        let SWIPE👈🏼 = UISwipeGestureRecognizer(target: self, action: #selector(self.nextページ(_:)))
        SWIPE👈🏼.direction = .left
        self.view.addGestureRecognizer(SWIPE👈🏼)
        
        let SWIPE👉🏼 = UISwipeGestureRecognizer(target: self, action: #selector(self.previousページ(_:)))
        SWIPE👉🏼.direction = .right
        self.view.addGestureRecognizer(SWIPE👉🏼)
        
        let SWIPE👆🏼 = UISwipeGestureRecognizer(target: self, action: #selector(self.pickerを呼び出す(_:)))
        SWIPE👆🏼.direction = .up
        self.view.addGestureRecognizer(SWIPE👆🏼)
        
        let SWIPE👇🏼 = UISwipeGestureRecognizer(target: self, action: #selector(self.前回のPDFを開く(_:)))
        SWIPE👇🏼.direction = .down
        self.view.addGestureRecognizer(SWIPE👇🏼)
        
        let TAP🤘🏼 = UITapGestureRecognizer(target: self, action: #selector(self.PLAY📺))
        TAP🤘🏼.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(TAP🤘🏼)
        
        let PINCH👌🏼 = UIPinchGestureRecognizer(target: self, action: #selector(self.👌🏼(_:)))
        self.view.addGestureRecognizer(PINCH👌🏼)
        
    }
    
    @objc func 👌🏼(_ sender:UIPinchGestureRecognizer){
        if sender.velocity > 0 {
            pdfビュー.goToNextPage(nil)
        }else{
            pdfビュー.goToPreviousPage(nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        pdfビュー.autoScales = true
    }
    
    @objc func nextページ(_ sender: Any) {
        pdfビュー.goToNextPage(nil)
    }

    @objc func previousページ(_ sender: Any) {
        pdfビュー.goToPreviousPage(nil)
    }
    
    @objc func 前回のPDFを開く(_ sender: Any) {
        let fm = FileManager.default
        if let d = PDFDocument(url: URL(string: fm.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!){
            pdfビュー.autoScales = true
            pdfビュー.document = d
            pdfビュー.goToFirstPage(nil)
        }
        BGLabel.isHidden = true
    }
    
    @objc func pickerを呼び出す(_ sender: Any) {
        let ピッカー = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        ピッカー.delegate = self
        self.present(ピッカー, animated: true, completion: nil)
    }
    
    @objc func PLAY📺(){
        guard let 📍 = Bundle.main.url(forResource: "demo", withExtension: "mp4") else {return}
        let 🎞 = AVPlayer(url: 📍)
        let 👩🏻‍💻 = AVPlayerViewController()
        👩🏻‍💻.player = 🎞
        present(👩🏻‍💻, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        pdfビュー.autoScales = true
        pdfビュー.document = PDFDocument(url: urls.first!)
        pdfビュー.goToFirstPage(nil)
        BGLabel.isHidden = true
        
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
    }

    @objc func 左矢印で前のページへ移動(command: UIKeyCommand) {
        pdfビュー.goToPreviousPage(nil)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
