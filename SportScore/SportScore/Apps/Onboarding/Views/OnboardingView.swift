//
//  OnboardingView.swift
//  SportScore
//
//  Created by pc on 05/09/2024.
//

import SwiftUI

enum OnboardingPages: String, CaseIterable {
    case ListSport
    case ListCountry
    case ListLeagues
}

extension OnboardingPages {
    @ViewBuilder
    func getView() -> some View {
        switch self {
        case .ListSport:
            OnboardingListSportView()
        case .ListCountry:
            OnboardingListCountryView()
        case .ListLeagues:
            OnboardingListLeaguesView()
        }
    }
}

struct OnboardingPageModel {
    let page: OnboardingPages
    let title: String
    let description: String
    let imageName: String?
}

struct OnboardingView: View {
    
    @StateObject var countryVM = CountryViewModel()
    @StateObject var leagueVM = LeaguesViewModel(leagueRepository: RemoteLeagueRepository(sportAPI: LeaguesSportAPIEvent()))
    
    @Binding var isFirstLaunch: Bool
    @State private var currentPage = 0
    @State private var offsetY: CGFloat = 0 // Parallax effect
    
    let gradientColors = [Color.purple, Color.blue, Color.pink]
    
    var pages = [
        OnboardingPageModel(page: .ListSport, title: "Explore Sports", description: "Discover a wide range of sports to follow.", imageName: "sport_icon"),
        OnboardingPageModel(page: .ListCountry, title: "Find Countries", description: "Explore countries around the globe.", imageName: "world_icon"),
        OnboardingPageModel(page: .ListLeagues, title: "Top Leagues", description: "Follow the top leagues from various countries.", imageName: "league_icon")
    ]
    
    var body: some View {
        ZStack {
            // Animated gradient background
            /*
          LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
              .ignoresSafeArea()
              .animation(.easeInOut(duration: 2), value: currentPage)
            */
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count) { index in
                        VStack {
                            // Title with larger font and gradient text
                            Text(pages[index].title)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(LinearGradient(colors: [Color.yellow, Color.white], startPoint: .top, endPoint: .bottom))
                                .padding(.top, 50)
                                .shadow(radius: 2)
                            
                            Text(pages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            pages[index].page.getView()
                                .padding(.top, 30)
                                .scaleEffect(currentPage == index ? 1 : 0.95)
                                .animation(.easeInOut(duration: 0.5), value: currentPage)
                        }
                        .padding(.horizontal)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                //.frame(height: 500)
                /*
                .gesture(DragGesture().onChanged { value in
                    offsetY = value.translation.height // Detect vertical scrolling for parallax
                })
                 */
                
                // Custom page indicator
                HStack {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.gray.opacity(0.5))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.3 : 1)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isFirstLaunch = false
                        }
                    }) {
                        Text("Skip")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                isFirstLaunch = false
                            }
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
        .onAppear{
            countryVM.fetch { countries in
                countryVM.filter(by: "England") { countriesFT in
                    /*
                    leagueVM.fetch(from: countriesFT[0], by: SportType.Soccer.rawValue) {
                        print("=== leagueVM.fetch", leagueVM.models.count)
                    }
                     */
                    
                    Task {
                        await leagueVM.fetchLeagues(from: countriesFT[0], by: SportType.Soccer.rawValue)
                    }
                }
            }
        }
        .environmentObject(countryVM)
        .environmentObject(leagueVM)
    }
}
