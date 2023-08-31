import SwiftUI

struct LvLCell: View {
    @State var isSelect = false
    @State var imageName: String
    @State var stars: Int
    @State var pass: Bool
    @State var time: Int
    @State var title: String
    @Binding var lvlSelected: String
    @Binding var isStartGame: Bool
    @Binding var LeveLSelectionOffSetX: CGFloat
    
    var body: some View {
        design
    }
    private var design: some View{
        ZStack(alignment: .top){
            VStack{
                Text(title)
                    .font(.system(size: 20, weight: .black, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
            }
            .padding(.top, 25)
            .zIndex(4)
            ZStack{
                Image("lvlbutton")
                    .resizable()
                    .scaledToFit()
                    .zIndex(0)
                    .shadow(color: imageName == lvlSelected ? .green.opacity(0.5) : .black.opacity(0.3), radius: 10)
                    .shadow(color: imageName == lvlSelected ? .green.opacity(0.5) : .black.opacity(0.3), radius: 10)
                Image("lvlbutton")
                    .resizable()
                    .scaledToFit()
                    .zIndex(1)
                    .onTapGesture {
                        if pass{
                            withAnimation {
                                isSelect.toggle()
                                lvlSelected = imageName
                            }
                        }
                    }
                    .background{
                        Image(imageName)
                            .resizable()
                            .frame(width: 260,height: 180)
                            .zIndex(0)
                            .overlay {
                                if !pass {
                                    Color.gray.opacity(0.8)
                                }
                            }
                            
                    }
                    .overlay{
                        if !pass{
                            ZStack{
                                Image(systemName: "lock")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 30)
                                    .padding()
                                    .background{
                                            Circle()
                                            .foregroundColor(.gray.opacity(0.3))
                                    }
                            }
                        }
                        if imageName == lvlSelected {
                            Button{
                                //                                    lvlSelected = imageName
                                lvlSelected = imageName
                                withAnimation{
                                    isStartGame.toggle()
                                    LeveLSelectionOffSetX = -500
                                    
                                }
                            }label: {
                                Image("play")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100,height: 100)
                            }
                        }
                        
                    }
                
                switch stars{
                case 1:
                    starsView1
                        .foregroundColor(Color("gold"))
                        .offset(y:80)
                        .shadow(color: Color("gold").opacity(0.3), radius: 3, x: -1, y: -1)
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 1, y: 1)
                        .zIndex(2)
                case 2:
                    starsView2
                        .foregroundColor(Color("gold"))
                        .offset(y:80)
                        .shadow(color: Color("gold").opacity(0.3), radius: 3, x: -1, y: -1)
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 1, y: 1)
                        .zIndex(2)
                case 3:
                    starsView3
                        .foregroundColor(Color("gold"))
                        .offset(y:80)
                        .shadow(color: Color("gold").opacity(0.3), radius: 3, x: -1, y: -1)
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 1, y: 1)
                        .zIndex(2)
                    
                default:
                    starsView3
                        .foregroundColor(Color.gray)
                        .offset(y:80)
                        .shadow(color: Color("gold").opacity(0.3), radius: 3, x: -1, y: -1)
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 1, y: 1)
                        .zIndex(2)
                        .frame(alignment: .bottom)
                }
            }
            
            .frame(width: 330,height: 200)
            
        }
    }
    
    private var starsView1: some View {
        HStack(spacing: 5){
            
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .offset(y:-10)
        }
        .padding(.horizontal,5)
        .frame(width: 100, height: 50,alignment: .center)
    }
    private var starsView2: some View {
        HStack(spacing: 5){
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .rotationEffect(Angle(degrees: -25))
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .offset(y:-10)
//            Spacer()
        }
        .padding(.horizontal,5)
        .frame(width: 100, height: 50,alignment: .leading)
    }
    private var starsView3: some View {
        ZStack(alignment: .bottom){
            HStack(spacing: 5){
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .rotationEffect(Angle(degrees: -25))
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .offset(y:-10)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .rotationEffect(Angle(degrees: 25))
            }
            .padding(.horizontal,5)
        .frame(width: 100, height: 50,alignment: .leading)
        }
    }
}

struct LvLCell_Previews: PreviewProvider {
    static var previews: some View {
        LvLCell(imageName: "level_1", stars: 3, pass: false, time: 0,title: "Ice", lvlSelected: .constant(""), isStartGame: .constant(false), LeveLSelectionOffSetX: .constant(0))
    }
}
