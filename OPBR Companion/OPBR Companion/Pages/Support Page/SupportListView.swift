//
//  SupportListView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/01/2026.
//

import SwiftUI
import Kingfisher

struct SupportListView: View {
    @Environment(Database.self) var db
    @State var showTags: Bool = false
    @State var showColors: Bool = false
    @State var supportTags: [String] = ["Attacker", "Defender", "Runner", "East Blue", "Navy", "The Seven Warlords of the Sea / Former Warlords of the Sea", "Straw Hat Pirates", "Whitebeard Pirates", "Revolutionary Army", "Don Quixote Family", "Paramecia", "Zoan", "Logia", "Captain", "Fish-Man", "The Grand Line", "New World", "Worst Generation", "Charlotte Family", "Kozuki Clan / Kozuki Clan Servant", "Animal Kingdom Pirates", "Navy Admiral / Former Navy Admiral", "Royalty / Former Royalty", "Roger Pirates / Ex-Roger Pirates"]
    @State var supportColors: [String] = ["Red", "Green", "Blue", "Light", "Dark"]
    @State var dummyItem: String? = ""
    @State var selectedTags: [String]?
    @State var selectedColor: String?
    @State var dummyItem2: [String]? = []
    private var filteredSupports: [Support] {
        db.supports.filter { support in
            let matchesColor = selectedColor == nil || support.supportColor == selectedColor

            let selectedTagsList = selectedTags ?? []
            
            let matchesTags = selectedTagsList.isEmpty || selectedTagsList.allSatisfy { tag in
                support.supportTags?.contains(tag) ?? false
            }
            return matchesColor && matchesTags
        }
    }
    private var hasActiveFilters: Bool {
        selectedColor != nil || !(selectedTags?.isEmpty ?? true)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredSupports.isEmpty && db.supports.isEmpty {
                    ContentUnavailableView("No Supports Found",
                                           systemImage: "shield.slash",
                                           description: Text("Try checking your connection or refresh the app."))
                } else {
                    SupportGridView(showTags: $showTags, showColors: $showColors, supportTags: $supportTags, supportColors: $supportColors, selectedTags: $selectedTags, selectedColor: $selectedColor, dummyItem: $dummyItem, dummyItem2: $dummyItem2, supports: filteredSupports)
                }
            }
            .navigationTitle("Supports")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if hasActiveFilters {
                        Button(action: clearFilters) {
                            Label("Clear All", systemImage: "arrow.counterclockwise.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.orange)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }
    
    private func clearFilters() {
        withAnimation(.spring()) {
            selectedColor = nil
            selectedTags = []
        }
    }
}

// MARK: - Grid view for Supports
struct SupportGridView: View {
    @Binding var showTags: Bool
    @Binding var showColors: Bool
    @Binding var supportTags: [String]
    @Binding var supportColors: [String]
    @Binding var selectedTags: [String]?
    @Binding var selectedColor: String?
    @Binding var dummyItem: String?
    @Binding var dummyItem2: [String]?
    var supports: [Support]
    private let columns = [
        GridItem(.adaptive(minimum: 300, maximum: 500), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                filterSection(
                    isExpanded: $showTags,
                    title: "Tags",
                    array: supportTags,
                    isMultiple: true,
                    selection: $dummyItem,
                    multiSelection: $selectedTags
                )
                
                filterSection(
                    isExpanded: $showColors,
                    title: "Colors",
                    array: supportColors,
                    isMultiple: false,
                    selection: $selectedColor,
                    multiSelection: $dummyItem2
                )
            }
            .padding(.bottom, 10)

            if supports.isEmpty {
                ContentUnavailableView("No Supports Found",
                    systemImage: "shield.slash",
                    description: Text("Try adjusting your filters to find what you're looking for."))
                    .padding(.top, 100)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(supports, id: \.id) { support in
                        NavigationLink(destination: SupportDetailView(support: support)) {
                            SupportCard(support: support)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .animation(.spring(duration: 0.3), value: showTags)
        .animation(.spring(duration: 0.3), value: showColors)
    }

    // MARK: - Extracted ViewBuilder to clean up the body
    @ViewBuilder
    private func filterSection(
        isExpanded: Binding<Bool>,
        title: String,
        array: [String],
        isMultiple: Bool,
        selection: Binding<String?>,
        multiSelection: Binding<[String]?>
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            FilterToggleView(
                showFilter: isExpanded,
                hideText: "Hide \(title)",
                showText: "Show \(title)"
            )
            
            if isExpanded.wrappedValue {
                ScrollView(.horizontal, showsIndicators: false) {
                    FilterView(
                        array: array,
                        selectedItem: selection,
                        isMultiple: isMultiple,
                        selectedItems: multiSelection
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}


// MARK: - Support Card
struct SupportCard: View {
    var support: Support
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            KFImage(URL(string: support.support ?? ""))
                .resizable()
                .placeholder {
                    Rectangle().fill(Color(.systemGray6))
                        .overlay(ProgressView())
                }
                .scaledToFill()
                .frame(height: imageHeight())
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    if let colorName = support.supportColor {
                        Circle()
                            .fill(color(for: colorName))
                            .frame(width: 12, height: 12)
                            .padding(12)
                            .shadow(color: .black.opacity(0.2), radius: 4)
                    }
                }
            
            VStack(alignment: .leading, spacing: 12) {
                if let tags = support.supportTags, !tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundStyle(.orange)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                if let supportColor = support.supportColor, !supportColor.isEmpty {
                    Label {
                        Text(supportColor)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    } icon: {
                        Image(systemName: "paintpalette.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(color(for: supportColor))
                    }
                }
            }
            .padding(12)
        }
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.1), radius: 10, y: 5)
        }
        .padding(.vertical, 8)
    }
    
    private func imageHeight() -> CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 400 : 220
    }
    
    private func color(for colourName: String) -> Color {
        switch colourName {
        case "Red":   return .red
        case "Green": return .green
        case "Blue":  return .blue
        case "Light": return .white
        case "Dark":  return .black
        default:      return .secondary
        }
    }
}

#Preview {
    SupportListView()
        .environment(Database())
}
