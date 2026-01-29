//
//  MedalSetsList.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 19/01/2026.
//

import SwiftUI
import Kingfisher

struct MedalSetsList: View {
    @Environment(Database.self) var db
    @State private var showFilter: Bool = false
    @State private var selectedClass: String? = nil
    private var filteredSets: [MedalSet] {
        db.medalSets.filter { medalSet in
            let matchesClass = selectedClass == nil || medalSet.bestFor == selectedClass
            return matchesClass
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredSets.isEmpty && db.medalSets.isEmpty {
                    ContentUnavailableView("No Medal Sets Found",
                                           systemImage: "circle.grid.3x3.fill",
                                           description: Text("Try checking your connection or refresh the app."))
                } else {
                    MedalSetsGridView(showFilter: $showFilter, selectedClass: $selectedClass, filteredSets: filteredSets)
                }
            }
            .navigationTitle("Medal Sets")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Medal sets view
struct MedalSetsGridView: View {
    @Binding var showFilter: Bool
    @Binding var selectedClass: String?
    @State var dummyItem: [String]?
    let characterClasses = ["Attacker", "Defender", "Runner"]
    let filteredSets: [MedalSet]
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]
    @Environment(Database.self) var db
    
    var body: some View {
        ScrollView {
            VStack {
                FilterToggleView(showFilter: $showFilter, hideText: "Hide Filter", showText: "Show Filter")
                
                if showFilter {
                    FilterView(array: characterClasses, selectedItem: $selectedClass, isMultiple: false, selectedItems: $dummyItem)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                LazyVStack {
                    ForEach(filteredSets) { set in
                        if db.appSettings?.showArtworks ?? false {
                            MedalSetCard(medalSet: set)
                        } else {
                            AltMedalSetCard(medalSet: set)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .scrollClipDisabled()
    }
}

// MARK: - Medal Set card view
struct MedalSetCard: View {
    var medalSet: MedalSet
    @State private var showDetailView: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let name = medalSet.name, !name.isEmpty {
                HStack {
                    Text(name)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "medal.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.orange)
                }
            }
            
            VStack(spacing: 14) {
                let medals = medalSet.medals ?? []
                let traits = medalSet.medalTraits ?? []
                
                ForEach(0..<medals.count, id: \.self) { index in
                    HStack(alignment: .center, spacing: 14) {
                        KFImage(URL(string: medals[index]))
                            .resizable()
                            .placeholder {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.quaternary)
                                    .frame(width: 52, height: 52)
                            }
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)

                        if index < traits.count {
                            Text(traits[index])
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                    }
                }
            }
            
            Button {
                showDetailView = true
            } label: {
                Label("View Set Details", systemImage: "chevron.right.circle.fill")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.orange.opacity(0.1))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 12, y: 6)
        }
        .sheet(isPresented: $showDetailView) {
            MedalSetDetailView(medalSet: medalSet)
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(44)
                .presentationBackground(.thinMaterial)
        }
    }
}

// MARK: - Alt Medal set card
struct AltMedalSetCard: View {
    var medalSet: MedalSet
    @State private var showDetailView: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Header
            if let name = medalSet.name, !name.isEmpty {
                HStack {
                    Text(name)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "medal.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.orange)
                }
            }
            
            // Medals + Traits
            VStack(spacing: 14) {
                let medals = medalSet.medals ?? []
                let traits = medalSet.medalTraits ?? []
                
                ForEach(0..<medals.count, id: \.self) { index in
                    HStack(alignment: .center, spacing: 14) {
                        
                        // SF Symbol Medal Circle
                        ZStack {
                            Circle()
                                .fill(.orange.opacity(0.15))
                                .frame(width: 52, height: 52)
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.orange)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)

                        if index < traits.count {
                            Text(traits[index])
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                    }
                }
            }
            
            // CTA
            Button {
                showDetailView = true
            } label: {
                Label("View Set Details", systemImage: "chevron.right.circle.fill")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.orange.opacity(0.1))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.regularMaterial)
                .shadow(
                    color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08),
                    radius: 12,
                    y: 6
                )
        }
        .sheet(isPresented: $showDetailView) {
            MedalSetDetailView(medalSet: medalSet)
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(44)
                .presentationBackground(.thinMaterial)
        }
    }
}

#Preview {
    MedalSetsList()
        .environment(Database())
}
