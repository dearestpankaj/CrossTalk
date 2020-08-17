import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject private var viewModel = ChatViewModel()
    @State private var showActionSheet = false

    private let formatter = DateFormatter(dateStyle: .short, timeStyle: .short)

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(viewModel.messages) { message in
                            Text(self.caption(for: message))
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                if message.isFromLocalUser {
                                    Spacer()
                                }
                                Text(message.value)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .padding()
                                    .background(message.isFromLocalUser ? Color.blue : Color.gray)
                                    .cornerRadius(20)
                                    .padding(.leading, message.isFromLocalUser ? 20 : 8)
                                    .padding(.trailing, message.isFromLocalUser ? 8 : 20)
                                    .padding(.vertical, 5)
                                if (message.isFromLocalUser == false){
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(Text(viewModel.appState.rawValue), displayMode: .inline)
            }
        }
    }

    private func actionsheetButtons() -> [ActionSheet.Button] {
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
                .default(Text("Disconnect")) {
                    self.viewModel.disconnect()
                }
            ]
        }
        buttons.append(.cancel())
        return buttons
    }

    private func caption(for message: Message) -> String {
        (message.isFromLocalUser ? "" : "\(message.username) - \(message.timestamp)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
