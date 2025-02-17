//
//  ShareSetView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 17/02/2025.
//

import SwiftUI
import PDFKit

struct ShareSetView: View {
    @ObservedObject var homeVM: HomeViewModel
    @State private var selectedSets: Set<String> = []
    @State private var showingShareSheet = false
    @State private var pdfURL: URL?
    @Environment(\.dismiss) private var dismiss
    // Filter tags
    @State private var selectedTags: [String] = []
    @State private var showTags: Bool = false
    // Alerts
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showTags.toggle()
                }) {
                    HStack {
                        Text(showTags ? "Hide class" : "Show class")
                        Image(systemName: showTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }
            
            if showTags {
                HStack(spacing: 15) {
                    ForEach(["Attacker", "Runner", "Defender"], id: \.self) { tag in
                        TagButton(label: tag, isSelected: selectedTags.contains(tag)) {
                            if selectedTags.contains(tag) {
                                selectedTags.removeAll { $0 == tag }
                            } else {
                                selectedTags.append(tag)
                            }
                        }
                    }
                }
                .padding()
            }
            
            ScrollView {
                Text("Select sets to share")
                    .font(.title)
                    .bold()
                    .padding()
                
                LazyVStack(spacing: 20) {
                    medalSetList()
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
            
            if !selectedSets.isEmpty {
                Button(action: saveAsPDF) {
                    Text("Save as PDF")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .onChange(of: pdfURL) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                showingShareSheet = (pdfURL != nil)
            }
        }
        .sheet(isPresented: $showingShareSheet, onDismiss: {
            dismiss()
        }, content: {
            if let pdfURL = pdfURL {
                ShareSheet(activityItems: [pdfURL])
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func medalSetList() -> some View {
        ForEach(filteredMedalSets, id: \.imageURLs) { set in
            HStack {
                Button(action: {
                    toggleSelection(for: set)
                }) {
                    Image(systemName: selectedSets.contains(setID(for: set)) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedSets.contains(setID(for: set)) ? .blue : .gray)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                
                MedalSetCardView(medalSet: set)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
    
    private var filteredMedalSets: [MedalSet] {
        var sets = homeVM.medalSets
        
        if !selectedTags.isEmpty {
            sets = sets.filter { set in
                selectedTags.allSatisfy { tag in
                    set.bestFor.contains(tag)
                }
            }
        }
        
        return sets
    }
    
    private func setID(for set: MedalSet) -> String {
        set.imageURLs.first?.absoluteString ?? UUID().uuidString
    }
    
    private func toggleSelection(for set: MedalSet) {
        let id = setID(for: set)
        if selectedSets.contains(id) {
            selectedSets.remove(id)
        } else {
            selectedSets.insert(id)
        }
    }
    
    private func saveAsPDF() {
        let selectedMedalSets = homeVM.medalSets.filter { selectedSets.contains(setID(for: $0)) }
        
        let pdfFileName = "MedalSets.pdf"
        let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(pdfFileName)
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try pdfRenderer.writePDF(to: pdfURL) { context in
                context.beginPage()
                
                let pageWidth: CGFloat = 612
                let leftPadding: CGFloat = 20
                var yOffset: CGFloat = 20
                let imageSize: CGFloat = 50
                let imageSpacing: CGFloat = 10
                let textWidth = pageWidth - 2 * leftPadding
                
                let titleFont = UIFont.boldSystemFont(ofSize: 16)
                let bodyFont = UIFont.systemFont(ofSize: 12)
                
                let title = "OPBR Companion Medal Sets"
                title.draw(at: CGPoint(x: leftPadding, y: yOffset), withAttributes: [.font: titleFont])
                yOffset += 30
                
                var setCount = 0
                
                for set in selectedMedalSets {
                    if setCount >= 2 {
                        context.beginPage()
                        yOffset = 20
                        setCount = 0
                    }
                    
                    let setTitle = "Medal Set:"
                    setTitle.draw(at: CGPoint(x: leftPadding, y: yOffset), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
                    yOffset += 20
                    
                    let totalWidth = CGFloat(set.imageURLs.count) * imageSize + CGFloat(set.imageURLs.count - 1) * imageSpacing
                    let startX = (pageWidth - totalWidth) / 2
                    let imageY = yOffset
                    
                    for (index, url) in set.imageURLs.enumerated() {
                        if let image = loadImage(from: url) {
                            let imageRect = CGRect(x: startX + CGFloat(index) * (imageSize + imageSpacing), y: imageY, width: imageSize, height: imageSize)
                            image.draw(in: imageRect)
                        }
                    }
                    
                    yOffset += imageSize + 10
                    
                    let traitsText = "Traits:"
                    traitsText.draw(at: CGPoint(x: leftPadding, y: yOffset), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)]) // Smaller traits font
                    yOffset += 15
                    
                    for trait in set.medalTraits {
                        drawWrappedText(trait, at: &yOffset, leftPadding: leftPadding, textWidth: textWidth, font: bodyFont)
                    }
                    
                    yOffset += 10
                    
                    let tagsText = "Tags:"
                    tagsText.draw(at: CGPoint(x: leftPadding, y: yOffset), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
                    yOffset += 15
                    
                    for tag in set.tags {
                        drawWrappedText(tag, at: &yOffset, leftPadding: leftPadding, textWidth: textWidth, font: bodyFont)
                    }
                    
                    yOffset += 30
                    setCount += 1
                }
            }
            
            self.pdfURL = pdfURL
        } catch {
            alertMessage = "Failed to generate PDF: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    private func loadImage(from url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    private func drawWrappedText(_ text: String, at yOffset: inout CGFloat, leftPadding: CGFloat, textWidth: CGFloat, font: UIFont) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let textRect = CGRect(x: leftPadding, y: yOffset, width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        let textBoundingRect = attributedText.boundingRect(with: textRect.size, options: .usesLineFragmentOrigin, context: nil)
        
        attributedText.draw(in: CGRect(x: leftPadding, y: yOffset, width: textWidth, height: textBoundingRect.height))
        yOffset += textBoundingRect.height + 5
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ShareSetView(homeVM: HomeViewModel())
}
