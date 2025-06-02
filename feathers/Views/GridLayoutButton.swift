import SwiftUI

struct GridLayoutButton: View {
    @Binding var columnCount: Int
    let maxColumns: Int
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                columnCount = columnCount == maxColumns ? 1 : columnCount + 1
            }
        } label: {
            Image(systemName: "square.grid.2x2")
                .symbolRenderingMode(.hierarchical)
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
        }
    }
} 