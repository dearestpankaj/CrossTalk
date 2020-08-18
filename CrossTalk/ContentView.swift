import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject private var viewModel: ChatViewModel
    @State private var showActionSheet = false

    private let formatter = DateFormatter(dateStyle: .short, timeStyle: .short)

    var body: some View {
        NavigationView {
            VStack {
                ChatScrollView()
                .navigationBarTitle(Text(viewModel.appState.rawValue), displayMode: .inline)
                ToolbarView(showActionSheet: $showActionSheet)
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                .offset(y: viewModel.keyboardOffset)
                .animation(.easeInOut(duration: viewModel.keyboardAnimationDuration))
            }
            .animation(.easeInOut)
            .onTapGesture {
                UIApplication.shared.windows
                    .first { $0.isKeyWindow }?.endEditing(true)
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text(viewModel.actionSheetTitle), message: nil, buttons: actionSheetButtons())
        }
    }

    private func actionSheetButtons() -> [ActionSheet.Button] {
        var buttons = [ActionSheet.Button]()
        switch viewModel.appState {
        case .inactive:
            buttons += [
                .default(Text("Host Chat")) {
                    self.viewModel.startAdvertising()
                },
                .default(Text("Join Chat")) {
                    self.viewModel.startBrowsing()
                }
            ]
        default:
            buttons += [
                .default(Text(viewModel.isTranslating ?
                    "Stop Translating" :
                    "Start Translating to Dutch")) {
                        self.viewModel.isTranslating.toggle()
                },
                .default(Text("Disconnect")) {
                    self.viewModel.disconnect()
                }
            ]
        }
        buttons.append(.cancel())
        return buttons
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 11 Pro Max")
                .previewDisplayName("iPhone 11 Pro Max")

            ContentView()
                .previewDevice("iPhone SE")
                .previewDisplayName("iPhone SE")
                .environment(\.colorScheme, .dark)
        }
    }
}

struct ToolbarView: View {
    @EnvironmentObject private var viewModel: ChatViewModel
    @Binding var showActionSheet: Bool
    var body: some View {
        HStack {
            Button(action: {
                self.showActionSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
            }
            .padding(.horizontal, 8)
            TextField(viewModel.appState.notConnected ? "Inactive" : "Add message",
                      text: $viewModel.newMessageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(viewModel.appState.notConnected)
            Button(action: {
                self.viewModel.clear()
            }) {
                Image(systemName: "xmark.circle")
            }
            .disabled(viewModel.newMessageTextIsEmpty)
            Button(action: {
                self.viewModel.send()
            }) {
                Image(systemName: "paperplane")
            }
            .disabled(viewModel.newMessageTextIsEmpty)
            .padding(.horizontal, 8)
        }
    }
}
