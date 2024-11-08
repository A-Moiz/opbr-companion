//
//  SupportView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 07/11/2024.
//

import SwiftUI

struct SupportCardView: View {
    var supportImage: SupportImage
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let uiImage = UIImage(contentsOfFile: supportImage.imageURL.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: imageHeight())
                    // .frame(height: 250)
                    .cornerRadius(15)
                    .shadow(radius: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .cornerRadius(15)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundStyle(Color.orange)
                    Text("Tags: \(supportImage.tags.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(color(for: supportImage.colour))
                    Text("Color: \(supportImage.colour)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            .padding(10)
            .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
            .cornerRadius(10)
            .shadow(radius: 3)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
                .shadow(radius: 5)
        )
    }
    
    private func imageHeight() -> CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 750 : 250
    }
    
    func color(for colourName: String) -> Color {
        switch colourName {
        case "Red":
            return Color.red
        case "Green":
            return Color.green
        case "Blue":
            return Color.blue
        case "Light":
            return Color.white
        case "Dark":
            return Color.black
        default:
            return Color.gray
        }
    }
}

//#Preview {
//    SupportView()
//}
