//
//  ContentView.swift
//  IrisPredictionClient
//
//  Created by Mykyta Kaisenberg on 2026-03-23.
//

import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color.indigo.opacity(0.10), Color.blue.opacity(0.10)],
    startPoint: .top, endPoint: .bottom)

struct ContentView: View {
    @StateObject private var viewModel = IrisViewModel()
    
    let flowerInfo: [Int: (name: String, image: String, description: String)] = [
        0: ("Setosa", "setosa", "Smallest of the three. Identified by its stubby petals, rarely over 2cm long."),
        1: ("Versicolor", "versicolor", "The in-between species. Medium petals with a distinctive violet-blue tint."),
        2: ("Virginica", "virginica", "The largest iris. Petals can exceed 6cm, nearly 3× the size of Setosa.")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex:"#000000").ignoresSafeArea()
                RadialGradient(
                    colors: [Color.clear, Color.black.opacity(0.4)],
                    center: .center,
                    startRadius: 200,
                    endRadius: 600
                )
                .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        if let prediction = viewModel.prediction,
                           let info = flowerInfo[prediction] {
                            HStack(alignment: .top, spacing: 16) {
                                Image(info.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .cornerRadius(14)
                                    .clipped()
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.70), lineWidth: 1))
                                    .shadow(color: .white.opacity(0.7), radius: 2, x: 0, y: 0)
                                    .shadow(color: .white.opacity(0.7), radius: 8, x: 0, y: 0)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(info.name)
                                        .font(.title2)
                                        .bold()
                                        .shadow(color: .white.opacity(0.6), radius: 1, x: 0, y: 0)
                                        .shadow(color: .white.opacity(0.3), radius: 4, x: 0, y: 0)
                                    
                                    Text(info.description)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .shadow(color: .white.opacity(0.6), radius: 1, x: 0, y: 0)
                                        .shadow(color: .white.opacity(0.3), radius: 4, x: 0, y: 0)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    TextField("Sepal Length (cm)", text: $viewModel.sepalLength)
                                        .keyboardType(.decimalPad)
                                        .coolTextFieldStyle()
                                        .onChange(of: viewModel.sepalLength) {
                                            if viewModel.sepalLength.count > 3 {
                                                viewModel.sepalLength = String(viewModel.sepalLength.prefix(3))
                                            }
                                        }
                                    
                                    TextField("Sepal Width (cm)", text: $viewModel.sepalWidth)
                                        .keyboardType(.decimalPad)
                                        .coolTextFieldStyle()
                                        .onChange(of: viewModel.sepalWidth) {
                                            if viewModel.sepalWidth.count > 3 {
                                                viewModel.sepalWidth = String(viewModel.sepalWidth.prefix(3))
                                            }
                                        }
                                }
                                HStack(spacing: 12) {
                                    TextField("Petal Length (cm)", text: $viewModel.petalLength)
                                        .keyboardType(.decimalPad)
                                        .coolTextFieldStyle()
                                        .onChange(of: viewModel.petalLength) {
                                            if viewModel.petalLength.count > 3 {
                                                viewModel.petalLength = String(viewModel.petalLength.prefix(3))
                                            }
                                        }
                                    
                                    TextField("Petal Width (cm)", text: $viewModel.petalWidth)
                                        .keyboardType(.decimalPad)
                                        .coolTextFieldStyle()
                                        .onChange(of: viewModel.petalWidth) {
                                            if viewModel.petalWidth.count > 3 {
                                                viewModel.petalWidth = String(viewModel.petalWidth.prefix(3))
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 12) {
                                Button("Predict Flower") {
                                    Task {
                                        viewModel.errorMessage = ""
                                        await viewModel.predict()
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { }
                                    }
                                }
                                .padding(.horizontal, 42)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.blue.opacity(0.6), lineWidth: 1)
                                )
                                .shadow(color: .blue.opacity(0.4), radius: 2, x: 0, y: 0)
                                .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 0)
                                .disabled(viewModel.isLoading)
                                
                                Button {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        viewModel.sepalLength = ""
                                        viewModel.sepalWidth = ""
                                        viewModel.petalLength = ""
                                        viewModel.petalWidth = ""
                                        viewModel.prediction = nil
                                        viewModel.errorMessage = ""
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                }
                                .padding(16)
                                .background(Color.black)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: .white.opacity(0.4), radius: 2, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.3), radius: 6, x: 0, y: 0)
                                .foregroundStyle(.white.opacity(0.5))
                            }
                            
                            if !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                    .shadow(color: .red.opacity(0.4), radius: 2, x: 0, y: 0)
                                    .shadow(color: .red.opacity(0.3), radius: 6, x: 0, y: 0)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView("Predicting...")
                            }
                        }
                        .padding(.top)
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.prediction)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.errorMessage)
                }
                .navigationTitle("Iris Classifier")
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
