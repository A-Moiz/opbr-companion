//
//  FilterView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/01/2026.
//

import SwiftUI

struct FilterView: View {
    //let characterClasses = ["Attacker", "Defender", "Runner"]
    //@Binding var selectedClass: String?
    @State var array: [String]
    @Binding var selectedItem: String?
    @State var isMultiple: Bool
    @Binding var selectedItems: [String]?
    
    var body: some View {
//        HStack {
//            ForEach(array, id: \.self) { selected in
//                Button {
//                    if !isMultiple {
//                        selectedItem = (selectedItem == selected) ? nil : selected
//                    } else if selectedItems.contains(selected) {
//                        selectedItems.removeAll { $0 == selected }
//                    } else {
//                        selectedItems?.append(selected)
//                    }
//                } label: {
//                    Text(selected)
//                        .font(.subheadline)
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 16)
//                        .background(selectedItem == selected ? Color.orange : Color(.systemGray6))
//                        .foregroundColor(selectedItem == selected ? .white : .primary)
//                        .clipShape(Capsule())
//                        .padding(.bottom)
//                }
//            }
//        }
        HStack {
            ForEach(array, id: \.self) { item in
                let isSelected = isMultiple ? (selectedItems?.contains(item) ?? false) : (selectedItem == item)
                Button {
                    handleToggle(for: item)
                } label: {
                    Text(item)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(isSelected ? Color.orange : Color(.systemGray6))
                        .foregroundColor(isSelected ? .white : .primary)
                        .clipShape(Capsule())
                }
            }
        }

    }
    
//    var body: some View {
//        HStack {
//            ForEach(characterClasses, id: \.self) { className in
//                Button {
//                    selectedClass = (selectedClass == className) ? nil : className
//                } label: {
//                    Text(className)
//                        .font(.subheadline)
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 16)
//                        .background(selectedClass == className ? Color.orange : Color(.systemGray6))
//                        .foregroundColor(selectedClass == className ? .white : .primary)
//                        .clipShape(Capsule())
//                        .padding(.bottom)
//                }
//            }
//        }
//    }
    
    private func handleToggle(for item: String) {
        if isMultiple {
            if selectedItems == nil { selectedItems = [] }
            
            if let index = selectedItems?.firstIndex(of: item) {
                selectedItems?.remove(at: index)
            } else {
                selectedItems?.append(item)
            }
        } else {
            selectedItem = (selectedItem == item) ? nil : item
        }
    }
}

#Preview {
    @Previewable @State var selectedItem: String?
    @Previewable @State var selectedItems: [String]?
    FilterView(array: [""], selectedItem: $selectedItem, isMultiple: true, selectedItems: $selectedItems)
}
