//
//  CharacterCardView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

//import SwiftUI
//
//struct CharacterCardView: View {
//    var character: Character
//    @State private var uiImage: UIImage? = nil
//
//    var body: some View {
//        VStack(spacing: 8) {
//            if let image = uiImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 110, height: 110)
//                    .cornerRadius(6)
//                    .shadow(radius: 1)
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 110, height: 110)
//                    .cornerRadius(6)
//                    .onAppear {
//                        loadImage()
//                    }
//            }
//            
//            Text(character.title)
//                .font(.caption2)
//                .foregroundColor(.gray)
//                .lineLimit(1)
//                .truncationMode(.tail)
//            
//            Text(character.name)
//                .font(.caption2)
//                .bold()
//                .foregroundColor(.blue)
//                .lineLimit(1)
//                .truncationMode(.tail)
//            
//            Text("Tags: \(character.tags.joined(separator: ", "))")
//                .font(.caption2)
//                .foregroundColor(.gray)
//                .lineLimit(1)
//                .truncationMode(.tail)
//            
//            Text("Color: \(character.colour)")
//                .font(.caption2)
//                .foregroundColor(.blue)
//            
//            Text("Class: \(character.characterClass)")
//                .font(.caption2)
//                .foregroundColor(.blue)
//        }
//        .frame(width: 115, height: 250)
//        .padding(2)
//        .background(Color.white)
//        .cornerRadius(6)
//        .shadow(radius: 1)
//        .onAppear {
//            loadImage()
//        }
//    }
//    
//    private func loadImage() {
//        if let image = UIImage(contentsOfFile: character.imageURL.path) {
//            self.uiImage = image
//        } else {
//            print("Image not found at path: \(character.imageURL.path)")
//        }
//    }
//}

//import SwiftUI
//
//struct CharacterCardView: View {
//    var character: Character
//    @State private var uiImage: UIImage? = nil
//    // Colour scheme
//    @Environment(\.colorScheme) private var colourScheme
//
//    var body: some View {
//        VStack(spacing: 8) {
//            if let image = uiImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 110, height: 110)
//                    .cornerRadius(6)
//                    .shadow(radius: 1)
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 110, height: 110)
//                    .cornerRadius(6)
//                    .onAppear {
//                        loadImage()
//                    }
//            }
//            
//            Text(character.name)
//                .font(.caption2)
//                .bold()
//                .foregroundColor(.blue)
//                .lineLimit(1)
//                .truncationMode(.tail)
//        }
//        .frame(width: 110, height: 130)
//        .padding(2)
//        .background(colourScheme == .light ? .white : .black)
//        .cornerRadius(6)
//        .shadow(radius: 1)
//        .onAppear {
//            loadImage()
//        }
//    }
//    
//    private func loadImage() {
//        if let image = UIImage(contentsOfFile: character.imageURL.path) {
//            self.uiImage = image
//        } else {
//            print("Image not found at path: \(character.imageURL.path)")
//        }
//    }
//}

//import SwiftUI
//
//struct CharacterCardView: View {
//    var character: Character
//    @State private var uiImage: UIImage? = nil
//    @Environment(\.colorScheme) private var colourScheme
//    @ObservedObject var homeVM: HomeViewModel
//
//    var body: some View {
//        VStack(spacing: 8) {
//            if let image = uiImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 110, height: 110)
//                    .cornerRadius(6)
//                    .shadow(radius: 1)
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 110, height: 110)
//                    .cornerRadius(6)
//                    .onAppear {
//                        loadImage()
//                    }
//            }
//            
//            HStack(spacing: 4) {
//                Text(character.name)
//                    .font(.caption2)
//                    .bold()
//                    .foregroundColor(.blue)
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//                
//                if homeVM.isCharacterOwned(character) {
//                    Image(systemName: "checkmark.circle.fill")
//                        .foregroundColor(.green)
//                        .font(.caption2)
//                }
//                
//                if homeVM.isCharacterWanted(character) {
//                    Image(systemName: "star.circle.fill")
//                        .foregroundColor(.yellow)
//                        .font(.caption2)
//                }
//            }
//        }
//        .frame(width: 110, height: 130)
//        .padding(2)
//        .background(colourScheme == .light ? .white : .black)
//        .cornerRadius(6)
//        .shadow(radius: 1)
//        .onAppear {
//            loadImage()
//        }
//    }
//    
//    private func loadImage() {
//        if let image = UIImage(contentsOfFile: character.imageURL.path) {
//            self.uiImage = image
//        } else {
//            print("Image not found at path: \(character.imageURL.path)")
//        }
//    }
//}

import SwiftUI

struct CharacterCardView: View {
    var character: Character
    @State private var uiImage: UIImage? = nil
    @Environment(\.colorScheme) private var colourScheme
    @ObservedObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 8) {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .cornerRadius(6)
                    .shadow(radius: 1)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 110, height: 110)
                    .cornerRadius(6)
                    .onAppear {
                        loadImage()
                    }
            }
            
            HStack(spacing: 4) {
                Text(character.name)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                if homeViewModel.isCharacterOwned(character) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                }
                
                if homeViewModel.isCharacterWanted(character) {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                }
            }
        }
        .frame(width: 110, height: 130)
        .padding(2)
        .background(colourScheme == .light ? .white : Color(.systemGray5))
        .cornerRadius(6)
        .shadow(radius: 1)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if let image = UIImage(contentsOfFile: character.imageURL.path) {
            self.uiImage = image
        } else {
            print("Image not found at path: \(character.imageURL.path)")
        }
    }
}

//#Preview {
//    CharacterCardView()
//}
