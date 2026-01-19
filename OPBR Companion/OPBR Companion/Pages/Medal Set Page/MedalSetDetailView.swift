//
//  MedalSetDetailView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 19/01/2026.
//

import SwiftUI
import Kingfisher

struct MedalSetDetailView: View {
    var medalSet: MedalSet
    private let imageSize: CGFloat = 56.0
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    detailSection(title: "Medal Components", systemImage: "square.grid.3x1.below.line.grid.1x2") {
                        VStack(spacing: 0) {
                            let medals = medalSet.medals ?? []
                            let traits = medalSet.medalTraits ?? []
                            
                            ForEach(0..<medals.count, id: \.self) { index in
                                HStack(alignment: .center, spacing: 16) {
                                    KFImage(URL(string: medals[index]))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: imageSize, height: imageSize)
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    
                                    if index < traits.count {
                                        Text(traits[index])
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    
                                    Spacer(minLength: 0)
                                }
                                .padding(.vertical, 12)
                                
                                if index < medals.count - 1 {
                                    Divider()
                                        .padding(.leading, imageSize + 16)
                                }
                            }
                        }
                    }
                    
                    infoBadge(title: "Best For", value: medalSet.bestFor, icon: "person.fill.checkmark", tint: .orange)

                    detailSection(title: "Set Description", systemImage: "text.alignleft") {
                        Text(medalSet.description ?? "No description available.")
                            .padding(.vertical)
                            .font(.callout)
                            .foregroundStyle(.primary)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let tags = medalSet.tags, !tags.isEmpty {
                        detailSection(title: "Active Set Tags", systemImage: "tag.fill") {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                                    HStack {
                                        Text(tag)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    
                                    if index < tags.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(medalSet.name ?? "Set Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func detailSection<Content: View>(title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            VStack(alignment: .leading) {
                content()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorScheme == .dark ? Color(.secondarySystemGroupedBackground) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.03), radius: 8, y: 4)
        }
    }

    @ViewBuilder
    private func infoBadge(title: String, value: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption2.bold())
                .foregroundStyle(tint)
            Text(value)
                .font(.subheadline.bold())
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? Color(.secondarySystemGroupedBackground) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    @Previewable @State var set = MedalSet(id: 0, name: "", medals: [""], medalTraits: [""], bestFor: "", description: "", tags: [""])
    MedalSetDetailView(medalSet: set)
}
