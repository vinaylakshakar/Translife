//
//  ChatMessageCell.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/6/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    
    var chatViewController: ChatViewController?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = .white
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @objc func handlePlay() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) { 
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            if player?.isPlaying == false{
                player?.play()
                activityIndicatorView.startAnimating()
                playButton.isHidden = true
                print("Attempting to play video")
            }else{
                player?.pause()
                activityIndicatorView.stopAnimating()
                playButton.isHidden = false

            }
           
        }
    }
 
    @objc func playerDidFinishPlaying(note: NSNotification) {
        player?.pause()
        activityIndicatorView.stopAnimating()
        playButton.isHidden = false
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
        playButton.isHidden = false
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = UIColor.gray
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor.blue
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
        imageView.addGestureRecognizer(tap)
       
        return imageView
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM"
        label.layer.cornerRadius = 7
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    let dateLabel: UILabel = {
        let title = UILabel()
        title.text = ""
        title.textAlignment = .center
        title.layer.cornerRadius = 15
        title.clipsToBounds = true
        title.textColor = .gray
        title.backgroundColor = .white
        title.font = UIFont(name: "Montserrat", size: 17)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            self.chatViewController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
     
        
       
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(timeLabel)
        bubbleView.addSubview(messageImageView)
        addSubview(dateLabel)
       
        
        
            // DATE LABEL FOR HEADER
        dateLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo:centerXAnchor, constant: 0).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Constraint anchors: x, y, width, height
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        addSubview(playButton)
        
        // Constraint anchors: x, y, width, height
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(activityIndicatorView)
        
        // Constraint anchors: x, y, width, height
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Constraint anchors: x, y, width, height
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo:self.heightAnchor).isActive = true
        
        // Constraint anchors: x, y, width, height
        profileImageView.leftAnchor.constraint(equalTo:self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Constraint anchors: x, y, width, height
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo:self.heightAnchor).isActive = true
        // Need x, y, width, height anchors
       // timeLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
       // timeLabel.heightAnchor.constraint(equalToConstant: 1).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor , constant: -5 ).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

