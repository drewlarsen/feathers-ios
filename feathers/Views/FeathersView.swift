import SwiftUI
import WebKit

struct FeathersView: View {
    @State private var feathers: [Feather] = []
    @State private var currentIndex: Int = 0
    @State private var isShowingWebSheet = false
    
    private let aspectRatio: CGFloat = 0.5 // 1:2 ratio (width:height)
    private let controlsHeight: CGFloat = 120 // Height needed for name + buttons
    
    private var backgroundColor: Color {
        guard !feathers.isEmpty,
              let rgb = feathers[currentIndex].light_color_rgb
        else { return .white }
        return Color.fromRGBString(rgb)
    }
    
    private var foregroundColor: Color {
        guard !feathers.isEmpty,
              let rgb = feathers[currentIndex].dark_color_rgb
        else { return .white }
        return Color.fromRGBString(rgb)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    backgroundColor
                        .ignoresSafeArea()
                        .animation(.easeInOut(duration: 0.5), value: currentIndex)
                    
                    if feathers.isEmpty {
                        ProgressView("Loading…")
                            .onAppear { load() }
                    } else {
                        VStack(spacing: 16) {
                            GeometryReader { tabGeometry in
                                TabView(selection: $currentIndex) {
                                    ForEach(feathers.indices, id: \.self) { idx in
                                        FeatherCardView(feather: feathers[idx])
                                            .aspectRatio(aspectRatio, contentMode: .fit)
                                            .frame(width: tabGeometry.size.width * 0.8)
                                            .tag(idx)
                                            .onTapGesture {
                                                isShowingWebSheet = true
                                            }
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .background(Color.clear)
                            }
                            
                            VStack(spacing: 8) {
                                Text("\(feathers[currentIndex].name ?? "")")
                                    .font(.headline)
                                    .foregroundColor(foregroundColor)
                                    .multilineTextAlignment(.center)
                                
                                HStack(spacing: 40) {
                                    Button {
                                        currentIndex = 0
                                    } label: {
                                        Image(systemName: "backward.end")
                                            .font(.title2)
                                    }
                                    
                                    Button {
                                        currentIndex = Int.random(in: 0..<feathers.count)
                                    } label: {
                                        Image(systemName: "shuffle")
                                            .font(.title2)
                                    }
                                    
                                    Button {
                                        currentIndex = feathers.count - 1
                                    } label: {
                                        Image(systemName: "forward.end")
                                            .font(.title2)
                                    }
                                }
                            }
                            .foregroundColor(Color(.darkGray))
                        }
                        .padding(.vertical, 48)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Feathers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        shareFeather()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingWebSheet) {
            if let url = URL(string: "https://www.shaynalarsen.art/feathers/\(feathers[currentIndex].urlPath)") {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                Color.white  // Fallback if URL creation fails
            }
        }
    }
    
    private func load() {
        APIService.shared.fetchFeathers { result in
            switch result {
            case .success(let list):
                let sorted = list.sorted { $0.id < $1.id }
                feathers = sorted
                if !sorted.isEmpty {
                    currentIndex = Int.random(in: 0..<sorted.count)
                }
            case .failure(let err):
                print("Error fetching: \(err)")
            }
        }
    }
    
    private func shareFeather() {
        guard !feathers.isEmpty else { return }
        
        let feather = feathers[currentIndex]
        let items: [Any] = [
            "Check out this beautiful feather by Shayna Larsen!",
            URL(string: "https://www.shaynalarsen.art/feathers/\(feather.urlPath)")!
        ]
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Present the share sheet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
} 
