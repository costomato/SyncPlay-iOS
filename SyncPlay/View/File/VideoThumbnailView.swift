//
//  VideoThumbnailView.swift
//  SyncPlay
//
//  Created by Kaustubh on 16/07/23.
//

import SwiftUI

struct VideoThumbnailView: View {
    let title: String
    let thumbnail: Image
    let timestamp: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            thumbnail
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 110)
                .background(Color("AccentColor"))
                .clipShape(RoundedRectangle(cornerRadius: 11))
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(timestamp)
                        .font(.system(size: 14))
                        .padding(EdgeInsets(top: 7,leading: 14,bottom: 7,trailing: 14))
                        .foregroundColor(Color(.white))
                        .background(Color("BgVideoTitle"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.trailing, 5)
                .padding(.bottom, 5)
            }
        }
    }
}

struct VideoThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoThumbnailView(title: "Sample video", thumbnail: Image(systemName: "link"), timestamp: "00:50:35")
    }
}
