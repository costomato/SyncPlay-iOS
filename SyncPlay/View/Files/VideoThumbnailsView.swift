//
//  VideosView.swift
//  SyncPlay
//
//  Created by Kaustubh on 16/07/23.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct VideoThumbnailsView: View {
    private let thumbnails: [UIImage] = fetchVideoThumbnails()

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(thumbnails, id: \.self) { thumbnail in
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}



func fetchVideoThumbnails() -> [UIImage] {
    var thumbnails: [UIImage] = []
    
    PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            fetchResult.enumerateObjects { asset, _, _ in
                imageManager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFill, options: requestOptions) { image, _ in
                    if let thumbnail = image {
                        thumbnails.append(thumbnail)
                    }
                }
            }
        }
    }
    
    return thumbnails
}
