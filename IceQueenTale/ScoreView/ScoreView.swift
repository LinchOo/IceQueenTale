import SwiftUI

struct ScoreView: View {
    
    @Binding var isScore: Bool
    @Binding var MainTabOffSetY: CGFloat
    @EnvironmentObject var viewModel: DataController
    
    var body: some View {
        VStack{
            Text("Score Table")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(.blue)
                .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                .padding()
                .padding(.horizontal)
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
                .padding(.top,40)
            VStack{
                HStack(spacing: 15){
                    Text("Name")
                    Text(":")
                    Text("Time")
                    Text(":")
                    Text("Stars")
                }
                
                Divider()
                ScrollView{
                    VStack{
                        ForEach(viewModel.savedEntitys){ lvl in
                                HStack{
                                    Spacer()
                                    Text(lvl.title!)
                                        .font(.callout)
                                    Text(":")
                                    Text("\(TimerFormater(seconds:Int(lvl.time)))")
                                        .font(.callout)
                                    Text(":")
                                    scoreStars(starsEarned: Int(lvl.stars))
                                }
                                .padding(.trailing, 30)
                                Divider()
                            }
                        }
                    }
                    .frame(height: 230)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top,70)
            .frame(width: UIScreen.main.bounds.width - 30, height: 400)
            .background{
                Image("lvlbutton")
                    .resizable()
                    .allowsHitTesting(false)
            }
            Spacer()
            Button{
                withAnimation {
                    isScore.toggle()
                    MainTabOffSetY = 0
                }
            }label: {
                Text("Menu")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundColor(.blue)
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
            .padding(.bottom)
                
        }
        .padding(.top,40)
        .background{
            Color.clear
        }
    }
    func TimerFormater(seconds:Int) -> String {
        let minutes = "\((seconds % 3600) / 60)"
        let seconds = "\((seconds % 3600) % 60)"
        let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
        let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
        
        return "\(minuteStamp) : \(secondStamp)"
    }
    
}
struct scoreStars: View{
    @State var starsEarned: Int
    var body: some View {
        ZStack(alignment: .bottom){
            HStack(spacing:0){
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .rotationEffect(Angle(degrees: -25))
                    .foregroundColor(starsEarned > 0 ? Color("gold") : Color.gray)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .offset(y:-6)
                    .foregroundColor(starsEarned > 1 ? Color("gold") : Color.gray)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .rotationEffect(Angle(degrees: 25))
                    .foregroundColor(starsEarned > 2 ? Color("gold") : Color.gray)
            }
            .padding(.horizontal,5)
            .frame(width: 55, height: 30,alignment: .leading)
        }
        .shadow(color: .black, radius: 2, x: 0, y: 1)
    }
    
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(isScore: .constant(true), MainTabOffSetY: .constant(1000))
            .environmentObject(DataController())
    }
}
