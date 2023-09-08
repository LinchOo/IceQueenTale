import SwiftUI
struct MainTab: View {
    @State var isPlayMenu = false
    @State var isSettings = false
    @State var isScore = false
    @State var MainTabOffSetX: CGFloat = 0
    @State var MainTabOffSetY: CGFloat = 0
    @StateObject var viewModel = DataController()
    var body: some View {
        VStack(spacing: 30){
            Spacer()
            VStack(spacing: 30){
                Button{
                    withAnimation {
                        isPlayMenu.toggle()
                        MainTabOffSetX = -500
                    }
                }label: {
                    Text("Play")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                        .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                        .padding()
                        .padding(.horizontal)
                }
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
                Button{
                    withAnimation {
                        isSettings.toggle()
                        MainTabOffSetX = 500
                    }
                }label: {
                    Text("Settings")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                        .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                        .padding()
                        .padding(.horizontal)
                }
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
                Button{
                    withAnimation {
                        isScore.toggle()
                        MainTabOffSetY = 1000
                    }
                }label: {
                    Text("Score")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                        .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                        .padding()
                        .padding(.horizontal)
                }
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
            }
            .offset(x: MainTabOffSetX, y: MainTabOffSetY)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
        .background{
            ZStack(alignment: .top){
                Image("bg")
                    .resizable()
                    .scaledToFill()
            }
        }
        .overlay {
            if isPlayMenu {
                LevelSelectionView(isPlayMenu: $isPlayMenu, MainTabOffSetX: $MainTabOffSetX)
                    .environmentObject(viewModel)
                    .transition(.asymmetric(insertion: .offset(x: 500), removal: .offset(x: 500)))
            }
            if isSettings {
                SettingsView(isSettings: $isSettings, MainTabOffSetX: $MainTabOffSetX)
                    .environmentObject(viewModel)
                    .transition(.asymmetric(insertion: .offset(x: -500), removal: .offset(x: -500)))
            }
            if isScore {
                ScoreView(isScore: $isScore, MainTabOffSetY: $MainTabOffSetY)
                    .environmentObject(viewModel)
                    .transition(.asymmetric(insertion: .offset(y: -1000), removal: .offset(y: -1000)))
            }
        }
        .ignoresSafeArea()
    }
}
