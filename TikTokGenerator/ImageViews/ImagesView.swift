import SwiftUI



struct ImageCardView: View {
    let index: Int
    @ObservedObject var vm: GeneratorViewModel

    @GestureState private var topicDragOffset = CGSize.zero
    @GestureState private var summaryDragOffset = CGSize.zero

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: vm.results[index].imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .frame(width: 393 * 9 / 16, height: 393)
                }

                if index < vm.topicOffsets.count && index < vm.summaryOffsets.count {
                    Text(vm.results[index].topic)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 200, alignment: .leading)
                        .offset(
                            x: vm.topicOffsets[index].width + topicDragOffset.width,
                            y: vm.topicOffsets[index].height + topicDragOffset.height
                        )
                        .gesture(
                            DragGesture()
                                .updating($topicDragOffset) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    vm.topicOffsets[index].width += value.translation.width
                                    vm.topicOffsets[index].height += value.translation.height
                                }
                        )

                    Text(vm.results[index].summary)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 220, alignment: .leading)
                        .offset(
                            x: vm.summaryOffsets[index].width + summaryDragOffset.width,
                            y: vm.summaryOffsets[index].height + summaryDragOffset.height
                        )
                        .gesture(
                            DragGesture()
                                .updating($summaryDragOffset) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    vm.summaryOffsets[index].width += value.translation.width
                                    vm.summaryOffsets[index].height += value.translation.height
                                }
                        )
                }
            }

            Button("Re-Generate with Diffusion") {
                Task {
                    await vm.generateWithDiffusion(index: index)
                }
            }
            .padding(.top, 8)
        }
        .frame(width: 393)
    }
}


#Preview {
    ImagesView(vm: GeneratorViewModel())
}

