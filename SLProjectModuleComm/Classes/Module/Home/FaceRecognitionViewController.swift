//
//  FaceRecognitionViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/2/4.
//

import UIKit
import AVFoundation
import Vision
import SLIKit

class FaceRecognitionViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var switchBtn: UIButton! {
        didSet {
            switchBtn.setImage(R.image.switchCamera40(), for: .normal)
        }
    }

    /// 负责输入和输出设备之间的连接会话,数据流的管理控制
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        if let input = input {
            session.addInput(input)
        }
        session.addOutput(output)
        return session
    }()
    /// 采集设备
    private lazy var device: AVCaptureDevice? = {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        return device
    }()
    /// 输入流
    private lazy var input: AVCaptureDeviceInput? = {
        guard let device = device else { return nil }
        let input = try? AVCaptureDeviceInput(device: device)
        return input
    }()
    
    /// 视频输出
    private lazy var output: AVCaptureVideoDataOutput = {
        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "VideoDataOutputQueue")
        output.setSampleBufferDelegate(self, queue: queue)
        return output
    }()
    /// 预览层
    private lazy var preview: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.zPosition = -1
        layer.frame = UIScreen.main.bounds
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    /// 标识人脸的layer数组
    private var faceSubLayers: [CALayer] = []
    private var faceFeaturesSubLayers: [CALayer] = []
    /// 摄像头位置
    private var position: AVCaptureDevice.Position = .front

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(preview)
        session.startRunning()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        session.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
    /// 切换摄像头
    @IBAction func switchCameraAction(_ sender: UIButton) {
        position = position == .front ? .back : .front
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
           let newInput = try? AVCaptureDeviceInput(device: newDevice),
           let ori_input = input else {
            position = position == .front ? .back : .front
            return
        }
        device = newDevice
        session.beginConfiguration()
        session.removeInput(ori_input)
        if session.canAddInput(newInput) {
            session.addInput(newInput)
            input = newInput
        } else {
            session.addInput(ori_input)
        }
        session.commitConfiguration()
    }
}

extension FaceRecognitionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    /// 视频流输出
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        connection.videoOrientation = .portrait
//        connection.isVideoMirrored = true
        var handler: VNImageRequestHandler?
        if #available(iOS 14.0, *) {
            handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .right, options: [:])
        } else {
            if let cvpixeBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer) {
                handler = VNImageRequestHandler(cvPixelBuffer: cvpixeBufferRef, orientation: .right, options: [:])
            }
        }
        guard let myHandler = handler else { return }
        let faceRequest = faceReqReq()
        let faceFeaturesRequest = faceFeaturesReqReq()
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try myHandler.perform([faceRequest, faceFeaturesRequest])
            } catch {
                print("e")
            }
        }
    }
}

extension FaceRecognitionViewController {
    /// 人脸识别相关
    private func faceReqReq() -> VNDetectFaceRectanglesRequest {
        let request = VNDetectFaceRectanglesRequest { [weak self] (request, _) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if let result = request.results as? [VNFaceObservation] {
                    self.faceSubLayers.forEach { $0.removeFromSuperlayer() }
                    for item in result {
                        let rectLayer = CALayer()
                        var transFrame = self.convertRect(boundingBox: item.boundingBox, size: self.preview.frame.size)
                        if self.position == .front {
                            transFrame.origin.x = self.preview.frame.size.width - transFrame.origin.x - transFrame.size.width
                        }
                        rectLayer.frame = transFrame
                        rectLayer.borderColor = UIColor.red.cgColor
                        rectLayer.borderWidth = 2
                        self.preview.addSublayer(rectLayer)
                        self.faceSubLayers.append(rectLayer)
                    }
                }
            }
        }
        return request
    }
    
    /// 面部特征识别
    private func faceFeaturesReqReq() -> VNDetectFaceLandmarksRequest {
        let request = VNDetectFaceLandmarksRequest { [weak self] (request, _) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                guard let result = request.results as? [VNFaceObservation] else { return }
                self.faceFeaturesSubLayers.forEach { $0.removeFromSuperlayer() }
                for item in result {
                    item.landmarks?.allPoints?.normalizedPoints.forEach { (point) in
                        let rectLayer = CALayer()
                        var transPoint = self.convertRect(boundingBox: item.boundingBox, point: point, size: self.preview.frame.size)
                        if self.position == .front {
                            transPoint.x = self.preview.frame.size.width - transPoint.x
                        }
                        rectLayer.frame = CGRect(origin: transPoint, size: CGSize(width: 5, height: 5))
                        rectLayer.backgroundColor = UIColor.red.cgColor
                        self.preview.addSublayer(rectLayer)
                        self.faceFeaturesSubLayers.append(rectLayer)
                    }
                }
            }
        }
        return request
    }
    
    /// 识别出的人脸坐标与UI坐标不一样, 需要进行转换
    private func convertRect(boundingBox: CGRect, size: CGSize) -> CGRect {
        let o_w = boundingBox.size.width * size.width
        let o_h = boundingBox.size.height * size.height
        let o_x = boundingBox.origin.x * size.width
        let o_y = size.height * (1 - boundingBox.origin.y - boundingBox.size.height)
        return CGRect(x: o_x, y: o_y, width: o_w, height: o_h)
    }
    
    /// 识别出的人脸坐标与UI坐标不一样, 需要进行转换
    private func convertRect(boundingBox: CGRect, point: CGPoint, size: CGSize) -> CGPoint {
        let transFrame = convertRect(boundingBox: boundingBox, size: size)
        let o_x = point.x * transFrame.width + transFrame.minX
        let o_y = transFrame.height * (1 - point.y) + transFrame.minY
        return CGPoint(x: o_x, y: o_y)
    }
}
