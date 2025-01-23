//
//  HomeView.swift
//  SleepTrackerSUI
//
//  Created by Kirill Khomicevich on 23.01.2025.
//


import SwiftUI
import UserNotifications

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                sleepTimeSliderView()
                    .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.4)
                timeView(homeViewModel: homeViewModel)
                chooseDayLabelView()
                HStack {
                    ForEach(homeViewModel.daysOfWeek, id: \.id) {
                        day in
                        Text(day.initial)
                            .frame(width: 42, height: 42)
                            .background(homeViewModel.selectedDays.contains(day.id) ? Color.gray.opacity(0.3) : Color.primary)
                            .foregroundStyle(homeViewModel.selectedDays.contains(day.id) ? .black : .white)
                            .clipShape(Circle())
                            .onTapGesture {
                                if homeViewModel.selectedDays.contains(day.id) {
                                    homeViewModel.selectedDays.remove(day.id)
                                } else {
                                    homeViewModel.selectedDays.insert(day.id)
                                }
                            }
                    }
                }
                .padding(.bottom)
//                chooseDayView(homeViewModel: homeViewModel)
                remindMeView()
            }
            .navigationTitle("Sleep Tracker")
            .navigationBarTitleDisplayMode(.large)
            .padding()
        }
        
    }
}

// MARK: - Elements View
private extension HomeView {
    
    @ViewBuilder
    func sleepTimeSliderView() -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack {
                ZStack {
                    let numbers = [12, 15, 18, 21, 0 , 3, 6, 9]
                    
                    ForEach(numbers.indices, id: \.self) {
                        index in
                        Text("\(numbers[index])")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .rotationEffect(.init(degrees: Double(index) * -45))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 45))
                    }
                }
                
                Circle()
                    .stroke(Color.black.opacity(0.06),lineWidth: 40)
                let reverseRotation = (homeViewModel.startProgress > homeViewModel.toProgress) ? -Double((1 - homeViewModel.startProgress) * 360) : 0
                
                Circle()
                    .trim(from: homeViewModel.startProgress > homeViewModel.toProgress ? 0 : homeViewModel.startProgress, to: homeViewModel.toProgress )
                    .stroke(Color.black ,style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .rotationEffect(.degrees(reverseRotation))
                
                Image(systemName: "moon.stars.fill")
                    .font(.body)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(-90))
                    .rotationEffect(.degrees(-homeViewModel.startAngel))
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.degrees(homeViewModel.startAngel))
                    .gesture (
                        DragGesture()
                            .onChanged {
                                value in
                                homeViewModel.onDrag(value: value, fromSlider: true)
                            }
                    )
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: "alarm.fill")
                    .font(.body)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(90))
                    .rotationEffect(.degrees(-homeViewModel.toAngel))
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.degrees(homeViewModel.toAngel))
                    .gesture (
                        DragGesture()
                            .onChanged {
                                value in
                                homeViewModel.onDrag(value: value)
                            }
                    )
                    .rotationEffect(.degrees(-90))
            
                HStack(spacing: 8) {
                    Text("\(homeViewModel.getTimeDifference().0)h")
                        .font(.title)
                        .fontWeight(.medium)
                    Text("\(homeViewModel.getTimeDifference().1)m")
                        .font(.title)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func elementTimeView(homeViewModel: HomeViewModel, imageName: String, subtitleText: String, isStart: Bool) -> some View {
        Image(systemName: imageName)
        VStack {
            Text(homeViewModel.getTime(angle: isStart ? homeViewModel.startAngel : homeViewModel.toAngel).formatted(date: .omitted, time: .shortened))
                .font(.title2.bold())
            Text(subtitleText)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }

    @ViewBuilder
    func timeView(homeViewModel: HomeViewModel) -> some View {
        HStack {
            elementTimeView(homeViewModel: homeViewModel, imageName: "moon.fill", subtitleText: "Bedtime", isStart: true)
            Spacer()
            elementTimeView(homeViewModel: homeViewModel, imageName: "alarm.fill", subtitleText: "Wake up", isStart: false)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func chooseDayLabelView() -> some View {
        HStack {
            Text("Choose days")
                .font(.headline)
                .bold()
            Spacer()
        }
        .padding([.top, .horizontal])
    }

//    @ViewBuilder
//    func chooseDayView(homeViewModel: HomeViewModel) -> some View {
//        HStack {
//            ForEach(homeViewModel.daysOfWeek, id: \.id) {
//                day in
//                Text(day.initial)
//                    .frame(width: 42, height: 42)
//                    .background(homeViewModel.selectedDays.contains(day.id) ? Color.gray.opacity(0.3) : Color.primary)
//                    .foregroundStyle(homeViewModel.selectedDays.contains(day.id) ? .black : .white)
//                    .clipShape(Circle())
//                    .onTapGesture {
//                        if homeViewModel.selectedDays.contains(day.id) {
//                            homeViewModel.selectedDays.remove(day.id)
//                        } else {
//                            homeViewModel.selectedDays.insert(day.id)
//                        }
//                    }
//            }
//        }
//        .padding(.bottom)
//    }
    
    @ViewBuilder
    func remindMeView() -> some View {
        HStack {
            Text("Remind me to sleep")
                .font(.headline)
                
            Spacer()
            Toggle("", isOn: $homeViewModel.isReminderEnabled)
        }
        .padding()
        .background(.white)
        .cornerRadius(20.0)
        .shadow(radius: 2)
        .tint(.primary)
        .toolbar {
            NavigationLink {
                SleepChartView()
            } label: {
                Label("Calendar", systemImage: "calendar")
            }
            .tint(.primary)
        }
    }
}

// MARK: - Private methods
private extension HomeView {
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

#Preview {
    HomeView()
}
