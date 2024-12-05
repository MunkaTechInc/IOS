//
//  ChatViewController.swift
//  SocketChatDemo
//
//  Created by Puneet Sharma on 10/12/19.
//  Copyright © 2019 Hitaishin. All rights reserved.
//

import UIKit
import SocketIO
import JSQMessagesViewController
import QuickLook
import SafariServices
import IQKeyboardManagerSwift

class CustomDocumentMediaItem: JSQMediaItem, UIDocumentInteractionControllerDelegate {
    var documentImage: UIImage?
    var fileName: String?
    var senderId: String? // Property to store the sender ID
    var documentURL: URL? // URL of the document
    var localFileURL: URL? // URL of the document
    
    var documentController: UIDocumentInteractionController?
    var documentUrl: URL!
    
    
    weak var delegate: UIViewController?
    let previewController = QLPreviewController()
    override func mediaViewDisplaySize() -> CGSize {
        return CGSize(width: 200, height: 70) // Adjust size as needed
    }
    
    override func mediaView() -> UIView! {
        let containerView = UIView(frame: CGRect(origin: .zero, size: mediaViewDisplaySize()))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(documentTapped)))
        
        // Set background color based on sender
        let bubbleImageView = UIImageView(image: bubbleImage())
        bubbleImageView.frame = containerView.bounds
        bubbleImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(bubbleImageView)
        
        // Add document image icon
        if let image = documentImage {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            let imageWidth: CGFloat = 50 // Width of the document image icon
            imageView.frame = CGRect(x: 5, y: 0, width: imageWidth, height: mediaViewDisplaySize().height)
            containerView.addSubview(imageView)
        }
        
        // Add file name label
        if let fileName = fileName {
            let labelWidth = mediaViewDisplaySize().width - 55 // Subtract the width of the image
            let fileNameLabel = UILabel(frame: CGRect(x: 55, y: 0, width: labelWidth, height: mediaViewDisplaySize().height))
            fileNameLabel.textColor = .white
            fileNameLabel.text = fileName
            fileNameLabel.numberOfLines = 2
            containerView.addSubview(fileNameLabel)
        }
        
        return containerView
    }
    
    
    // Helper method to get the bubble image based on sender
    private func bubbleImage() -> UIImage {
        if MyDefaults().UserId ?? "" == self.senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen()).messageBubbleImage
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue()).messageBubbleImage
        }
    }
    
    // Selector method for document tap gesture
    @objc func documentTapped() {
        guard let url = documentURL else { return }
        
        let fileName = url.lastPathComponent
        let documentsDirectory = FileManager.default.temporaryDirectory
        let localFileUrl = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: localFileUrl.path) {
            // File already exists locally, present it directly
            presentDocumentController(with: localFileUrl)
        } else {
            // File doesn't exist locally, download it
            downloadDocument(from: url)
            
        }
    }
    
    // Function to download the document from a remote URL
    func downloadDocument(from url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { [weak self] (tempLocalUrl, response, error) in
            guard let self = self else { return }
            
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Move the downloaded file to a temporary directory
                let documentsDirectory = FileManager.default.temporaryDirectory
                let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                
                do {
                    try FileManager.default.moveItem(at: tempLocalUrl, to: destinationUrl)
                    // Set local document URL
                    self.documentUrl = destinationUrl
                    // Present the document interaction controller
                    DispatchQueue.main.async {
                        self.presentDocumentController(with: destinationUrl)
                    }
                } catch {
                    print("Error moving file: \(error)")
                }
            } else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
    
    // Function to present the document interaction controller with the local document URL
    func presentDocumentController(with url: URL) {
        documentController = UIDocumentInteractionController(url: url)
        documentController?.delegate = self
        documentController?.presentPreview(animated: true)
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.delegate!
    }
    
    private func downloadDocument(from url: URL, completion: @escaping (URL?) -> Void) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(fileName ?? "document")
        
        // Check if file already exists at destination
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            completion(destinationURL)
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationURL)
                    completion(destinationURL)
                } catch (let writeError) {
                    print("Error creating a file \(destinationURL) : \(writeError)")
                    completion(nil)
                }
            } else {
                print("Error downloading document: \(error?.localizedDescription ?? "")")
                completion(nil)
            }
        }
        downloadTask.resume()
    }
    
}

// Conformance to QLPreviewControllerDataSource to handle document preview
extension CustomDocumentMediaItem: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        print("previewItemAt localFileURL = ",localFileURL)
        return localFileURL! as QLPreviewItem
    }
    
}

class CustomDocumentMessageCell: JSQMessagesCollectionViewCell {
    let documentIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let documentNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add document icon image view
        addSubview(documentIconImageView)
        NSLayoutConstraint.activate([
            documentIconImageView.leadingAnchor.constraint(equalTo: messageBubbleContainerView.leadingAnchor, constant: 8),
            documentIconImageView.centerYAnchor.constraint(equalTo: messageBubbleContainerView.centerYAnchor),
            documentIconImageView.widthAnchor.constraint(equalToConstant: 30),
            documentIconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Add document name label
        
        addSubview(documentNameLabel)
        NSLayoutConstraint.activate([
            documentNameLabel.leadingAnchor.constraint(equalTo: documentIconImageView.trailingAnchor, constant: 8),
            documentNameLabel.trailingAnchor.constraint(equalTo: messageBubbleContainerView.trailingAnchor, constant: -8),
            documentNameLabel.topAnchor.constraint(equalTo: messageBubbleContainerView.topAnchor, constant: 8),
            documentNameLabel.bottomAnchor.constraint(equalTo: messageBubbleContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust layout for outgoing messages
        if self.messageBubbleImageView.isUserInteractionEnabled {
            self.messageBubbleImageView.frame = CGRect(x: self.contentView.bounds.width - 100,
                                                       y: self.messageBubbleImageView.frame.origin.y,
                                                       width: self.messageBubbleImageView.frame.width,
                                                       height: self.messageBubbleImageView.frame.height)
        } else {
            // Adjust layout for incoming messages
            self.messageBubbleImageView.frame = CGRect(x: 20,
                                                       y: self.messageBubbleImageView.frame.origin.y,
                                                       width: self.messageBubbleImageView.frame.width,
                                                       height: self.messageBubbleImageView.frame.height)
        }
    }
    
}


class ChatViewController: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    //MARK:- Outlets
    @IBOutlet var tblViewChatList: UITableView!
    @IBOutlet var tfMessage: UITextField!
    @IBOutlet var btnMediaPicker: IBButton!
    @IBOutlet var viewContentFullScreenImage: UIView!
    @IBOutlet var imgViewFullScreenImage: UIImageView!
    @IBOutlet var viewContentDocumentFullScreen: UIView!
    @IBOutlet var viewDocumentWebView: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblPostDetails: UILabel!
    @IBOutlet var lblProfile: UILabel!
    let picker = UIImagePickerController()
    var parentNavigationController: UINavigationController?
    @IBOutlet var inputToolbarBottomConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    var arrChatMessage = [[String:Any]]()
    var messages = [CustomJSQMessage]() // Array to hold JSQMessage objects
    
    var room_id = ""
    var sender_id = ""
    var messageText = ""
    var receiver_Id = ""
    var job_Id = ""
    var profileName = ""
    var dictEmpty = [String:Any]()
    var strTitle = ""
    var strImgeUrl = ""
    var strDocUrl = ""
    var pageNumber: Int = 1
    var isTotalCountReached : Bool = false
    var isApiCalled: Bool = false
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        
        collectionView?.collectionViewLayout.springinessEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        // Register custom cell class if needed
        collectionView.register(CustomDocumentMessageCell.self, forCellWithReuseIdentifier: "CustomDocumentMessageCell")
        //        collectionView.register(CustomJSQMessagesCollectionViewCell.self, forCellWithReuseIdentifier: JSQMessageCollectionViewCellReuseIdentifier)
        picker.delegate = self
        self.edgesForExtendedLayout = []
        self.collectionView?.collectionViewLayout.sectionInset = UIEdgeInsets(top: 15, left: 5, bottom: 70, right: 5)
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        // Remove attachment button
        
        self.hidesBottomBarWhenPushed = true
        //        self.title = strTitle
        //        let imgViewUserImage = UIImageView()
        //       imgViewUserImage.sd_setImage(with: URL(string: strImgeUrl), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        //        let item = UIBarButtonItem(customView: imgViewUserImage)
        //  self.navigationItem.rightBarButtonItem = item
        
        self.tblViewChatList.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        dictEmpty = ["sender_id":sender_id,"receiver_id":receiver_Id,"message":"","type":"Text","file_type":""] // Send in starting to establish channel
        //        self.callChatHistoryAPIToGetAllChatBetweenUsers() //Calling Chat history from Server API
        imgProfile.sd_setImage(with: URL(string: strImgeUrl), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        self.lblProfile.text = strTitle
        if isConnectedToInternet(){
            self.callChatHistoryAPIToGetAllChatBetweenUsers()
        }else{
            self.showErrorPopup(message: "No Internet", title: alert)
        }
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow(_:)),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide(_:)),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setInitialUI()
        self.connectSocket() //initialize socket and get message from socket channel and reload data after getting new one
        SocketIOManager.socket.emit("send_message", dictEmpty)//Send empty msg to connect chat
//        IQKeyboardManager.shared.enable = false
        self.automaticallyScrollsToMostRecentMessage = true
//        self.inputToolbar
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared.enable = true
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        self.messageText = self.inputToolbar.contentView.textView.text
        self.inputToolbar.contentView.textView.text = ""
        self.inputToolbar.contentView.textView.resignFirstResponder()
        self.sendTextMsg()
    }
   
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputToolbarBottomConstraint.constant = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.inputToolbarBottomConstraint.constant = 0
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        let outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        // Set receiver's message bubble color
        let incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        if message.senderId! == self.sender_id {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func senderId() -> String {
        return self.sender_id
    }
    
    //    func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, layoutAttributesForItemAt indexPath: IndexPath!) -> UICollectionViewLayoutAttributes!{
    //        let attributes = JSQMessagesCollectionViewLayoutAttributes(forCellWith: indexPath)
    //
    //        let message = messages[indexPath.item]
    //        let isOutgoingMessage = message.senderId! == self.sender_id
    ////        collectionViewLayout.
    //        // Adjust bubble width based on message length or other criteria
    //        let bubbleWidth = calculateBubbleWidthForMessage(message)
    //
    //        // Set the bubble size
    //        print("isOutgoingMessage is true : ",isOutgoingMessage)
    //        // Set the message bubble's position based on whether it's outgoing or incoming
    //        if isOutgoingMessage {
    //            attributes.center.x = collectionView.bounds.width - bubbleWidth / 2 - 10
    //        } else {
    //            attributes.center.x = bubbleWidth / 2 + 10
    //        }
    //
    //        return attributes
    //    }
    
    func calculateBubbleWidthForMessage(_ message: JSQMessage) -> CGFloat {
        // You can adjust this value based on your layout requirements
        let maxWidth: CGFloat = 200
        
        // Get the text of the message
        guard let messageText = message.text else {
            return maxWidth // Return a default width if the message text is nil
        }
        
        // Calculate the size of the message text using a NSString method
        let messageSize = (messageText as NSString).boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                                                                 options: .usesLineFragmentOrigin,
                                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], // Use the appropriate font for your message bubble
                                                                 context: nil).size
        
        // Add any additional padding to the calculated width
        let bubbleWidth = ceil(messageSize.width) + 10
        
        return min(bubbleWidth, maxWidth) // Return the calculated width, ensuring it doesn't exceed the maximum width
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil // Return nil if no profile picture is available
    }
    
    // Override to customize message bubble colors
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        // Optional: Implement to display a timestamp for each message
        let message = messages[indexPath.item]
        if indexPath.item == 0 {
            // Show the time for the first message
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm a" // Customize date format as needed
            let dateString = formatter.string(from: message.date!)
            return NSAttributedString(string: dateString)
        } else {
            //            // Compare current message's date with the previous message's date
            let previousMessage = messages[indexPath.item - 1]
            if Calendar.current.isDate(message.date!, inSameDayAs: previousMessage.date!) {
                // If the current message and the previous message are on the same day, don't show the time
                return nil
            } else {
                // If the current message and the previous message are on different days, show the time
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm a" // Customize date format as needed
                let dateString = formatter.string(from: message.date!)
                return NSAttributedString(string: dateString)
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        // Optional: Implement to display the sender's name above the message bubble
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        let message = messages[indexPath.item]
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }else {
            let previousMessage = messages[indexPath.item - 1]
            if Calendar.current.isDate(previousMessage.date, inSameDayAs: message.date) {
                return 0.0
            }else {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        // Optional: Implement to specify the height of the sender's name label
        return 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, didTapMessageBubbleAt indexPath: IndexPath) {
        let message: JSQMessage? = messages[indexPath.item]
        
        if message?.isMediaMessage != nil {
            let mediaItem: JSQMessageMediaData? = message?.media
            if (mediaItem is JSQPhotoMediaItem) {
                
                let photoItem = mediaItem as? JSQPhotoMediaItem
                let newImageView = UIImageView(image: photoItem?.image)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
            }
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        self.navigationController?.isNavigationBarHidden = false
    //        SocketIOManager.sharedInstance.closeConnection()
    //        SocketIOManager.socket.off("get_message")
    //    }
    //
    //    override func viewDidDisappear(_ animated: Bool) {
    //        SocketIOManager.sharedInstance.closeConnection()
    //        SocketIOManager.socket.off("get_message")
    //    }
    //
    //MARK:- Supporting Functions
    // Socket INIT
    func connectSocket(){
        SocketIOManager.sharedInstance.establishConnection()
        var dictEmpty1 = ["userId":MyDefaults().UserId ?? ""]
        SocketIOManager.socket.emit("setup", dictEmpty1)
        SocketIOManager.socket.on("get_message") { (result, SocketAckEmitter) in
            print(result)
            let chatDict = result[0] as! [String:Any]
            if chatDict["message"] as! String != ""{
                
                var dictionary =  [String:Any]()
                dictionary ["message"] = chatDict["message"]
                dictionary ["original_file_name"] = chatDict["original_file_name"]
                dictionary ["profile_pic"] = chatDict["profile_pic"]
                dictionary ["receiver_id"] = chatDict["receiver_id"]
                dictionary ["sender_id"] = chatDict["sender_id"]
                dictionary ["type"] = chatDict["type"]
                dictionary ["created"] = getCurrentShortDate()
                
                self.arrChatMessage.append(dictionary)
                
                //                if self.arrChatMessage.count > 0{
                //                    self.collectionView.reloadData()
                //                }
                
                let senderId = chatDict["sender_id"] as? String ?? ""
                let displayName = chatDict["receiver_id"] as? String ?? ""
                let text = chatDict["message"] as? String ?? ""
                let date = getCurrentShortDate()
                let messageType = chatDict["type"] as? String ?? ""
                let strEditedDate = date.replacingOccurrences(of: ".000Z", with: "")
                let strNewDate = strEditedDate.replacingOccurrences(of: "T", with:" " )
                
                var message: CustomJSQMessage?
                switch messageType {
                case "Text":
                    message = CustomJSQMessage(senderId: senderId, senderDisplayName: displayName, date: self.dateFromString(dateString: strNewDate), text: text)
                case "Image":
                    let imagename = chatDict["message"] as? String ?? ""
                    let photo = JSQPhotoMediaItem()
                    if let url = NSURL(string:chat_img_BASE_URL + imagename){
                        guard let data = NSData(contentsOf: url as URL) else{ return }
                        let image = UIImage(data: data as Data)
                        photo.image = image
                        photo.appliesMediaViewMaskAsOutgoing = true
                        message = CustomJSQMessage(senderId: senderId, senderDisplayName: displayName, date: self.dateFromString(dateString: strNewDate)!, media: photo)
                    }
                case "Document":
                    var documentmessage = chatDict["message"] as? String ?? ""
                    if let documentUrl = chatDict["original_file_name"] as? String {
                        let documentImage = UIImage(named: "doc_file") // Your document icon image
                        let documentItem = CustomDocumentMediaItem()
                        documentItem.documentImage = documentImage
                        documentItem.fileName = documentUrl // File name here
                        documentItem.senderId = senderId
                        let urlDocument = URL(string:chat_img_BASE_URL + documentmessage)
                        documentItem.documentURL = urlDocument
                        documentItem.delegate = self
                        message = CustomJSQMessage(senderId: senderId, senderDisplayName: displayName, date: self.dateFromString(dateString: strNewDate)!, media: documentItem)
                    }
                default:
                    break
                }
                
                if let message = message {
                    self.messages.append(message)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.scrollToBottom(animated: true) // Optional: Scroll to the bottom after reloading
                }
            }
        }
        SocketIOManager.socket.emit("send_message", dictEmpty)
    }
    
    //MARK:- Action
    
    //MARK:- Send Text mesg
    @IBAction func btnSendMessage(_ sender: Any) {
        self.sendTextMsg() // Send text msg
    }
    
    //MARK:- Media Picker
    @IBAction func btnMediaPicker(_ sender: Any) {
        self.showSimpleActionSheet(controller: self)//Show Options
    }
    //MARK:- Cross Button To hide full screen image
    @IBAction func btnHideFullScreen(_ sender: Any) {
        //   self.navigationController?.isNavigationBarHidden = true
        self.hideShowFullScreenImage(view:self.viewContentFullScreenImage,isHidden:true)
    }
    @IBAction func btnShareDoc(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [self.strDocUrl], applicationActivities: [])
        present(vc, animated: true)
        
    }
    @IBAction func btnShareImage(_ sender: Any) {
        // image to share
        let imageToShare = [ self.imgViewFullScreenImage! ]
        let vc = UIActivityViewController(activityItems: imageToShare, applicationActivities: [])
        present(vc, animated: true)
    }
    
    //MARK:- Close Documents from Full Screen
    @IBAction func btnCloseFullScreen(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.hideShowFullScreenImage(view:self.viewContentDocumentFullScreen,isHidden:true)
    }
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if self.window?.safeAreaLayoutGuide != nil {
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: (self.window?.safeAreaLayoutGuide.bottomAnchor)!,multiplier: 1.0).isActive = true
            }
        }
    }
}
