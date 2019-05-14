
import UIKit
import PDFKit
import ARKit

class PdfController: UIViewController,ARSessionDelegate,ARSCNViewDelegate {
    
    @IBOutlet weak var 📖: PDFView!
    var Ⓐ: ARSCNView!
    
    var 🕰😑start: Date!
    var 🕰😑🔛: Date!
    let 🎚😑sec: Double = 0.15
    
    var ex🌡👀: Double = 0.0
    let 🎚👀: Double = 0.8
    
    var not🗒yet: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        📖.autoScales = true
        📖.displayMode = .singlePage
        📖.displaysPageBreaks = false
        📖.pageShadowsEnabled = true
        📖.isUserInteractionEnabled = false
        
        if let 📍 = Bundle.main.url(forResource: "WELCOME", withExtension: "pdf") {
            if let 📘 = PDFDocument(url: 📍) {
                📘.page(at: 0)?.thumbnail(of: CGSize(width: 100, height: 100), for: .trimBox)
                📖.document = 📘
                📖.goToFirstPage(nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        🕰😑start = Date()
        🕰😑🔛 = Date()
        
        Ⓐ = ARSCNView()
        view.addSubview(Ⓐ)
        
        Ⓐ.delegate = self
        Ⓐ.session.delegate = self
        let 🎛 = ARFaceTrackingConfiguration()
        Ⓐ.session.run(🎛, options: [.resetTracking, .removeExistingAnchors])
        Ⓐ.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    @IBAction func 👆🏼三三(_ sender: Any) {
        🗒()
    }
    
    @IBAction func 三三👆🏼(_ sender: Any) {
        🗒🔙()
    }

    @IBAction func ミ👆🏼彡(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func 氵👌🏼(_ sender: UIPinchGestureRecognizer) {
        if sender.velocity > 0 {
            🗒()
        }else{
            🗒🔙()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let 🏷 = anchor as? ARFaceAnchor else { return }
        guard let 🌡👀 = 🏷.blendShapes[.eyeBlinkLeft]?.doubleValue else { return }
        
        if 🌡👀 > 🎚👀 && ex🌡👀 < 🎚👀{
            🕰😑start = Date()
        }
        
        if 🌡👀 > 🎚👀{
            🕰😑🔛 = Date()
            if 🕰😑🔛.timeIntervalSince(🕰😑start) > TimeInterval(🎚😑sec){
                if not🗒yet{
                    DispatchQueue.main.async {
                        self.🗒()
                    }
                    not🗒yet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.not🗒yet = true
                    }
                }
            }
        }
        ex🌡👀 = 🌡👀
    }
    
    override var keyCommands: [UIKeyCommand]?{
        let a = [UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: #selector(🗒)),
                 UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: #selector(🗒🔙))]
        return a
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        📖.autoScales = true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc func 🗒(){
        📖.goToNextPage(nil)
    }
    
    @objc func 🗒🔙(){
        📖.goToPreviousPage(nil)
    }
}
