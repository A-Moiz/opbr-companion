//
//  SupportDetailView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/01/2026.
//

import SwiftUI
import Kingfisher

struct SupportDetailView: View {
    let support: Support
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                KFImage(URL(string: support.support ?? ""))
                    .resizable()
                    .placeholder { ProgressView().controlSize(.large) }
                    .scaledToFit()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .containerRelativeFrame(.horizontal)
                    .shadow(color: .black.opacity(0.1), radius: 15)

                VStack(alignment: .leading, spacing: 28) {
                    HStack(spacing: 16) {
                        attributeCell(
                            title: "Main Color",
                            value: support.supportColor ?? "Universal",
                            icon: "paintpalette.fill",
                            tint: color(for: support.supportColor ?? "")
                        )
                        
                        attributeCell(
                            title: "Total Tags",
                            value: "\(support.supportTags?.count ?? 0) Maxed",
                            icon: "tag.fill",
                            tint: .orange
                        )
                    }

                    if let tags = support.supportTags, !tags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Associated Tags", systemImage: "checklist")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 10) {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption.bold())
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 4)
                                        .frame(maxWidth: .infinity)
                                        .background(.thinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .strokeBorder(.quaternary, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    
                    if let color = support.supportColor {
                        Text("Best paired with **\(color)** characters to maximize efficiency.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Support Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
    }

    // MARK: - Info Cell Component
    @ViewBuilder
    private func attributeCell(title: String, value: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
                .foregroundStyle(tint == .white ? .primary : tint)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func color(for name: String) -> Color {
        switch name {
        case "Red": return .red
        case "Green": return .green
        case "Blue": return .blue
        case "Light": return .white
        case "Dark": return .black
        default: return .orange
        }
    }
}

#Preview {
    @Previewable @State var support = Support(id: 0, support: "", supportColor: "", supportTags: [""])
    SupportDetailView(support: support)
}
