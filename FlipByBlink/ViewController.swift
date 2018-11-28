//諸設定
//カメラプライバシ
//DocumentTypePDF
//hiddenStatusBar
//upSideDown

import UIKit
import PDFKit
import ARKit

class ViewController: UIViewController,ARSessionDelegate,ARSCNViewDelegate  {
    
    @IBOutlet weak var pdfビュー: PDFView!
    
    @IBOutlet weak var sceneビュー: ARSCNView!
    
    var ひとつ前に検出された目の開け具合:Double = 0.0
    var まばたきし始めた時刻:Date?
    var まばたきし続けてる時刻:Date?
    
    let 瞼の開け具合の閾値:Double = 0.8
    let 瞼を閉じ続ける時間の閾値:Double = 0.15
    
    var まだページ送りしてない:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        まばたきし始めた時刻 = Date()
        まばたきし続けてる時刻 = Date()
        
        if let サンプルURL = Bundle.main.url(forResource: "サンプル", withExtension: "pdf") {
            if let 開くPDF = PDFDocument(url: サンプルURL) {
                pdfビュー.autoScales = true
                pdfビュー.displayMode = .singlePage
                pdfビュー.backgroundColor = .clear
                pdfビュー.displaysPageBreaks = false
                pdfビュー.document = 開くPDF
            }
        }
        
        sceneビュー.delegate = self
        sceneビュー.session.delegate = self
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneビュー.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneビュー.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    @IBAction func nextページ(_ sender: Any) {
        pdfビュー.goToNextPage(nil)
    }
    @IBAction func 高速でページ進める(_ sender: Any) {
        pdfビュー.goToNextPage(nil)
    }
    @IBAction func previousページ(_ sender: Any) {
        pdfビュー.goToPreviousPage(nil)
    }
    @IBAction func 高速でページ戻す(_ sender: Any) {
        pdfビュー.goToPreviousPage(nil)
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

