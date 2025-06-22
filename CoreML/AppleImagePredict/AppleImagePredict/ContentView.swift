//
//  ContentView.swift
//  AppleImagePredict
//
//  Created by NishanthVibishKavi on 3/14/25.
//

import SwiftUI
import CoreML
struct ContentView: View {
    var imageArray: [String] = ["1","2","3","4","5","6","7"]
    @State private var currentIndex = 0
    let cormlModel = try! MobileNetV2(configuration: MLModelConfiguration())
    @State private var dictionaryArray: [String: Double] = [:]
    private var sortedProbs: [Dictionary<String, Double>.Element] {
        let probsArray = Array(dictionaryArray)
        return probsArray.sorted { lhs, rhs in
            lhs.value > rhs.value
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            imageView
            buttonViews

            
            ListView(dic: sortedProbs)
            
        }
        .padding([.trailing, .leading], 20)
        .padding([.bottom, .top], 20)
    }
    
    private var imageView: some View{
        return Image(imageArray[currentIndex])
            .resizable()
            .frame(width: 300,height: 300)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var buttonViews: some View{
        return HStack{
            Button {
                self.currentIndex -= 1
            } label: {
                Image(systemName: "lessthan.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
            .disabled(self.currentIndex == 0)

            Spacer()
            
            Button {
                guard let uiimages = UIImage(named: self.imageArray[currentIndex]) else{ return }
                
                let resizeImage = uiimages.resizeImages(CGSize(width: 224, height: 224))
                guard let cvpixelImage = resizeImage.toCVPixelBuffer() else{return}
                
                do{
                    let imagePredict = try cormlModel.prediction(image: cvpixelImage)
                    self.dictionaryArray = imagePredict.classLabelProbs
                }
                catch {
                    print("")
                }
            } label: {
                Text("Predict Image")
            }
            .buttonStyle(.borderedProminent)

            
            Spacer()
            
            Button {
                self.currentIndex += 1
            } label: {
                Image(systemName: "greaterthan.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }.buttonStyle(.bordered)
                .disabled(self.currentIndex == self.imageArray.count - 1)
                .padding()

        }
    }
}


#Preview {
    ContentView()
}


struct ListView: View {
    let dic: [Dictionary<String, Double>.Element]
    var body: some View {
        List(dic, id: \.key) { (key, value) in
            HStack {
                Text(key)
                Spacer()
                Text(NSNumber(value: value), formatter: NumberFormatter.percentage)
            }
            
        }
        .listStyle(.plain)
            
        
    }
}

