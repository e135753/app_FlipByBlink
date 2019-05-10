//====🛠setting⚙️====
//CameraPrivacy
//DocumentTypePDF
//hiddenStatusBar
//upSideDown

import UIKit
import PDFKit
import ARKit
import AVKit

class ViewController: UIViewController,ARSessionDelegate,ARSCNViewDelegate,UIDocumentPickerDelegate {
    
    @IBOutlet weak var 📖: PDFView!
    
    @IBOutlet weak var ⒷⒼ: UILabel!
    
    var Ⓐ: ARSCNView!
    
    var 🕰😑start: Date?
    var 🕰😑🔛: Date?
    let 🎚😑sec: Double = 0.15
    
    var ex🌡👀: Double = 0.0
    let 🎚👀: Double = 0.8
        
    var not🗒yet: Bool = true
    
    override func viewDidLoad() {
        super .viewDidLoad()
        Ⓐ = ARSCNView()
        view.addSubview(Ⓐ)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        🕰😑start = Date()
        🕰😑🔛 = Date()
        
        📖.autoScales = true
        📖.displayMode = .singlePage
        📖.displaysPageBreaks = false
        📖.pageShadowsEnabled = true
        📖.isUserInteractionEnabled = false
        if let 📍 = Bundle.main.url(forResource: "WELCOME", withExtension: "pdf") {
            if let 📘 = PDFDocument(url: 📍) {
                📖.document = 📘
                📖.goToFirstPage(nil)
            }
        }
        
        Ⓐ.delegate = self
        Ⓐ.session.delegate = self
        let 🎛 = ARFaceTrackingConfiguration()
        Ⓐ.session.run(🎛, options: [.resetTracking, .removeExistingAnchors])
        Ⓐ.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        let 👆🏼三三 = UISwipeGestureRecognizer(target: self, action: #selector(self.🗒(_:)))
        👆🏼三三.direction = .left
        self.view.addGestureRecognizer(👆🏼三三)
        
        let 三三👆🏼 = UISwipeGestureRecognizer(target: self, action: #selector(self.🗒🔙(_:)))
        三三👆🏼.direction = .right
        self.view.addGestureRecognizer(三三👆🏼)
        
        let 彡👆🏼ミ = UISwipeGestureRecognizer(target: self, action: #selector(self.📤📚(_:)))
        彡👆🏼ミ.direction = .up
        self.view.addGestureRecognizer(彡👆🏼ミ)
        
        let ミ👆🏼彡 = UISwipeGestureRecognizer(target: self, action: #selector(self.📤last📘(_:)))
        ミ👆🏼彡.direction = .down
        self.view.addGestureRecognizer(ミ👆🏼彡)
        
        let 🤘🏼゛ = UITapGestureRecognizer(target: self, action: #selector(self.📺))
        🤘🏼゛.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(🤘🏼゛)
        
        let 氵👌🏼 = UIPinchGestureRecognizer(target: self, action: #selector(self.🗒🗒🗒🗒(_:)))
        self.view.addGestureRecognizer(氵👌🏼)
    }
    
    @objc func 🗒🗒🗒🗒(_ sender:UIPinchGestureRecognizer){
        if sender.velocity > 0 {
            📖.goToNextPage(nil)
        }else{
            📖.goToPreviousPage(nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        📖.autoScales = true
    }

    @IBAction func 🗒(_ sender: Any) {
        📖.goToNextPage(nil)
    }
    
    @IBAction func 🗒🔙(_ sender: Any) {
        📖.goToPreviousPage(nil)
    }
    
    @objc func 📤last📘(_ sender: Any) {
        let 🗂 = FileManager.default
        if let 📘 = PDFDocument(url: URL(string: 🗂.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!){
            📖.autoScales = true
            📖.document = 📘
            📖.goToFirstPage(nil)
        }
        ⒷⒼ.isHidden = true
    }
    
    @objc func 📤📚(_ sender: Any) {
        let 👩🏻‍💻 = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        👩🏻‍💻.delegate = self
        self.present(👩🏻‍💻, animated: true, completion: nil)
    }
    
    @objc func 📺(){
        guard let 📍 = Bundle.main.url(forResource: "demo", withExtension: "mp4") else {return}
        let 🎞 = AVPlayer(url: 📍)
        let 👩🏻‍💻 = AVPlayerViewController()
        👩🏻‍💻.player = 🎞
        present(👩🏻‍💻, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        📖.autoScales = true
        📖.document = PDFDocument(url: urls.first!)
        📖.goToFirstPage(nil)
        ⒷⒼ.isHidden = true
        
        let 🗂 = FileManager.default
        let 📍 = URL(string: 🗂.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + "OpenedPDF.pdf")!
        
        do{ try 🗂.removeItem(at: 📍)
        }catch{ print("👿") }
        
        do{ try 🗂.copyItem(at: urls.first!, to: 📍)
        }catch{ print("👿") }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let 🏷 = anchor as? ARFaceAnchor else { return }
        let 🌡👀 = 🏷.blendShapes[.eyeBlinkLeft]?.doubleValue
        
        if 🌡👀! > 🎚👀 && ex🌡👀 < 🎚👀{
            🕰😑start = Date()
        }
        
        if 🌡👀! > 🎚👀{
            🕰😑🔛 = Date()
            if 🕰😑🔛!.timeIntervalSince(🕰😑start!) > TimeInterval(🎚😑sec){
                if not🗒yet{
                    DispatchQueue.main.async {
                        self.📖.goToNextPage(nil)
                    }
                    not🗒yet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.not🗒yet = true
                    }
                }
            }
        }
        ex🌡👀 = 🌡👀!
    }
    
    override var keyCommands: [UIKeyCommand]?{
        let a = [UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: #selector(🗒arrow🅁key(command:))),
                        UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: #selector(🗒🔙arrow🄻key(command:)))]
        return a
    }
    
    @objc func 🗒arrow🅁key(command: UIKeyCommand) {
        📖.goToNextPage(nil)
    }

    @objc func 🗒🔙arrow🄻key(command: UIKeyCommand) {
        📖.goToPreviousPage(nil)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
