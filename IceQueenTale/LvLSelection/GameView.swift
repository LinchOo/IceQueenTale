import SwiftUI
struct GameView: View {
    @EnvironmentObject var viewModel: DataController
    let colums: [GridItem] = [
        .init(.fixed(72), spacing: 0, alignment: nil),
        .init(.fixed(72), spacing: 0, alignment: nil),
        .init(.fixed(72), spacing: 0, alignment: nil),
        .init(.fixed(72), spacing: 0, alignment: nil)
    ]
    @State var imageArray: [UIImage] = []
    @State var imageArrayWin: [UIImage] = []
    @State var image = UIImage()
    @State var timeRemaining = 0
    @State var startTime = 0
    @State var timeHint = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var LeveLSelectionOffSetX: CGFloat
    @Binding var lvlSelected: String
    @Binding var isStartGame: Bool
    @Binding var isPlayMenu: Bool
    @Binding var MainTabOffSetX: CGFloat
    @State var isSelect = false
    @State var selectedFirstImage = -1
    @State var selectedSecondImage = -1
    @State var selectedBuffer = UIImage()
    @State var isGameOver = false
    @State var isWin = false
    @State var isPause = false
    @State var hintCount: Int = 3
    @State var starsEarned: Int = 3
    @State var hintTap: Bool = false
    var body: some View{
        VStack{
            header
                .padding(.top,40)
            stars
            Spacer()
            VStack{
                LazyVGrid(columns: colums,alignment: .center,spacing: 0) {
                    ForEach(0..<imageArray.count, id:\.self){ index in
                        if imageArray.indices.contains(index) {
                            Image(uiImage: imageArray[index])
                                .resizable()
                                .frame(width: 72, height: 72)
                                .overlay {
                                    Rectangle()
                                        .stroke(.white,lineWidth: 4)
                                }
                                .onTapGesture {
                                    if isSelect{
                                        withAnimation {
                                            selectedSecondImage = index
                                            selectedBuffer = imageArray[selectedSecondImage]
                                            imageArray[selectedSecondImage] = imageArray[selectedFirstImage]
                                            imageArray[selectedFirstImage] = selectedBuffer
                                            isSelect = false
                                        }
                                    } else {
                                        selectedFirstImage = index
                                        isSelect = true
                                    }
                                }
                        }else{
                            ProgressView()
                        }
                    }
                }
                .frame(width: 360, height: 360, alignment: .center)
                .overlay{
                    Image("lvlbutton2")
                        .resizable()
                        .disabled(true)
                        .allowsHitTesting(false)
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
                bottom
            }
            Spacer()
        }
        .background{
            Color.clear
        }
        .onAppear{
            CreatePuzzle(lvl: lvlSelected)
            SetTimer()
        }
        .ignoresSafeArea()
        .overlay {
            if hintCount >= 0 {
                if hintTap {
                    hintView
                        .onAppear{
                            timeHint = 5
                        }
                }
            }
            if isPause {
                pause
                    .onAppear{
                        timer.upstream.connect().cancel()
                    }
                    .onDisappear{
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    }
            }
            if isWin{
                winView
                    .onAppear{
                        timer.upstream.connect().cancel()
                        if viewModel.isVibro == true{
                            HapticsManager.shared.vibrate(for: .success)
                        }
                    }
            }
            if isGameOver{
                gameOverView
                    .onAppear{
                        if viewModel.isVibro{
                            HapticsManager.shared.vibrate(for: .error)
                        }
                    }
            }
        }
    }
    private var winView: some View{
        VStack{
            VStack{
                Text("Congratulations\nYou Win")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(.blue)
                    .opacity(0.5)
                    .multilineTextAlignment(.center)
                VStack{
                    HStack{
                        Text("Time left:")
                            .foregroundColor(.blue)
                        Spacer()
                        Text("\(TimerFormater(seconds:timeRemaining))")
                            .padding(.trailing,25)
                    }
                    HStack{
                        Text("Stars achived:")
                            .foregroundColor(.blue)
                        Spacer()
                        stars
                    }
                    HStack{
                        Text("Hint left")
                            .foregroundColor(.blue)
                        Spacer()
                        Text("\(hintCount) of 3")
                            .padding(.trailing, 30)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .padding(.vertical)
            .padding(.horizontal)
            .background{
                Image("lvlbutton2")
                    .resizable()
            }
            HStack{
                Button{
                    LeveLSelectionOffSetX = 0
                    saveScore()
                    withAnimation{
                        isStartGame.toggle()
                        isPlayMenu.toggle()
                        MainTabOffSetX = 0
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
                Button{
                    let number = Int(lvlSelected.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
                    let nextLvL = viewModel.savedEntitys.first{ LeveL in
                        LeveL.number == number! + 1
                    }
                    if let next = nextLvL {
                        saveScore()
                        lvlSelected = next.lvlName!
                        isWin = false
                        imageArray = []
                        CreatePuzzle(lvl: lvlSelected)
                        SetTimer()
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    }
                }label: {
                    Text("Next")
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
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
    private var gameOverView: some View{
        VStack{
            VStack{
                Text("You Lose\nTry again")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(.blue)
                    .opacity(0.5)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .padding()
            .background{
                Image("lvlbutton2")
                    .resizable()
            }
            HStack{
                Button{
                    withAnimation {
                        isStartGame.toggle()
                        LeveLSelectionOffSetX = 0
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
                Button{
                    SetTimer()
                    isGameOver.toggle()
                    imageArray.shuffle()
                }label: {
                    Text("Restart")
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
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
    private var stars: some View{
        ZStack(alignment: .bottom){
            HStack(spacing: 5){
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .rotationEffect(Angle(degrees: -25))
                    .foregroundColor(starsEarned > 0 ? Color("gold") : Color.gray)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .offset(y:-10)
                    .foregroundColor(starsEarned > 1 ? Color("gold") : Color.gray)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .rotationEffect(Angle(degrees: 25))
                    .foregroundColor(starsEarned > 2 ? Color("gold") : Color.gray)
            }
            .padding(.horizontal,5)
        .frame(width: 100, height: 50,alignment: .leading)
        }
        .shadow(color: .black, radius: 2, x: 0, y: 1)
    }
    private var pause: some View {
        VStack{
            Text("Pause")
                .font(.system(size: 40, weight: .black, design: .rounded))
                .opacity(0.5)
            Button{
                withAnimation {
                    isPause.toggle()
                }
                viewModel.getLeveLDB()
            }label: {
                Text("Back")
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
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
    private var header: some View {
        ZStack(alignment: .center) {
            Button{
                withAnimation {
                    isStartGame.toggle()
                    LeveLSelectionOffSetX = 0
                }
            }label: {
                Text("Back")
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
            .offset(x: -140)
            Spacer()
            Text(" \(TimerFormater(seconds:timeRemaining)) ")
                .foregroundColor(.blue)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                .padding(5)
                .padding(.horizontal,15)
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
                .onReceive(timer) { _ in
                    if imageArray == imageArrayWin{
                        withAnimation(){
                            isWin = true
                        }
                        timer.upstream.connect().cancel()
                    }
                    if timeRemaining == 40 {
                        if starsEarned > 0 {
                            starsEarned -= 1
                        }
                    }
                    if timeRemaining == 20 {
                        if starsEarned > 0 {
                            starsEarned -= 1
                        }
                    }
                    if timeRemaining == 10 {
                        if starsEarned > 0 {
                            starsEarned -= 1
                        }
                    }
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        withAnimation(){
                            isGameOver = true
                        }
                    }
                }
            Spacer()
            Button{
                timer.upstream.connect().cancel()
                isPause.toggle()
            }label: {
                Image(systemName: "pause.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                    .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                    .padding(.vertical,7)
                    .padding(.horizontal,28)
            }
            .background{
                Image("iceButton")
                    .resizable()
                    .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                    .shadow(color: .cyan, radius: 4, x: -1, y: -1)
            }
            .padding()
            .offset(x: 140)
        }
        .padding(.top,20)
    }
    private var hintView: some View {
        VStack{
            Text("Ice Mountain")
                .padding(10)
                .padding(.horizontal, 15)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
            Text("\(timeHint)")
                .opacity(0.5)
                .onReceive(timer) { _ in
                    if timeHint > 0 {
                        timeHint -= 1
                    } else {
                        timeRemaining += 6
                        withAnimation {
                            hintTap.toggle()
                        }
                    }
                }
            ZStack{
                Image("lvlbutton")
                    .resizable()
                    .scaledToFit()
                    .background{
                        Image(lvlSelected)
                            .resizable()
                            .padding(.horizontal)
                            .mask {
                                Image("lvlbutton")
                                    .resizable()
                            }
                    }
            }
            .frame(width: 360)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
    private var bottom: some View{
        VStack{
            Spacer()
            Button{
                withAnimation {
                    hintTap.toggle()
                    hintCount -= 1
                    if starsEarned > 0 {
                        starsEarned -= 1
                    }
                }
            }label: {
                Text("Hint")
                    .padding(10)
                    .padding(.horizontal, 15)
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                    .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                    .foregroundColor( hintCount > 0 ? Color.blue : Color.gray)
            }
            .background{
                Image("iceButton")
                    .resizable()
                    .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                    .shadow(color: .cyan, radius: 4, x: -1, y: -1)
            }
            Text("\(hintCount) / 3")
                .opacity(0.3)
            Spacer()
        }
        .disabled( hintCount > 0 ? false : true)
    }
    func SetHintTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            hintTap.toggle()
        }
    }
    func SetTimer(){
        let newStr = lvlSelected.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        timeRemaining = 150 - 10*Int(newStr)!
        startTime = timeRemaining
    }
    func saveScore(){
        if var index = Int(lvlSelected.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            print("Enter Index")
            index -= 1
            let lvl = viewModel.savedEntitys[index]
            if lvl.stars < starsEarned {
                viewModel.editStarsScore(lvl: lvl, stars: starsEarned)
                print("Saved Stars")
            }
            else
            {
                print("Stars less then in DB")
            }
            if lvl.time < timeRemaining {
                viewModel.editTimeScore(lvl: lvl, time: timeRemaining)
                print("Saved Time")
            }
            else {
                print("Time less then in DB")
            }
            viewModel.editNextLvLPass(lvl: lvl)
        }
    }
    func CreatePuzzle(lvl: String){
        let gameImage = UIImage(named: lvl)!.rebuildImage(imagesize: 350, row: 4, col: 4)
        let width = gameImage.size.width-5
        let imageConvert = gameImage.cgImage
        let sizeImage = width / 4
        for i in 0...4 - 1 {
            for j in 0...4 - 1 {
                let cropImage = imageConvert!.cropping(to: CGRect(x: CGFloat(j)*sizeImage, y: CGFloat(i)*sizeImage, width: sizeImage, height: sizeImage))
                imageArray.append(UIImage(cgImage: cropImage!))
            }
        }
        imageArrayWin = imageArray
        imageArray.shuffle()
    }
    func TimerFormater(seconds:Int) -> String {
        let minutes = "\((seconds % 3600) / 60)"
        let seconds = "\((seconds % 3600) % 60)"
        let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
        let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
        return "\(minuteStamp) : \(secondStamp)"
    }
}
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(LeveLSelectionOffSetX: .constant(0), lvlSelected: .constant("level_1"), isStartGame: .constant(true), isPlayMenu: .constant(false), MainTabOffSetX: .constant(500))
            .environmentObject(DataController())
    }
}
extension UIImage{
    func rebuildImage(imagesize: CGFloat ,row: CGFloat, col: CGFloat) -> UIImage {
        let newBuild = CGSize(width: imagesize, height: imagesize + (row - col)*imagesize/col)
        let rect = CGRect(x:0, y:0, width: newBuild.width, height: newBuild.height)
        UIGraphicsBeginImageContextWithOptions(newBuild, false, 1)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
