//
//  ContentView.swift
//  SyncPlay
//
//  Created by Kaustubh on 16/07/23.
//

import SwiftUI
import Photos
import AVFoundation
import CoreMedia

struct HomeView: View {
    @State private var inviteCode: String = ""
    
    @State private var videos: [VideoFile] = []
    
    
    var body: some View {
        VStack {
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .clipped()
                Spacer()
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .foregroundColor(Color("AccentColor"))
            }
            .padding(24)
            Text("Join a meeting via code")
            
            HStack {
                Image(systemName: "link")
                    .foregroundColor(.gray)
                TextField("Enter invite code", text: $inviteCode)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Button(action: {
                    //                    define button action here
                }) {
                    Text("Join")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 8)
            
            HStack {
                Text("Library")
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(videos) { video in
                        VideoThumbnailView(title: video.title, thumbnail: video.thumbnail, timestamp: video.duration)
                    }
                    
                }
                .fixedSize()
            }
            .padding(.horizontal, 24)
            .onAppear {
                        getVideoList { videos in
                            self.videos = videos
                        }
                    }
            
            Spacer()
        }
    }
}


struct VideoFile: Identifiable {
    let id = UUID()
    let thumbnail: Image
    let title: String
    let duration: String
}


func getVideoList(completion: @escaping ([VideoFile]) -> Void) {
    var videos: [VideoFile] = []
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
    
    let allVideo = PHAsset.fetchAssets(with: .video, options: fetchOptions)
    
    let group = DispatchGroup()
    
    allVideo.enumerateObjects { (asset, index, bool) in
        group.enter()
        let imageManager = PHCachingImageManager()
        imageManager.requestAVAsset(forVideo: asset, options: nil, resultHandler: { (asset, audioMix, info) in
            if let avasset = asset as? AVURLAsset {
                let urlVideo = avasset.url
                let fileName = urlVideo.lastPathComponent
                let duration = avasset.duration.durationText
                let thumbnail = generateThumbnail(path: urlVideo)
                
                videos.append(VideoFile(thumbnail: thumbnail, title: fileName, duration: duration))
            }
            group.leave()
        })
    }
    
    group.notify(queue: .main) {
        completion(videos)
    }
}



extension CMTime {
    var durationText:String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds % 3600 / 60)
        let seconds:Int = Int((totalSeconds % 3600) % 60)
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

func generateThumbnail(path: URL) -> Image {
    do {
        let asset = AVURLAsset(url: path, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = Image(uiImage: UIImage(cgImage: cgImage))
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return Image(systemName: "photo.on.rectangle.angled")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
