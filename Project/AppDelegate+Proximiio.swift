//
//  AppDelegate+Proximiio.swift
// Full
//
//  Created by dev on 12/12/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import ProximiioMapbox
import Proximiio
import Kingfisher

extension AppDelegate {
    func setupProximiio() {
        // force check permission
        Proximiio.sharedInstance()?.requestPermissions(true)
        
        // force use specific api version
        (ProximiioAPI.sharedManager())?.setApiVersion("v5")
        (ProximiioAPI.sharedManager())?.setApi("https://api.proximi.fi")
        
        // show the main application
        Proximiio.sharedInstance()?.auth(withToken: appToken, callback: { state in
            
            // if boot up of proximiio went fine
            if state == kProximiioReady {
                
                Proximiio.sharedInstance()?.sync({ success in
                    if success {
                        // force sync campus
                        // if all fine start extra stuffs
                        self.startProximiio()
                        
                        // show app
                        self.showApp()
                        
                        // preload images
                        self.preloadFeatureImages { _ in }

                    }
                })
                
            } else {
                self.startProximiio()
                
                // show app
                self.showApp()
            }
            
        })
    }
    
    private func startProximiio() {
//        // add pdr processor
//        pdrProcessor.useDeviceHeading = false
//        pdrProcessor.hiThreshold = 1.0
//        pdrProcessor.lowThreshold = 0.98
//        ProximiioLocationManager.shared()?.addProcessor(pdrProcessor, avoidDuplicates: true)
//
//        // add snap processors
//        snapProcessor.threshold = 8.0
//        ProximiioLocationManager.shared()?.addProcessor(snapProcessor, avoidDuplicates: false)

        // simulation processor
        ProximiioLocationManager.shared()?.addProcessor(simulationProcessor, avoidDuplicates: true)
        
        // startup proximiio
        Proximiio.sharedInstance()?.enable()
        Proximiio.sharedInstance()?.startUpdating()
        Proximiio.sharedInstance()?.delegate = self
        
        // force mini buffer
        Proximiio.sharedInstance()?.setBufferSize(kProximiioBufferMini)
    }
    
    private func preloadFeatureImages(callback: @escaping ((Bool) -> Void)) {
        var completed = 0
        PIODatabase.sharedInstance().features().forEach { feature in
            feature.images.forEach {
                if let imgUrl = URL(string: $0) {
                    completed += 1
                    ImageDownloader
                        .default
                        .downloadImage(
                            with: imgUrl, options: []) { (result) in
                            completed -= 1
                            switch result {
                            case .success(let image):
                                if let url = image.url {
                                    ImageCache.default.store(image.image, forKey: url.absoluteString)
                                }
                            default: break
                            }
                            if completed == 0 {
                                callback(true)
                            }
                        }
                }
            }
        }
    }
}
