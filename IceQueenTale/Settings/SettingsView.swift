import SwiftUI
import StoreKit

struct SettingsView: View {
    @State var isMusic = true
    
    @State var feedBackText = ""
    @State var isFeedBack = false
    @State var isFeedBackSent = false
    @State var showingAlert = false
    
    @Binding var isSettings: Bool
    @Binding var MainTabOffSetX: CGFloat
    @EnvironmentObject var viewModel: DataController
//    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack(alignment: .top){
            HStack{
                Spacer()
                Button{
                    withAnimation {
                        isSettings.toggle()
                        MainTabOffSetX = 0
                    }
                  
                }label: {
                    Text("Menu")
                        .font(.system(size: 15, weight: .black, design: .rounded))
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
            .padding(.top,40)
            .padding()
//            Spacer()
            ZStack(alignment: .center){
                VStack(spacing: 30){
//                    musicSection
                    vibroSection
                    Button{
                        withAnimation {
                            isFeedBack.toggle()
                        }
                        
                    }label: {
                        Text("FeedBack")
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
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                    SKStoreReviewController.requestReview(in: scene)
                                }
                    }label: {
                        Text("Rate Us")
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
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            Spacer()
        }
        .background{
            Color.clear
        }
        .overlay {
            if isFeedBack{
                FeedBackView
            }
        }
    }
    
    private var musicSection: some View {
        HStack{
            Button{
                withAnimation {
                    viewModel.isMusic.toggle()
                }
            }label: {
                Text("Music")
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
            Image(systemName: "music.note")
                .resizable()
                .foregroundColor(viewModel.isMusic ? .blue : .black.opacity(0.5))
                .frame(width: 25, height: 25)
                .scaledToFit()
                .padding(20)
                .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                .overlay(content: {
                    Rectangle()
                        .frame(height: 5)
                        .padding(.horizontal,10)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundColor(.black.opacity(0.5))
                        .opacity(viewModel.isMusic ? 0.0 : 1)
                })
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
        }
    }
    private var vibroSection: some View {
        HStack{
            Button{
                withAnimation {
                    viewModel.isVibro.toggle()
                }
            }label: {
                Text("Vibro")
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
            Image(systemName: "iphone.radiowaves.left.and.right")
                .resizable()
                .foregroundColor(viewModel.isVibro ? .blue : .black.opacity(0.5))
                .frame(width: 30, height: 25)
                .scaledToFit()
                .padding(20)
                .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                .shadow(color: .white, radius: 0.5, x: -1, y: -1)
                .overlay(content: {
                    Rectangle()
                        .frame(height: 5)
                        .padding(.horizontal,10)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundColor(.black.opacity(0.5))
                        .opacity(viewModel.isVibro ? 0.0 : 1)
                })
                .background{
                    Image("iceButton")
                        .resizable()
                        .shadow(color: .cyan, radius: 4, x: 1, y: 1)
                        .shadow(color: .cyan, radius: 4, x: -1, y: -1)
                }
        }
    }
    private var FeedBackView: some View {
        VStack{
            Text("FeedBack")
                .foregroundColor(.blue)
                .font(.system(size: 30, weight: .black, design: .rounded))
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
            VStack{
                List{
                    Text("Enter the messege")
                        .allowsHitTesting(false)
                    ZStack{
                        TextEditor(text: $feedBackText)
                        Text(feedBackText).opacity(0).padding(.all,8)
                    }
                    .shadow(radius: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 45))
                .overlay {
                    Image("lvlbutton")
                        .resizable()
                        .allowsHitTesting(false)
                }
                HStack(spacing: 80){
                    Button{
                        if feedBackText == "" {
                            showingAlert.toggle()
                        }
                        else{
                            feedBackText = ""
                            withAnimation {
                                isFeedBackSent.toggle()
                            }
                        }
                        
                        
                    }label: {
                        Text("Send")
                            .font(.system(size: 15, weight: .black, design: .rounded))
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
                            isFeedBack.toggle()
                        }
                        feedBackText = ""
                    }label: {
                        Text("Back")
                            .font(.system(size: 15, weight: .black, design: .rounded))
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
                Spacer()
            }
            .alert("Your message is empty", isPresented: $showingAlert) {
                       Button("OK", role: .cancel) { }
                   }
            .overlay(content: {
                if isFeedBackSent {
                    feedBackSent
                }
            })
            .frame(width: 300, height: 250)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
        
    }
    private var feedBackSent: some View {
        VStack{
            Text("FeedBack sent..")
                .foregroundColor(.green.opacity(0.7))
        }
        .padding()
//        .background(.ultraThinMaterial)
        .frame(width: 200, height: 50)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation {
//                    isFeedBackSent.toggle()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isSettings: .constant(true), MainTabOffSetX: .constant(500))
            .environmentObject(DataController())
    }
}
