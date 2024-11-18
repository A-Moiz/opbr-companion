//
//  TitleTrackerView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/11/2024.
//

import SwiftUI
import Lottie

struct TitleTrackerView: View {
    @Environment(\.colorScheme) private var colourScheme
    @ObservedObject var homeVM: HomeViewModel
    @State private var showIncompleteList = true
    @State private var showCompleteList = false
    @State private var newCharacterName = ""
    @State private var showCompletionAnimation = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            TextField("Add character", text: $newCharacterName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") {
                                guard !newCharacterName.isEmpty else { return }
                                homeVM.addCharacter(name: newCharacterName)
                                newCharacterName = ""
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        
                        SectionView(
                            title: "Incomplete Titles",
                            isExpanded: $showIncompleteList,
                            content: {
                                ForEach(homeVM.incompleteTitles) { character in
                                    HStack {
                                        Text(character.name)
                                            .bold()
                                        Spacer()
                                        Text("Wins: \(character.wins) / 100")
                                            .foregroundColor(.blue)
                                        Text("Left: \(character.winsLeft)")
                                            .foregroundColor(.red)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                                    )
                                    .onTapGesture {
                                        homeVM.updateWins(for: character, newWins: character.wins + 1)
                                        if character.wins + 1 >= 100 {
                                            showCompletionAnimation = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showCompletionAnimation = false
                                            }
                                        }
                                    }
                                }
                            }
                        )
                        
                        SectionView(
                            title: "Complete Titles",
                            isExpanded: $showCompleteList,
                            content: {
                                ForEach(homeVM.completeTitles) { character in
                                    Text(character.name)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                                        )
                                }
                            }
                        )
                    }
                    .padding()
                }
                .navigationTitle("Track your titles")
                .navigationBarTitleDisplayMode(.inline)
                if showCompletionAnimation {
                    TitleCompletionView(showAnimation: $showCompletionAnimation)
                        .transition(.opacity)
                }
            }
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            
            if isExpanded {
                VStack(spacing: 10) {
                    content()
                }
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    TitleTrackerView(homeVM: HomeViewModel())
}
