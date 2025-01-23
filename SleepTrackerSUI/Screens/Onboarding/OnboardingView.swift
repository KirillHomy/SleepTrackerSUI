//
//  OnboardingView.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//\

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    var body: some View {
        if isOnboarding {
            NavigationStack {
                TabView {
                    VStack {
                        Image(systemName: "star")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .padding([.top, .horizontal], 40)
                        Spacer()
                        VStack(spacing: 15) {
                            Text("Track Your Sleep Pattern and Improve it")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Get insights into your sleep patterns ans wake up refreshed with SleepTrackerSUI")
                                .font(.subheadline)
                            Button("Get Started") {
                                isOnboarding.toggle()
                            }
                            .frame(width: 380, height: 50, alignment: .center)
                            .cornerRadius(25)
                            .font(.title2)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .frame(width: 380, height: 50, alignment: .center)
                            .cornerRadius(25)
                            VStack {
                                Text("Bu continuing, you agree to SleepTrackerSUI's" + "\n") +
                                Text("Terms of Service").bold() +
                                Text(" and ") +
                                Text("Privacy Policy").bold()
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        }
                        .multilineTextAlignment(.center)
                    }
                    .padding(.bottom)
                }
                .navigationTitle("Sleep Tracker")
                .tabViewStyle(.automatic)
            }
        } else {
            TabBarView()
        }
    }
}

#Preview {
    OnboardingView()
}
