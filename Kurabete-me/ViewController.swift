//
//  ViewController.swift
//  Kurabete-me
//
//  Created by 坂井三四郎 on 2015/02/10.
//  Copyright (c) 2015年 Sanshiro Sakai. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var myimage: UIImageView!
    
    
    var imagePath: String {
        let doc = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return doc.stringByAppendingPathComponent("img1.jpg")
    }
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // フロントカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Front){
                myDevice = device as AVCaptureDevice
            }
        }
        
        // フロントカメラからVideoInputを取得.
        let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as AVCaptureDeviceInput
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as AVCaptureVideoPreviewLayer
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
        /*// UIボタンを作成.
        let cameraBtn = UIButton(frame: CGRectMake(0,0,120,50))
        cameraBtn.backgroundColor = UIColor.redColor();
        cameraBtn.layer.masksToBounds = true
        cameraBtn.setTitle("撮影", forState: .Normal)
        cameraBtn.layer.cornerRadius = 20.0
        cameraBtn.layer.position = CGPoint(x: self.view.bounds.width/3, y:self.view.bounds.height-50)
        cameraBtn.addTarget(self, action: "onClickcameraBtn:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(cameraBtn);
        
        let compareBtn = UIButton(frame: CGRectMake(0,0,120,50))
        compareBtn.backgroundColor = UIColor.redColor();
        compareBtn.layer.masksToBounds = true
        compareBtn.setTitle("比較", forState: .Normal)
        compareBtn.layer.cornerRadius = 20.0
        compareBtn.layer.position = CGPoint(x: self.view.bounds.width/3, y:self.view.bounds.height-50)
        compareBtn.addTarget(self, action: "onClickcompareBtn:", forControlEvents: .TouchDown)
        
        // UIボタンをViewに追加.
        self.view.addSubview(compareBtn);
        
        let sizeBtn = UIButton(frame: CGRectMake(0,0,120,50))
        sizeBtn.backgroundColor = UIColor.redColor();
        sizeBtn.layer.masksToBounds = true
        sizeBtn.setTitle("拡大", forState: .Normal)
        sizeBtn.layer.cornerRadius = 20.0
        sizeBtn.layer.position = CGPoint(x: self.view.bounds.width/3, y:self.view.bounds.height-50)
        sizeBtn.addTarget(self, action: "onClicksizeBtn:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(sizeBtn);*/
        
    }
    
    @IBAction func comparepush(sender: AnyObject) {
           myimage.image = UIImage(contentsOfFile: imagePath)
        myimage.hidden = false
    }
    @IBAction func comparepop(sender: AnyObject) {
        myimage.hidden = true
    
    }
 
    
    @IBAction func bbb(sender: AnyObject) {
    }
    
    @IBAction func ccc(sender: AnyObject) {
        // ビデオ出力に接続.
        let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            // JpegからUIIMageを作成.
            let myImage : UIImage = UIImage(data: myImageData)!
            
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
            
            let data = UIImageJPEGRepresentation(myImage, 0.9)
            data.writeToFile(self.imagePath, atomically: true)
            println("save: \(self.imagePath)")
        })
    }
    
    
}


