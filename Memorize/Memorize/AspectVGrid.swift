//
//  AspectVGrid.swift
//  Memorize
//
//  Created by David Inga on 7/26/21.
//

import SwiftUI

struct AspectVGrid<Element, ElementView>: View where Element: Identifiable, ElementView: View {
    var items: [Element]
    var aspectRatio: CGFloat
    var content: (Element) -> ElementView

    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    init(items: [Element], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Element) -> ElementView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

//struct Letter: Identifiable {
//    let id = UUID()
//    let value: String
//
//    init(_ value: String) {
//        self.value = value
//    }
//}
//
//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid(items: [Letter("A"), Letter("B"), Letter("C"), Letter("D")], aspectRatio: 2/3) { letter in
//            ZStack {
//                Text(letter.value)
//                RoundedRectangle(cornerRadius: 25.0)
//            }
//
//        }
//    }
//}
