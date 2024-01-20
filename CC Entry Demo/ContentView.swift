/*--------------------------------------------------------------------------------------------------------------------------
    File: ContentView.swift
  Author: Kevin Messina
 Created: 1/12/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int
    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension TextField {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

struct cardFrontView: View {
    let ccInfo: CCInfo
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("Xanadu Bank")
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundStyle(Color("LtOrange"))
                            .italic()
                            .padding(.leading, -5)

                        Spacer()
                    }

                    Text(ccInfo.cardNumber)
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .shadow(color: .black, radius: 1, x:1, y:1)
                        .foregroundStyle(.white)
                        .padding(.leading, -20)
                }
                .frame(height:80)
                .padding(.top,10)
                .padding(.leading,20)
                
                Spacer()

                HStack {
                    VStack(alignment: .leading) {
                        Text("CARD HOLDER")
                            .opacity(0.5)
                            .font(.system(size: 14))
                        
                        Text(ccInfo.cardholderName.uppercased())
                    }

                    Spacer()
                
                    VStack(alignment: .leading) {
                        Text("EXPIRES")
                            .opacity(0.5)
                            .font(.system(size: 14))
                        
                        Text(ccInfo.expirationDate)
                    }
                }
                .padding()
                .padding(.bottom,20)
            }
            .foregroundStyle(.white)
            .frame(width:350,height:250)
            .background(
                .linearGradient(colors: [.red,.red,.orange,.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous ))

            HStack {
                HStack {
                    Text("NFC")
                        .font(.caption)
                        .bold()

                    Image(systemName: "wave.3.forward")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height:35)
                        .padding(.leading,-13)
                }
                .padding(.leading,40)
                .foregroundStyle(Color("Gold"))

                Spacer()
                
                Image(systemName: "cpu.fill")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height:35)
                    .foregroundStyle(Color("Gold"))
                    .background(.white)
                    .cornerRadius(8.0)
                    .padding(.trailing,40)
            }
        }
    }
}

struct cardBackView: View {
    let ccInfo: CCInfo
    
    var body: some View {
        VStack{
            Rectangle()
                .fill(Color("darkBrown"))
                .frame(maxWidth: .infinity, maxHeight: 32)
                .padding(.top,20)
            
            Spacer()
            
            HStack {
                Text(ccInfo.ccvCode)
                    .frame(width: 70, height: 33, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .background(.white)
                    .foregroundStyle(.black)
                    .rotation3DEffect(.degrees(180),axis: (x: 0.0, y: 1.0, z: 0.0))
                    .padding([.leading,.trailing,.bottom],20)

                Spacer()

                Text("VISA")
                    .font(.system(size: 30, weight: .bold, design: .monospaced))
                    .italic()
                    .padding([.leading,.bottom],15)
                    .rotation3DEffect(.degrees(180),axis: (x: 0.0, y: 1.0, z: 0.0))
            }
        }
        .foregroundStyle(.white)
        .frame(width:350,height:250)
        .background(
            .linearGradient(colors: [.red,.red,.orange,.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous ))
    }
}

struct CCInfo {
    var cardholderName: String = ""
    var cardNumber: String = ""
    var expirationDate: String = ""
    var ccvCode: String = ""
}

struct CheckoutFormView: View {
    @Binding var ccInfo: CCInfo
    @FocusState var isCCVFocused: Bool
    let onCCVFocused: () -> Void
    @State private var isReset: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading,spacing:2) {
                        Text("Card Number").font(.footnote)
                        TextField("Card Number", text: $ccInfo.cardNumber)
                            .limitInputLength(value: $ccInfo.cardNumber, length: 16)
                            .keyboardType(.numberPad)
                    }
                }

                HStack {
                    VStack(alignment: .leading,spacing:2) {
                        Text("Cardholders Name").font(.footnote)
                        TextField("Cardholder's Name", text: $ccInfo.cardholderName)
                            .keyboardType(.namePhonePad)
                            .autocapitalization(.allCharacters)
                    }
                }
                .padding(.top,6)

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading,spacing:2) {
                        Text("Exp. Date").font(.footnote)
                        TextField("Exp. Date", text: $ccInfo.expirationDate)
                            .limitInputLength(value: $ccInfo.expirationDate, length: 5)
                            .keyboardType(.numbersAndPunctuation)
                            .frame(width:100)
                    }
                    .padding(.trailing,10)

                    VStack(alignment: .leading,spacing:2) {
                        Text("CCV Code").font(.footnote)
                        TextField("CCV", text: $ccInfo.ccvCode)
                            .limitInputLength(value: $ccInfo.ccvCode, length: 3)
                            .keyboardType(.numberPad)
                            .focused($isCCVFocused)
                            .frame(width:80)
                    }

                    Spacer()
                    
                    Button {
                        ccInfo = CCInfo()
                        let UD = UserDefaults.standard
                        UD.set("", forKey: "name")
                        UD.set("", forKey: "number")
                        UD.set("", forKey: "expires")
                        UD.set("", forKey: "CCV")
                        
                        isReset.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red)
                            .frame(width: 80, height: 40)
                            .overlay{
                                Text("Reset")
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                    }
                    .alert(isPresented: $isReset) {
                        Alert(
                            title: Text("Details Reset"),
                            message: Text("The information for the Credit Card details has been reset.")
                        )
                    }
                }
                .padding(.top,6)
            }
            .padding(.horizontal,20)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: isCCVFocused) { onCCVFocused() }
        }
        .padding(.vertical,15)
        .background(RoundedRectangle(cornerRadius: 15.0).fill(.black.opacity(0.15)))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(.black, lineWidth: 1))
        .padding(.horizontal,20)
    }
}

struct ContentView: View {
    @State var ccInfo = CCInfo()
    @State private var flipped: Bool = false
    @State private var degrees: Double = 0

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    if flipped {
                        cardBackView(ccInfo: ccInfo)
                    }else{
                        cardFrontView(ccInfo: ccInfo)
                    }
                }
                .rotation3DEffect(.degrees(degrees),axis: (x: 0.0, y: 1.0, z: 0.0))
                .padding(.bottom,50)
                
                CheckoutFormView(ccInfo: $ccInfo) {
                    withAnimation {
                        degrees = flipped ? 0 :180
                        flipped.toggle()
                    }
                }
                
                Spacer()
            }
            .navigationTitle("New Card Details")
        }
        .onAppear() {
            let UD = UserDefaults.standard
            ccInfo = CCInfo.init(
                cardholderName: UD.string(forKey: "name") ?? "",
                cardNumber: UD.string(forKey: "number") ?? "",
                expirationDate: UD.string(forKey: "expires") ?? "",
                ccvCode: UD.string(forKey: "CCV") ?? ""
            )
        }
        .onDisappear() {
            let UD = UserDefaults.standard
            UD.set(ccInfo.cardholderName, forKey: "name")
            UD.set(ccInfo.cardNumber, forKey: "number")
            UD.set(ccInfo.expirationDate, forKey: "expires")
            UD.set(ccInfo.ccvCode, forKey: "CCV")
        }
    }
}

#Preview {
    ContentView()
}
