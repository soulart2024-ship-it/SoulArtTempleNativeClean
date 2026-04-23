import SwiftUI

struct AppBackground<Content: View>: View {

    let imageName: String
    let content: Content

    init(imageName: String, @ViewBuilder content: () -> Content) {
        self.imageName = imageName
        self.content = content()
    }

    var body: some View {

        ZStack {

            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            content
        }
    }
}
