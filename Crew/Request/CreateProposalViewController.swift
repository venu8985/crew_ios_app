//
//  CreateProposalViewController.swift
//  Crew
//
//  Created by Rajeev on 14/04/21.
//

import UIKit
import AWSS3
import AWSCore
import MobileCoreServices
import SafariServices

class CreateProposalViewController: UIViewController , UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var attachmentLabel : UILabel!
    var attachmentString : String!
    var imagePicker : UIImagePickerController!
    var descriptionTextView : UITextView!
    var hire_agency_id : Int!
    var attachmentBGView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white

        let descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("Description", comment: "")
        descriptionLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
        }
        
        descriptionTextView = UITextView()
        descriptionTextView.textAlignment = .justified
        self.view.addSubview(descriptionTextView)
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(05)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(270)
        }
                
        
        let borderView = UIView()
        self.view.addSubview(borderView)
        
        borderView.layer.borderColor = Color.liteGray.cgColor
        borderView.layer.borderWidth = 0.5
        borderView.layer.cornerRadius = 10.0
        borderView.clipsToBounds = true
        
        borderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(5)
            make.leading.trailing.equalTo(self.view).inset(10)
            make.bottom.equalTo(descriptionTextView).offset(5)
        }
        
        self.view.sendSubviewToBack(borderView)

        /*
        let attachImage = UIImage(named: "attachment")?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
        let attachButton = UIButton()
        attachButton.addTarget(self, action: #selector(self.attachButtonAction), for: .touchUpInside)
        attachButton.setImage(attachImage, for: .normal)
        self.view.addSubview(attachButton)
        attachButton.backgroundColor = Color.liteGray
        
        attachButton.snp.makeConstraints { (make) in
            make.leading.equalTo(descriptionTextView)
            make.top.equalTo(borderView.snp.bottom).offset(05)
            make.width.height.equalTo(40)
        }
        attachButton.layer.cornerRadius = 10
        attachButton.clipsToBounds = true
        
        attachmentLabel = UILabel()
        attachmentLabel.text = " attachment"
        attachmentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        attachmentLabel.textColor = Color.red
        self.view.addSubview(attachmentLabel)
        
        attachmentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(attachButton.snp.trailing).offset(05)
            make.centerY.equalTo(attachButton)
        }
        attachmentLabel.isUserInteractionEnabled = true
        attachmentLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(attachButtonAction)))
        */
        
        // Attachment UI
        attachmentBGView = UIView()
        self.view.addSubview(attachmentBGView)
        
        attachmentBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(10)
            make.top.equalTo(borderView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }

        
        let attachmentImageView = UIImageView()
        attachmentImageView.image = UIImage(named: "attachment")
        attachmentImageView.contentMode = .scaleAspectFit
        attachmentBGView.addSubview(attachmentImageView)

        attachmentImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25    ) {
            
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = Color.liteGray.cgColor
            yourViewBorder.lineDashPattern = [6, 2]
            yourViewBorder.frame = self.attachmentBGView.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.attachmentBGView.bounds).cgPath
            self.attachmentBGView.layer.addSublayer(yourViewBorder)
        }
        
        attachmentLabel = UILabel()
        attachmentLabel.text = NSLocalizedString("Registration attachment", comment: "")
        attachmentLabel.textColor = Color.gray
        attachmentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        attachmentBGView.addSubview(attachmentLabel)
        
        attachmentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(attachmentImageView.snp.trailing).offset(20)
            make.trailing.equalTo(attachmentBGView).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        
        
        attachmentLabel.isUserInteractionEnabled = true
        attachmentBGView.isUserInteractionEnabled = true
        attachmentImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.attachButtonAction))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.attachButtonAction))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.attachButtonAction))

        attachmentLabel.addGestureRecognizer(tap)
        attachmentBGView.addGestureRecognizer(tap1)
        attachmentImageView.addGestureRecognizer(tap2)
        
        
        let infoLabel = UILabel()
        infoLabel.text = NSLocalizedString("You can upload JPEG, PNG and PDF files", comment: "")
        infoLabel.textColor = Color.liteBlack
        infoLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        attachmentBGView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(attachmentImageView)
            make.top.equalTo(attachmentBGView.snp.bottom).offset(10)
        }
        
        
        
        let sendButton = UIButton()
        sendButton.setTitle(NSLocalizedString("Send Proposal", comment: ""), for: .normal)
        sendButton.backgroundColor = Color.red
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        sendButton.addTarget(self, action: #selector(self.sendButtonAction), for: .touchUpInside)
        self.view.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(25)
        }
        
        sendButton.layer.cornerRadius = 5.0
        sendButton.clipsToBounds = true
        
        
        let lineView5 = UIView()
        lineView5.backgroundColor = Color.liteGray
        self.view.addSubview(lineView5)
        
        lineView5.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(sendButton.snp.top).offset(-10)
        }
        self.navigationBarItems()
    }
    
    func navigationBarItems() {
        self.title = NSLocalizedString("Send Proposal", comment: "")
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.setImage(UIImage(named: "back-R"), for: .normal)
        }else{
            backButton.setImage(UIImage(named: "back"), for: .normal)
        }
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
        backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);
        }else{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        }
        
    }
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func sendButtonAction(){

        if descriptionTextView.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please enter valid description", comment: ""))
            return
        }else if attachmentString == nil{
            Banner().displayValidationError(string: NSLocalizedString("Please attach file to proceed", comment: ""))
            return
        }
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id" : hire_agency_id ?? 0,
            "description" : descriptionTextView.text ?? "",
            "proposal_file" : attachmentString ?? ""
        ]

        WebServices.postRequest(url: Url.createProposal, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let requestDetails = try decoder.decode(ProposalDetails.self, from: data)
                let request = requestDetails.data
                
                NotificationCenter.default.post(name: Notification.agencyRequests, object: nil)
                Banner().displaySuccess(string: NSLocalizedString("Proposal created succesfully", comment: ""))
                let vc = UIStoryboard.instantiateViewController(withViewClass: ProposalWalletViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                vc.proposalId = request?.id ?? 0
                vc.completionHandler = { status in
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(vc, animated: true)
            }catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    @objc func attachButtonAction(){

        
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Choose option to upload attachment", comment: "") , preferredStyle: UIAlertController.Style.actionSheet)

        let gallertyAction = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.openGallary()
        }
        
        let docAction = UIAlertAction(title: NSLocalizedString("Documents", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.openDocuments()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(gallertyAction)
        alertController.addAction(docAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
        
    //MARK : Document picker
    @objc func openDocuments() {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls[0])
        
        let urlString = urls[0].absoluteString

        let extType = urlString.components(separatedBy: ".").last ?? ""
        let mimeType = urlString.mimeType()
        
        
        do {
            let fileData = try Data(contentsOf: urls[0])
            
            uploadFile(awsBucket: AWSBucket.proposals, fileData: fileData, mimeType: mimeType, ext: extType) { (response, file) in
                self.attachmentString = file
                DispatchQueue.main.async {
                    self.attachmentLabel.text = file
                    self.attachmentLabel.textColor = .black
                }
            }
        }catch let error{
            
            print("error \(error.localizedDescription)")
            
        }
        
    }
    
    //MARK: image picker

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            let imageData = pickedImage.jpegData(compressionQuality: 1.0) ?? Data()
            uploadFile(awsBucket: AWSBucket.proposals, fileData: imageData, mimeType: "image/jpg", ext: "jpg") { (response, image) in
                self.attachmentString = image
                DispatchQueue.main.async {
                    self.attachmentLabel.text = image
                }
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: uploading image to aws
    
    func uploadFile(awsBucket:String,fileData: Data, mimeType : String, ext : String, completion: @escaping(String, String) -> Void) {
        
//        WebServices.showProgressHUD(title: NSLocalizedString("Uploading...", comment: ""), viewController: self)
        GGProgress.shared.show(with: "Uploading...")

        
        let imgName = AppDelegate.randomString(length: 12) + ".\(ext)"
        
        let keyname = "\(awsBucket)/" +  imgName

           
           let fileManager = FileManager.default
           let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(imgName)")
          // let imageData = image.jpegData(compressionQuality: 0)
           fileManager.createFile(atPath: path as String, contents: fileData, attributes: nil)
           
           let fileUrl = NSURL(fileURLWithPath: path)
           
           let uploadRequest = AWSS3TransferManagerUploadRequest()!
           uploadRequest.body = fileUrl as URL
           uploadRequest.key = keyname
           uploadRequest.bucket = UserDefaults.standard.value(forKey: AWS.AWS_BUCKET) as? String ?? ""
           uploadRequest.contentType = mimeType
           uploadRequest.acl = .publicRead
           
           let transferManager = AWSS3TransferManager.default()
           transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
               if let error = task.error {
                debugPrint("Upload failed with error: (\(error.localizedDescription))")
               }
              
               if task.result != nil {
                   let url = AWSS3.default().configuration.endpoint.url
                   let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                

                DispatchQueue.main.async {
                    GGProgress.shared.hide()

                }
                
                   completion("\(publicURL!)", imgName)
               }
               return nil
           })
       }
    

}
