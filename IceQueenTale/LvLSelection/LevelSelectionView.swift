import SwiftUI

struct LevelSelectionView: View {
//    @EnvironmentObject var viewModel: LeveLViewModel
    @EnvironmentObject var viewModel: DataController
    @Binding var isPlayMenu: Bool
    @Binding var MainTabOffSetX: CGFloat
    
    @State var isLvLSelected: Bool = false
    @State var isStartGame: Bool = false
    @State var chapterSelect = "One"
    @State var lvlSelected = ""
    @State var LeveLSelectionOffSetX: CGFloat = 0

    var body: some View {
        VStack{
            ZStack(alignment: .top){
                HStack(spacing: 0){
                    Button{
                        withAnimation {
                            isPlayMenu.toggle()
                            withAnimation {
                                MainTabOffSetX = 0
                            }
                        }
                    }label: {
                        Text("Menu")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                            .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                            .padding(5)
                            .padding(.horizontal,5)
                        
                    }
                    .background{
                        Image("iceButton")
                            .resizable()
                            .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                            .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                    }
                    .padding()
                    Spacer()
                }
                .padding(.top,40)
                .zIndex(4)
                .frame(alignment: .leading)
                HStack{
                    Capsule()
                        .fill(Color.white)
                        .frame(width: chapterSelect == "One" ? 15 : 7 ,height: 7)
                        .shadow(radius: 1)
                    Capsule()
                        .fill(Color.white)
                        .frame(width: chapterSelect == "Two" ? 15 : 7 ,height: 7)
                        .shadow(radius: 1)
                    //                Capsule()
                    //                    .fill(Color.white)
                    //                    .frame(width: chapterSelect == "3" ? 15 : 7 ,height: 7)
                }.offset(y:170)
                TabView(selection: $chapterSelect){
                    chapterOne
                        .tag("One")
                    chapterTwo
                        .tag("Two")
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .offset(x: LeveLSelectionOffSetX)
        }
        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
        .background{
            Color.clear
        }
        .overlay {
            if isStartGame {
                GameView(LeveLSelectionOffSetX: $LeveLSelectionOffSetX, lvlSelected: $lvlSelected, isStartGame: $isStartGame, isPlayMenu: $isPlayMenu, MainTabOffSetX: $MainTabOffSetX)
                    .transition(.asymmetric(insertion: .offset(x: 500), removal: .offset(x: 500)))
                    .environmentObject(viewModel)
                
            }
        }
    }

    private var chapterOne: some View{
        ZStack(alignment: .top){
            Text("= Chapter One =")
                .font(.system(size: 20, weight: .black, design: .serif))
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .padding(.top,70)
                .frame(alignment: .center)
                .shadow(color: .black, radius: 5, x: 1.5, y: 1.5)
                .shadow(color: .black, radius: 5, x: 1.5, y: 1.5)
                .zIndex(3)
            ScrollView(showsIndicators: false){
                VStack{
//                    ForEach(viewModel.lvlDB.savedEntitys, id: \.self) { lvl in
                    ForEach(viewModel.savedEntitys, id: \.self) { lvl in
                        if lvl.number < 10{
                            LvLCell(imageName: lvl.lvlName ?? "", stars: Int(lvl.stars), pass: lvl.pass, time: Int(lvl.time),title: lvl.title ?? "", lvlSelected: $lvlSelected, isStartGame: $isStartGame, LeveLSelectionOffSetX: $LeveLSelectionOffSetX)
                                .padding(.top, 35)
                        }
                    }
                }
                .padding(.top, 100)
            }
        }
    }
    private var chapterTwo: some View{
        ZStack(alignment: .top){
            Text("= Chapter Two =")
                .font(.system(size: 20, weight: .black, design: .serif))
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .padding(.top,70)
                .frame(alignment: .center)
                .shadow(color: .black, radius: 5, x: 1.5, y: 1.5)
                .shadow(color: .black, radius: 5, x: 1.5, y: 1.5)
                .zIndex(3)
            ScrollView(showsIndicators: false){
                VStack{
//                    ForEach(viewModel.lvlDB.savedEntitys, id: \.self) { lvl in
                    ForEach(viewModel.savedEntitys, id: \.self) { lvl in
                        if lvl.number > 9 {
                            LvLCell(imageName: lvl.lvlName ?? "", stars: Int(lvl.stars), pass: lvl.pass, time: Int(lvl.time),title: lvl.title ?? "", lvlSelected: $lvlSelected, isStartGame: $isStartGame, LeveLSelectionOffSetX: $LeveLSelectionOffSetX)
                                .padding(.top, 35)
                        }
                    }
                }
                .padding(.top, 100)
            }
        }
    }
}

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView(isPlayMenu: .constant(true), MainTabOffSetX: .constant(-500))
            .environmentObject(DataController())
    }
}
