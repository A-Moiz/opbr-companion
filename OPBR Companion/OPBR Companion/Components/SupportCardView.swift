//
//  SupportView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 07/11/2024.
//

import SwiftUI
import Kingfisher

struct SupportCardView: View {
    var support: Support
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KFImage(URL(string: support.support ?? ""))
                .resizable()
                .scaledToFill()
                .frame(height: imageHeight())
                .cornerRadius(15)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 6) {
                if let tags = support.supportTags, !tags.isEmpty {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundStyle(Color.orange)
                        Text("Tags: \(tags.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                
                if let supportColor = support.supportColor, !supportColor.isEmpty {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(color(for: supportColor))
                        Text("Color: \(supportColor)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(10)
            .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
            .cornerRadius(10)
            .shadow(radius: 3)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
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
