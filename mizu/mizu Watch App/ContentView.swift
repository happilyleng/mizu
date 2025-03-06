//
//  ContentView.swift
//  mizu Watch App
//
//  Created by mac on 2025/1/23.
//
// 菩萨保佑一定没有bug啊
// 啊啊啊啊赶时间啊
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI
import Combine
import CryptoKit
import EFQRCode
import WatchKit
import AVKit
import MarkdownUI
import AVFoundation

// MARK: - 数据模型
/// 响应数据模型
struct BilibiliResponse: Codable {
    let code: Int
    let message: String
    let data: [VideoData]
}

/// 视频数据模型
struct VideoData: Codable, Identifiable {
    let bvid: String
    var id: String { bvid }
    let title: String
    let pic: String
    let owner: Owner
    let stat: VideoStat
}

/// 视频作者信息
struct Owner: Codable {
    let name: String
    let face: String
}

/// 视频统计信息
struct VideoStat: Codable {
    let view: Int
    let like: Int
}

// 整体搜索响应
struct BilibiliSearchResponse: Codable {
    let code: Int
    let message: String
    let ttl: Int
    let data: SearchData
}

// data字段下，result实际上是一个数组
struct SearchData: Codable {
    let result: [ResultData]?
}

// 每个result项：包含 result_type 和 data 数组
struct ResultData: Codable {
    let result_type: String
    let data: [SearchResult]?
}

// 视频搜索结果模型
// 注意：JSON中视频数据包含字段 "title", "bvid", "pic", "author" 等
struct SearchResult: Codable, Identifiable {
    let title: String?
    let bvid: String?
    let pic: String?
    let author: String?

    var id: String { bvid ?? ""}
    
    // 如果你需要和之前使用的owner类型对应，可添加一个计算属性
    var owner: SearchOwner {
        SearchOwner(name: author ?? "未知", face: "")  // 这里face字段暂时留空，因为JSON中没有该数据
    }
}

// 用于展示视频的UP主信息（如果需要）
struct SearchOwner: Codable {
    let name: String
    let face: String
}

// MARK: - 视频播放模型
struct VideoInfoResponse: Codable {
    let code: Int
    let message: String
    let ttl: Int
    let data: VideoInfoData
}

struct VideoInfoData: Codable {
    let cid: Int64  // 修改为 Int64
    let pages: [Page]
}

struct Page: Codable {
    let cid: Int64  // 修改为 Int64
    let page: Int
    let part: String
}
// MARK: - 播放地址 API 的数据模型

struct VideoPlayResponse: Codable {
    let code: Int
    let message: String
    let ttl: Int
    let data: VideoPlayData
}

struct VideoPlayData: Codable {
    let dash: Dash?
    let durl: [Durl]?  // 非 DASH 格式时返回该字段
}

struct Dash: Codable {
    let video: [VideoStream]
}

struct VideoStream: Codable {
    let id: Int
    let baseUrl: String
}

struct Durl: Codable {
    let order: Int?
    let length: Int?
    let url: String
    let backup_url: [String]?
}
// MARK: - 乱搞
struct MySelf: View{
    var body:some View{
        ZStack{
            Color.white.opacity(0.2)
                .ignoresSafeArea()
            ZStack{
                Color.blue.opacity(0.1)
                    .ignoresSafeArea()
                ZStack{
                    Color.red.opacity(0.05)
                        .frame(width: 170,height: 120)
                    ZStack{
                        Color.red.opacity(0.05)
                            .frame(width: 155,height: 105)
                        ZStack{
                            Color.red.opacity(0.05)
                                .frame(width: 140,height: 90)
                            ZStack{
                                Color.red.opacity(0.05)
                                    .frame(width: 125,height: 75)
                                ZStack{
                                    Color.red.opacity(0.05)
                                        .frame(width: 110,height: 60)
                                    ZStack{
                                        Color.red.opacity(0.05)
                                            .frame(width: 95,height: 45)
                                        ZStack{
                                            Color.red.opacity(0.05)
                                                .frame(width: 80,height: 30)
                                            ZStack{
                                                Color.red.opacity(0.05)
                                                    .frame(width: 65,height: 15)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 主视图
struct ContentView: View {
    var body: some View {
        ZStack{
            Color.white.opacity(0.5)
                .ignoresSafeArea()
            ZStack{
                Color.red.opacity(0.1)
                    .ignoresSafeArea()
                NavigationView {
                    ZStack {
                        VStack{
                            Text("MIZU")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .font(.system(size: 50))
                                .foregroundStyle(Color.blue)
                                .fontWeight(.bold)
                            Text("Made")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.blue)
                            Text("by")
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                            Text("Cindy")
                                .fontWeight(.bold)
                                .foregroundColor(Color.orange)
                        }
                        ScrollView{
                            NavigationLink(destination: Index()) {
                                Text("进入首页")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.red.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: VideoSearch()) {
                                Text("进入搜索")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.orange.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: BiliLoginView()) {
                                Text("登录账号")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.yellow.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: VideoListView()) {
                                Text("下载内容")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.green.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: Ai()) {
                                Text("五河琴里")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.cyan.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: MySelf()) {
                                Text("小彩蛋哦")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.blue.opacity(0.3))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 视频列表视图
struct Index: View {
    @StateObject var consoleManager = ConsoleManager()
    @ObservedObject var downloadManager = DownloadManager.shared
    @State private var videos: [VideoData] = []
    @State private var isloading = false
    @State private var errorMessage: String? = nil
    @State private var page = 1
    @State private var hasMoreVideos = true
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack{
            ScrollView {
                LazyVStack {
                    if downloadManager.isDownloading == true{
                        NavigationLink(destination: DownloadView()) {
                            DownloadView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        SmallDivider()
                    }
                    ForEach(videos) { video in
                        NavigationLink(destination: VideoDetailIndex(video: video)) {
                            VideoRow(video: video)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width:150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 3)
                        )
                    }
                    if isloading {
                        ProgressView("加载中...")
                    } else if let errormessage = errorMessage {
                        Text("错误：\(errormessage)")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.red)
                        Button("重试"){
                            fetchVideos()
                        }
                        .foregroundStyle(Color.blue)
                    } else if hasMoreVideos {
                        Button("加载更多...") {
                            fetchVideos()
                        }
                        .foregroundStyle(Color.blue)
                    }
                }
                .padding()
            }
            .onAppear {
                if videos.isEmpty { fetchVideos() }
            }
        }
    }

    private func fetchVideos() {
        guard !isloading, hasMoreVideos else { return }
        isloading = true
        errorMessage = nil
        
        let urlStr = "https://api.bilibili.com/x/web-interface/index/top?page=\(page)&page_size=10"
        guard let url = URL(string: urlStr) else {
            errorMessage = "无效的URL"
            consoleManager.addLog("无效的URL")
            isloading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148", forHTTPHeaderField: "User-Agent")
        page += 1
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isloading = false
                if let error = error {
                    errorMessage = "请求失败：\(error.localizedDescription)"
                    consoleManager.addLog("请求失败：\(error.localizedDescription)")
                    WKInterfaceDevice.current().play(.failure)
                    return
                }
                guard let data = data else {
                    errorMessage = "没有收到数据"
                    WKInterfaceDevice.current().play(.failure)
                    return
                }
                do {
                    WKInterfaceDevice.current().play(.success)
                    let response = try JSONDecoder().decode(BilibiliResponse.self, from: data)
                    videos.append(contentsOf: response.data)
                    hasMoreVideos = !response.data.isEmpty
                    if !response.data.isEmpty {
                        page += 1
                    }
                } catch {
                    errorMessage = "数据解析失败：\(error.localizedDescription)"
                    WKInterfaceDevice.current().play(.failure)
                }
            }
        }
        .resume()
    }
}

struct ToastView: View {
    var message: String
    var body: some View {
        Text(message)
            .padding(8)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .frame(width: 300, height: 100)
    }
}
struct SmallDivider: View {
    var color: Color = .gray
    var width: CGFloat? = nil  // 可选：如果想要指定宽度，否则会自动填满父视图
    var height: CGFloat = 1    // 分割线高度
    var verticalPadding: CGFloat = 8  // 上下间距

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
            .padding(.vertical, verticalPadding)
    }
}

struct VideoRow: View {
    let video: VideoData

    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: video.pic.replacingOccurrences(of: "http", with: "https")))
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 3)
                )
            
            Text(video.title)
                .font(.headline)
                .bold()
                .lineLimit(2)
            SmallDivider()
            Text("作者：\(video.owner.name)")
                .font(.subheadline)
            Text("播放量：\(video.stat.view)")
                .font(.subheadline)
        }
        .padding()
    }
}

struct VideoDetail: View {
    let video: VideoData
    @ObservedObject var consoleManager: ConsoleManager
    @ObservedObject var downloadManager = DownloadManager.shared
    @State private var playerURL: URL?

    var body: some View {
        ZStack {
            let showToast = downloadManager.showToast
            ZStack{
                if showToast {
                    VStack {
                        Spacer()
                        ToastView(message: "已添加到资料库")
                            .padding()
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: showToast)
                    }
                    .padding(.bottom, 20)
                }
            }
            .zIndex(1)
            .padding()
            ZStack{
                VStack{
                    Spacer()
                    DownloadView()
                        .shadow(radius: 10)
                }
                .padding(.bottom, 0)
            }
            .zIndex(1)
            .padding()
            ScrollView {
                ZStack{
                    Text(video.title)
                        .foregroundStyle(Color.blue.opacity(0.2))
                        .font(.system(size: 50))
                        .bold()
                    VStack{
                        VStack(spacing: 16) {
                            NavigationLink(destination: ViewPicture(PicUrl: video.pic.replacingOccurrences(of: "http", with: "https"))) {
                                WebImage(url: URL(string: video.pic.replacingOccurrences(of: "http", with: "https")))
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFit()
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            SmallDivider()
                            Text(video.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            HStack {
                                WebImage(url: URL(string: video.owner.face))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                
                                Text(video.owner.name)
                                    .font(.headline)
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("播放量：\(video.stat.view)")
                                Text("点赞数：\(video.stat.like)")
                                Text("bvid: \(video.bvid)")
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                            
                            if let playerURL = playerURL{
                                NavigationLink(destination: VideoPlayerView(videoURL: playerURL)) {
                                    Text("播放视频")
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 5)
                                        .foregroundColor(.white.opacity(0.5))
                                        .fontWeight(.bold)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.orange)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                detectVideoIDType(video.bvid, videoName: video.title)
                            }) {
                                Text("下载视频")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.blue)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            }
                        }
                    }
                }
            }
        }.onAppear{
            detectOnlineVideoIDType(video.bvid, videoName: video.title){ videoURL in
                if let videoURL = videoURL{
                    print(videoURL)
                    self.playerURL = videoURL
                }
            }
        }
    }
}

struct VideoDetailIndex: View {
    @StateObject var consoleManager = ConsoleManager()
    let video: VideoData
    
    var body: some View {
        TabView {
            VideoDetail(video: video, consoleManager: consoleManager)
            .tabItem {
                Label("首页", systemImage: "message")
            }
            

            ConsoleView(consoleManager: consoleManager)

            .tabItem {
                Label("日志", systemImage: "terminal")
            }
        }
        .onAppear {
            DownloadManager.shared.consoleManager = consoleManager
        }
    }
}

struct ViewPicture: View {
    @Environment(\.dismiss) private var dismiss
    let PicUrl: String
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            WebImage(url: URL(string: PicUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(zoom)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if zoom > 1 {
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .focusable(true)
        .focused($isFocused)
        .onAppear {
            isFocused = true
        }
        .digitalCrownRotation($zoom,
                              from: 1.0,
                              through: 5.0,
                              by: 0.1,
                              sensitivity: .medium,
                              isContinuous: false,
                              isHapticFeedbackEnabled: true)
        
        VStack {
            Button(action: {
                            dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left") // 返回图标
                    Text("返回") // 文字
                }
                .padding()
                .background(Color.blue.opacity(0.6)) // 背景颜色
                .cornerRadius(8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 150,height: 50)
        .navigationBarBackButtonHidden(true)
    }
}


struct ViewQrcode: View {
    @Environment(\.dismiss) private var dismiss
    let PicUrl: UIImage
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero      // 当前位移
    @State private var lastOffset: CGSize = .zero  // 手势结束后的累计位移
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Image(uiImage: PicUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(zoom)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 当图片放大时允许拖动
                            if zoom > 1 {
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                        }
                        .onEnded { _ in
                            // 记录拖动结束后的偏移量
                            lastOffset = offset
                        }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .focusable(true)
        .focused($isFocused)
        .onAppear {
            isFocused = true  // 自动聚焦，确保数字表冠输入能生效
        }
        .digitalCrownRotation($zoom,
                              from: 1.0,
                              through: 5.0,
                              by: 0.1,
                              sensitivity: .medium,
                              isContinuous: false,
                              isHapticFeedbackEnabled: true)
        
        VStack {
            Button(action: {
                            dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left") // 返回图标
                    Text("返回") // 文字
                }
                .padding()
                .background(Color.blue.opacity(0.6)) // 背景颜色
                .cornerRadius(8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 150,height: 50)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - 视频搜索视图
struct VideoSearch: View {
    @ObservedObject var downloadManager = DownloadManager.shared
    @State private var query: String = ""
    @State private var results: [SearchResult] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    TextField("请输入关键词", text: $query)
                        .padding(.horizontal)
                    
                    Button(action: {
                        searchVideos()
                    }) {
                        Text("搜索")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                            )
                    }
                    .disabled(query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                SmallDivider()
                
                if isLoading {
                    ProgressView("加载中...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("错误：\(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if results.isEmpty {
                    Text("未找到相关视频")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // 显示视频结果列表
                        LazyVStack {
                            if downloadManager.isDownloading == true{
                                DownloadView()
                            }
                            ForEach(results) { video in
                                NavigationLink(destination: VideoSearchDetialIndex(video: video)) {
                                SearchResultRow(video: video)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.vertical, 10)
                            .padding(.horizontal,5)
                            .frame(width:150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func searchVideos() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        results = []
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = "https://api.bilibili.com/x/web-interface/wbi/search/all/v2?keyword=\(encodedQuery)"
        guard let url = URL(string: urlStr) else {
            errorMessage = "无效的URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148", forHTTPHeaderField: "User-Agent")
        
        // 如果有已存储的 Cookie，也可以添加到请求中
        if let sessdata = UserDefaults.standard.string(forKey: "SESSDATA"),
           let bili_jct = UserDefaults.standard.string(forKey: "bili_jct"),
           let buvid3 = UserDefaults.standard.string(forKey: "buvid3") {
            let cookieValue = "SESSDATA=\(sessdata); bili_jct=\(bili_jct); buvid3=\(buvid3)"
            request.setValue(cookieValue, forHTTPHeaderField: "Cookie")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "请求失败：\(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "没有收到数据"
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(BilibiliSearchResponse.self, from: data)
                    // 从result数组中找出result_type为"video"的项
                    if let videoResult = decodedResponse.data.result?.first(where: { $0.result_type == "video" }) {
                        self.results = videoResult.data ?? []
                    } else {
                        self.errorMessage = "未找到视频数据"
                    }
                } catch {
                    print("原始数据：\(String(data: data, encoding: .utf8) ?? "无法转码")")
                    self.errorMessage = "数据解析失败：\(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct SearchResultRow: View {
    let video: SearchResult

    var body: some View {
        VStack(alignment: .leading) {
            if let pic = video.pic{
                let faceURL = "https:\(String(describing: video.pic ?? ""))"
                WebImage(url: URL(string: faceURL))
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 3)
                    )
            }
            Text(video.title?.replacingOccurrences(of: "<em class=\"keyword\">", with: "").replacingOccurrences(of: "</em>", with: "") ?? "这个暂时不能被解析")
                .font(.headline)
                .bold()
                .lineLimit(2)
            Text("UP主：\(video.owner.name)")
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
}

struct SearchResultDetail: View {
    let video: SearchResult
    @ObservedObject var consoleManager: ConsoleManager
    @ObservedObject var downloadManager = DownloadManager.shared
    @State private var playerURL: URL?
    
    var body: some View {
            ZStack{
                let showToast = downloadManager.showToast
                ZStack{
                    if showToast {
                        VStack {
                            Spacer()
                            ToastView(message: "已添加到资料库")
                                .padding()
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: showToast)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .zIndex(1)
                .padding()
                ZStack{
                    VStack{
                        Spacer()
                        DownloadView()
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 0)
                }
                .zIndex(1)
                .padding()
                
                ScrollView {
                VStack(spacing: 16) {
                    let faceURL = "https:\(String(describing: video.pic ?? ""))"
                    NavigationLink(destination: ViewPicture(PicUrl: faceURL )) {
                        WebImage(url: URL(string: faceURL))
                            .resizable()
                            .indicator(.activity)
                            .scaledToFit()
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 3)
                            )
                    }.buttonStyle(PlainButtonStyle())
                    Text(video.title?.replacingOccurrences(of: "<em class=\"keyword\">", with: "").replacingOccurrences(of: "</em>", with: "") ?? "")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    VStack {
                        Text("作者:\(video.owner.name)")
                            .font(.headline)
                            .padding(.leading, 8)
                        Spacer()
                        
                        if let playerURL = playerURL{
                            NavigationLink(destination: VideoPlayerView(videoURL: playerURL)) {
                                Text("播放视频")
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white.opacity(0.5))
                                    .fontWeight(.bold)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.orange)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Button(action: {
                            detectVideoIDType(video.bvid ?? "666666",videoName: video.title?.replacingOccurrences(of: "<em class=\"keyword\">", with: "").replacingOccurrences(of: "</em>", with: "") ?? "")
                        }) {
                            Text("下载视频")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 5)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(DownloadManager().isDownloading)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("视频详情")
            }.onAppear{
                if let name = video.title{
                    if let bvid = video.bvid{
                        detectOnlineVideoIDType(bvid, videoName: name){ videoURL in
                            if let videoURL = videoURL{
                                print(videoURL)
                                self.playerURL = videoURL
                            }
                        }
                    }
            }
        }
    }
}

struct VideoSearchDetialIndex: View {
    @StateObject var consoleManager = ConsoleManager()  // 共享日志管理器
    let video: SearchResult
    
    var body: some View {
        TabView {
            SearchResultDetail(video: video, consoleManager: consoleManager)
            .tabItem {
                Label("首页", systemImage: "message")
            }
            ConsoleView(consoleManager: consoleManager)
            .tabItem {
                Label("日志", systemImage: "terminal")
            }
        }.onAppear {
            // 将共享的 consoleManager 传入 DownloadManager
            DownloadManager.shared.consoleManager = consoleManager
        }
    }
}

// MARK: - 登录模块
struct BiliLoginView: View {
    @StateObject private var loginManager = BiliLoginManager()
    @State private var existingLogin: Bool = false
    @State private var storedCookies: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if existingLogin {
                    Text("已登录")
                        .font(.title)
                        .foregroundColor(.green)

                    Text("当前 Cookie:")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    Text(storedCookies)
                        .font(.footnote)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    Button("退出登录") {
                        logout()
                    }
                    .padding(.horizontal,40)
                    .padding(.vertical,8)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.white.opacity(0.3))
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())

                } else {
                    if loginManager.isLoggedIn {
                        Text("登录成功!")
                            .font(.title)
                            .foregroundColor(.green)
                    } else {
                        VStack {
                            if let qrImage = generateQRCode(from: loginManager.qrCodeURL) {
                                NavigationLink(destination: ViewQrcode(PicUrl: qrImage)){
                                    Image(uiImage: qrImage)
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                }.buttonStyle(PlainButtonStyle())
                            } else {
                                Text("生成二维码失败")
                                    .foregroundColor(.red)
                            }
                            
                            Button("刷新二维码") {
                                loginManager.fetchQRCode()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            checkExistingLogin()
        }
        .onDisappear {
            loginManager.stopPolling()
        }
    }

    private func checkExistingLogin() {
        if let sessdata = UserDefaults.standard.string(forKey: "SESSDATA"),
           let bili_jct = UserDefaults.standard.string(forKey: "bili_jct"),
           let dedeUserID = UserDefaults.standard.string(forKey: "DedeUserID"),
           let dedeUserID_ckMd5 = UserDefaults.standard.string(forKey: "DedeUserID__ckMd5") {
            
            storedCookies = "DedeUserID=\(dedeUserID)\nDedeUserID__ckMd5=\(dedeUserID_ckMd5)\nSESSDATA=\(sessdata)\nbili_jct=\(bili_jct)"
            existingLogin = true

            validateCookie { isValid in
                DispatchQueue.main.async {
                    if !isValid {
                        print("Cookie 已失效，重新登录")
                        logout()
                    }
                }
            }
        } else {
            loginManager.fetchQRCode()
        }
    }

    private func validateCookie(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.bilibili.com/x/web-interface/nav") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148", forHTTPHeaderField: "User-Agent")

        if let sessdata = UserDefaults.standard.string(forKey: "SESSDATA") {
            let cookieValue = "SESSDATA=\(sessdata)"
            request.setValue(cookieValue, forHTTPHeaderField: "Cookie")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let dataDict = json["data"] as? [String: Any],
               let isLogin = dataDict["isLogin"] as? Bool {
                completion(isLogin)
            } else {
                completion(false)
            }
        }.resume()
    }

    private func logout() {
        UserDefaults.standard.removeObject(forKey: "SESSDATA")
        UserDefaults.standard.removeObject(forKey: "bili_jct")
        UserDefaults.standard.removeObject(forKey: "DedeUserID")
        UserDefaults.standard.removeObject(forKey: "DedeUserID__ckMd5")
        UserDefaults.standard.synchronize()
        existingLogin = false
        loginManager.fetchQRCode()
    }

    private func generateQRCode(from string: String) -> UIImage? {
        guard !string.isEmpty, let cgImage = EFQRCode.generate(for: string) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
// MARK: - 登录类
class BiliLoginManager: ObservableObject {
    @Published var qrCodeURL: String = ""
    @Published var isLoggedIn: Bool = false
    private var qrcodeKey: String = ""
    private var timer: Timer?
    
    func fetchQRCode() {
        self.stopPolling()
        
        guard let url = URL(string: "https://passport.bilibili.com/x/passport-login/web/qrcode/generate?source=main_web") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
                         forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("请求错误: \(error.localizedDescription)")
                WKInterfaceDevice.current().play(.failure)
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let key = dataDict["qrcode_key"] as? String,
                  let url = dataDict["url"] as? String else {
                print("数据解析失败")
                WKInterfaceDevice.current().play(.failure)
                return
            }
            
            DispatchQueue.main.async {
                self.qrcodeKey = key
                self.qrCodeURL = url
                self.startPolling()
            }
        }.resume()
    }
    
    func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self?.checkLoginStatus()
        }
    }
    
    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkLoginStatus() {
        guard !qrcodeKey.isEmpty,
              let url = URL(string: "https://passport.bilibili.com/x/passport-login/web/qrcode/poll?qrcode_key=\(qrcodeKey)&source=main_web") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
                         forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("状态检查错误: \(error.localizedDescription)")
                WKInterfaceDevice.current().play(.failure)
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let code = dataDict["code"] as? Int else {
                print("状态数据解析失败")
                WKInterfaceDevice.current().play(.failure)
                return
            }
            
            DispatchQueue.main.async {
                switch code {
                case 0:
                    if let httpResponse = response as? HTTPURLResponse,
                       let headerFields = httpResponse.allHeaderFields as? [String: String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                        print("解析到的 Cookie 数量：\(cookies.count)")
                        for cookie in cookies {
                            if cookie.name == "SESSDATA" ||
                                cookie.name == "bili_jct" ||
                                cookie.name == "DedeUserID" ||
                                cookie.name == "DedeUserID__ckMd5" {
                                UserDefaults.standard.setValue(cookie.value, forKey: cookie.name)
                                print("保存 Cookie: \(cookie.name)=\(cookie.value)")
                            }
                        }
                    }
                        
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                            // 通知主界面检查 Cookie 登录状态
                            // 此处可以调用 BiliLoginView 内部的 checkExistingLogin() 或其它通知方式
                            
                    }
                    self.isLoggedIn = true
                    WKInterfaceDevice.current().play(.success)
                    self.stopPolling()
                    print("已登录，返回数据:\(json)")
                    case 86038:
                        print("二维码已过期")
                        self.fetchQRCode()
                    case 86090:
                        print("已扫描，请确认")
                    default:
                        print("未知状态码: \(code)")
                }
            }
        }.resume()
    }
}

// MARK: - 解析视频 ID 并获取播放地址
func detectVideoIDType(_ id: String,videoName: String) {
    let trimmedID = id.lowercased().replacingOccurrences(of: "av", with: "")
    
    if id.hasPrefix("BV") && id.count == 12 {
        fetchVideoURL(id: id, isBvid: true) { videoURL in
            if let videoURL = videoURL {
                print("视频播放地址: \(videoURL)")
                DispatchQueue.main.async {
                    DownloadManager.shared.startDownload(videoURL: videoURL,videoName: videoName.replacingOccurrences(of: "/", with: " "))  // 开始下载
                }
            } else {
                print("无法获取播放地址")
            }
        }
    } else if Int(trimmedID) != nil {
        fetchVideoURL(id: id, isBvid: false) { videoURL in
            if let videoURL = videoURL {
                print("视频播放地址: \(videoURL)")
                DispatchQueue.main.async {
                    DownloadManager.shared.startDownload(videoURL: videoURL,videoName: videoName)  // 开始下载
                }
            } else {
                print("无法获取播放地址")
            }
        }
    } else {
        print("faild") // 不是有效的 B 站视频 ID
    }
}

func detectOnlineVideoIDType(_ id: String,videoName: String, completion: @escaping (URL?) -> Void) {
    let trimmedID = id.lowercased().replacingOccurrences(of: "av", with: "")
    
    if id.hasPrefix("BV") && id.count == 12 {
        fetchVideoURL(id: id, isBvid: true) { videoURL in
            if let videoURL = videoURL {
                completion(videoURL)
                return
            } else {
                completion(nil)
                print("无法获取播放地址")
            }
        }
    } else if Int(trimmedID) != nil {
        fetchVideoURL(id: id, isBvid: false) { videoURL in
            if let videoURL = videoURL {
                completion(videoURL)
                return
            } else {
                completion(nil)
                print("无法获取播放地址")
            }
        }
    } else {
        print("faild") // 不是有效的 B 站视频 ID
    }
}

// MARK: - 获取视频 CID
func fetchVideoCid(id: String, isBvid: Bool, completion: @escaping (Int64?) -> Void) {
    let baseUrl = "https://api.bilibili.com/x/web-interface/view"
    let param = isBvid ? "bvid" : "aid"
    guard let url = URL(string: "\(baseUrl)?\(param)=\(id)") else {
        print("构造获取 cid 的 URL 失败")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data, error == nil else {
            print("请求 cid 时出错")
            completion(nil)
            return
        }

        do {
            let response = try JSONDecoder().decode(VideoInfoResponse.self, from: data)
            completion(response.data.pages.first?.cid)
        } catch {
            print("解析 cid 失败: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}

func fetchVideoURL(id: String, isBvid: Bool, completion: @escaping (URL?) -> Void) {
    fetchVideoCid(id: id, isBvid: isBvid) { cid in
        guard let cid = cid else {
            completion(nil)
            return
        }

        let apiURL = "https://api.bilibili.com/x/player/wbi/playurl"
        var components = URLComponents(string: apiURL)!
        let queryItemID = isBvid ? URLQueryItem(name: "bvid", value: id) : URLQueryItem(name: "avid", value: id)

        components.queryItems = [
            queryItemID,
            URLQueryItem(name: "cid", value: "\(cid)"),
            URLQueryItem(name: "qn", value: "74"),
            URLQueryItem(name: "fnval", value: "1")
        ]

        guard let url = components.url else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(VideoPlayResponse.self, from: data)
                if let durl = response.data.durl?.first?.url, let videoURL = URL(string: durl) {
                    completion(videoURL)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

// MARK: - 下载管理器
class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    static let shared = DownloadManager()
    @Published var showToast = false
    var consoleManager: ConsoleManager?
    @Published var downloadProgress: Float = 0.0
    private var downloadTask: URLSessionDownloadTask?
    private var session: URLSession!
    var isDownloading: Bool = false
    var videoName: String = "Video"
    var message: String = ""

    override init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }

    func startDownload(videoURL: URL,videoName: String) {
        print("开始下载: \(videoURL)")
        self.message = "开始下载: \(videoURL)"
        self.consoleManager?.addLog("开始下载: \(videoURL)")
        self.isDownloading = true
        self.videoName = videoName

        // 如果有正在进行的下载，先取消
        downloadTask?.cancel()
        
        var request = URLRequest(url: videoURL)
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X)", forHTTPHeaderField: "User-Agent")
        request.addValue("https://www.bilibili.com/", forHTTPHeaderField: "Referer")
        
        downloadTask = session.downloadTask(with: request)
        downloadTask?.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.isDownloading = true
            self.downloadProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            print("下载进度: \(Int(self.downloadProgress * 100))%")
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent("\(videoName).mp4")

        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }

            try fileManager.moveItem(at: location, to: destinationURL)
            print("视频已保存: \(destinationURL)")
            self.consoleManager?.addLog("视频已保存: \(destinationURL)")
            message = "视频已保存:\(videoName).mp4"
            WKInterfaceDevice.current().play(.success)

            DispatchQueue.main.async {
                self.downloadProgress = 0.0  // 重置进度
                self.isDownloading = false
                
                withAnimation {
                    self.showToast = true
                }
                // 延时后自动隐藏 Toast
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.showToast = false
                    }
                }
                // 通知 InterfaceController 更新视频 URL
                //if let interfaceController = WKInterfaceController.current() as? InterfaceController {
                    //interfaceController.updateVideoURL(url: destinationURL)
                //}
            }
        } catch {
            print("文件移动失败: \(error.localizedDescription)")
            message = "文件移动失败: \(error.localizedDescription)"
            self.consoleManager?.addLog("文件移动失败: \(error.localizedDescription)")
            WKInterfaceDevice.current().play(.failure)
            self.isDownloading = false
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFailWithError error: Error) {
        print("下载失败: \(error.localizedDescription)")
        message = "下载失败: \(error.localizedDescription)"
        self.consoleManager?.addLog("下载失败: \(error.localizedDescription)")
        WKInterfaceDevice.current().play(.failure)
        DispatchQueue.main.async {
            self.downloadProgress = 0.0  // 下载失败时重置进度
            self.isDownloading = false
        }
    }
}
// MARK: - 下载 UI
struct DownloadView: View {
    @StateObject private var downloadManager = DownloadManager.shared
    @State private var downloadedFileURL: URL?

    var body: some View {
        VStack {
            if downloadManager.isDownloading == true {
                VStack{
                    Text("下载视频：\(downloadManager.videoName)")
                        .fontWeight(.bold)
                    ProgressView(value: downloadManager.downloadProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 150)
                    Text("下载进度: \(Int(downloadManager.downloadProgress * 100))%")
                        .fontWeight(.bold)
                }
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
            }
            
        }
        .padding()
    }
}

// MARK: - 本地文件
struct VideoListView: View {
    @State private var videos: [URL] = []

    var body: some View {
        List {
            ForEach(videos, id: \.self) { video in
                NavigationLink(destination: VideoPlayerView(videoURL: video)) {
                    Text(video.lastPathComponent)
                        .fontWeight(.bold)
                }
            }
            .onDelete(perform: deleteVideo)
        }
        .onAppear(perform: loadVideos)
    }

    /// 加载 `Documents` 目录中的视频文件
    func loadVideos() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileList = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let videoFiles = fileList.filter { $0.pathExtension.lowercased() == "mp4" }
            DispatchQueue.main.async {
                self.videos = videoFiles
            }
        } catch {
            print("Error reading videos: \(error)")
        }
    }

    /// 删除选中的视频
    func deleteVideo(at offsets: IndexSet) {
        let fileManager = FileManager.default

        for index in offsets {
            let videoURL = videos[index]

            do {
                try fileManager.removeItem(at: videoURL) // 删除文件
                videos.remove(at: index) // 更新列表
            } catch {
                print("Failed to delete video: \(error)")
            }
        }
    }
}

struct VideoPlayerView: View {
    let videoURL: URL
    @State private var isLandscape = false      // 控制视频是否旋转（横屏效果）
    @State private var showOptions = false        // 控制是否显示选项界面
    @State private var player = AVPlayer()        // 播放器实例
    @Environment(\.presentationMode) var presentationMode  // 用于退出页面
    let headers = [
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X)",
            "Referer": "https://www.bilibili.com/"
        ]

    var body: some View {
        ZStack {
            let asset = AVURLAsset(url: videoURL, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let playerItem = AVPlayerItem(asset: asset)
            // 视频播放器视图（旋转后会影响局部坐标系）
            VideoPlayer(player: player)
                .rotationEffect(isLandscape ? .degrees(90) : .degrees(0))
                .animation(.easeInOut, value: isLandscape)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player = AVPlayer(url: videoURL)
                    player.replaceCurrentItem(with: playerItem)
                    player.play()
                }
                // 手势直接绑定在 VideoPlayer 上，方向判断根据当前旋转状态不同
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if isLandscape {
                                // 视频旋转 90° 时，相对于视频的右方向对应全局向下滑动
                                if value.translation.height > 50 {
                                    withAnimation { showOptions = true }
                                } else if value.translation.height < -50 {
                                    withAnimation { showOptions = false }
                                }
                            } else {
                                // 未旋转时：右滑（translation.width > 50）显示菜单
                                if value.translation.width > 50 {
                                    withAnimation { showOptions = true }
                                } else if value.translation.width < -50 {
                                    withAnimation { showOptions = false }
                                }
                            }
                        }
                )
            
            // 右侧（或横屏时的底部）选项菜单
            if showOptions {
                // 使用 Group 包裹菜单视图，方便后续统一应用旋转
                Group {
                    HStack(spacing: 12) {
                        // 旋转按钮：点击后切换横屏/竖屏状态
                        Button(action: {
                            withAnimation {
                                isLandscape.toggle()
                                showOptions = false
                            }
                        }) {
                            Label("旋转", systemImage: "rotate.right")
                        }
                        // 返回按钮：点击后退出播放器界面
                        Button(action: {
                            withAnimation { showOptions = false }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Label("返回", systemImage: "chevron.left")
                        }
                    }
                    .padding(10)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                // 根据是否横屏调整菜单的位置
                .padding(isLandscape ? .bottom : .trailing, 10)
                .padding(isLandscape ? .leading : .top, 50)
                // 当横屏时，菜单从底部滑入；否则从右侧滑入
                .transition(.move(edge: isLandscape ? .bottom : .trailing))
                // **关键**：当横屏时，将菜单也旋转 90°，使按钮方向与视频保持一致
                .rotationEffect(isLandscape ? .degrees(90) : .degrees(0))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: -星火ai
// 数据模型
struct Message: Identifiable, Codable {
    var id = UUID()
    let role: String  // "system"、"user" 或 "assistant"
    let content: String
}

struct ChatHistory: Identifiable, Codable {
    var id = UUID()
    let name: String      // 格式为 日期 - 第一条用户提问
    let date: Date
    let messages: [Message]
}

// 聊天界面
struct ChatInterfaceView: View {
    @StateObject var consoleManager = ConsoleManager()  // 共享日志管理器
    @Binding var chatHistories: [ChatHistory]
    
    @AppStorage("max_token") private var maxToken: Int = 8192
    @AppStorage("temperature") private var temperature: Double = 0.4
    @AppStorage("tok_k") private var tokK: Int = 6
    @AppStorage("system_prompt") private var systemPrompt: String = "你是约会大作战里主角的妹妹五河琴里，请依照角色语气的风格解释我的问题，首要解决问题，可以有小脾气，可以撒娇，尽量多说点话，更加贴合原著"
    
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 4) {
            // 聊天记录列表
            HStack{
                List(messages) { message in
                    HStack {
                        if message.role == "system" || message.role == "assistant" {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message.role == "system" ? "设定" : "AI")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(message.role == "system" ? .pink : .green)
                                // 使用 MarkdownUI 渲染 Markdown 文本
                                Markdown(message.content)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else if message.role == "sys" {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("system")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text(message.content)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("我")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text(message.content)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .padding()
            }
            .listStyle(PlainListStyle())
            .frame(height: 140)
            
            // 输入区域（Apple Watch 上建议使用语音或 Scribble 输入）
            HStack {
                TextField("输入消息", text: $inputText)
                    .font(.footnote)
                Button(action: {
                    addMessage()
                }) {
                    Text("发送")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                // 保存聊天历史记录按钮
                Button(action: {
                    saveChatHistory()
                }) {
                    Text("保存")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(4)
            }
            .padding()
            .frame(height: 30.0)
            .buttonStyle(PlainButtonStyle())
        }
        .onAppear {
            if messages.isEmpty {
                            messages.append(Message(role: "system", content: systemPrompt))
            }
            loadChatHistories() // 加载聊天记录
        }
    }
    
    // 添加新消息，并调用讯飞星火 API 获取回复
    func addMessage() {
        guard !inputText.isEmpty else { return }
        let newMessage = Message(role: "user", content: inputText)
        messages.append(newMessage)
        inputText = ""
        callSparkAPI()
    }
    
    // 调用讯飞星火 API，将当前对话上下文传入，获取 AI 回复
    func callSparkAPI() {
        guard let url = URL(string: "https://spark-api-open.xf-yun.com/v1/chat/completions") else {
            print("无效的URL")
            return
        }
        
        // 构造消息数组
        let messagesArray = messages.map { ["role": $0.role, "content": $0.content] }
        print("发送的 messagesArray: \(messagesArray)")
        
        let requestBody: [String: Any] = [
                    "max_token": maxToken,
                    "tok_k": tokK,
                    "temperature": temperature,
                    "model": "4.0Ultra",
                    "show_ref_label": true,
                    "messages": messagesArray
        ]
        consoleManager.addLog("发送的 requestBody: \(requestBody)")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            print("JSON序列化失败")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer jJDdIZANtyPrqvMEYJql:rmXqzilYQeauESXNAUEw", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("网络请求错误：\(error)")
                messages.append(Message(role:"sys",content: "网络请求错误：\(error)"))
                consoleManager.addLog("网络请求错误：\(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP 状态码：\(httpResponse.statusCode)")
                consoleManager.addLog("HTTP 状态码：\(httpResponse.statusCode)")
                print("响应头：\(httpResponse.allHeaderFields)")
                if httpResponse.statusCode != 200 {
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("错误详情：\(errorMessage)")
                        messages.append(Message(role:"sys",content: "错误详情：\(errorMessage)"))
                        consoleManager.addLog("错误详情：\(errorMessage)")
                    }
                    return
                }
            }
            guard let data = data else {
                print("没有收到数据")
                messages.append(Message(role:"sys",content: "没有收到数据"))
                consoleManager.addLog("没有收到数据")
                return
            }
            
            let rawJSON = String(data: data, encoding: .utf8) ?? "无法转换为字符串"
            print("原始JSON数据: \(rawJSON)")
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("解析后的 JSON: \(json)")
                    consoleManager.addLog("解析后的 JSON: \(json)")
                    if let choices = json["choices"] as? [[String: Any]],
                       let usage = json["usage"] as? [String:Any],
                       let tokens = usage["total_tokens"] as? Int,
                       let firstChoice = choices.first,
                       let messageDict = firstChoice["message"] as? [String: Any],
                       let aiContent = messageDict["content"] as? String
                    {
                        DispatchQueue.main.async {
                            let aiMessage = Message(role: "assistant", content: aiContent)
                            self.messages.append(Message(role: "sys", content: "tokens:\(tokens)"))
                            print("\(aiContent)(tokens:\(tokens))")
                            self.messages.append(aiMessage)
                        }
                    } else {
                        print("JSON结构异常，无法提取内容")
                    }
                } else {
                    print("返回数据无法解析为字典")
                }
            } catch {
                print("JSON解析错误：\(error)")
            }
        }.resume()
    }
    
    // 保存聊天历史记录：使用当前日期和第一条用户提问作为名称
    func saveChatHistory() {
        let now = Date()
        let dateStr = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .short)
        let firstQuestion = messages.first(where: { $0.role == "user" })?.content ?? "未输入问题"
        let historyName = "\(dateStr) - \(firstQuestion)"
        let history = ChatHistory(name: historyName, date: now, messages: messages)
        chatHistories.append(history)
        saveToUserDefaults()
        print("已保存历史记录: \(historyName)")
        messages.append(Message(role:"sys",content: "保存成功"))
    }
    
    // 保存聊天记录到 UserDefaults
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(chatHistories) {
            UserDefaults.standard.set(data, forKey: "chatHistories")
        }
    }
    
    // 加载聊天记录
    func loadChatHistories() {
        if let data = UserDefaults.standard.data(forKey: "chatHistories"),
           let decodedHistories = try? JSONDecoder().decode([ChatHistory].self, from: data) { 
            chatHistories = decodedHistories
        }
    }
}

// 历史记录列表和详情

// 历史记录列表视图
struct ChatHistoryListView: View {
    @Binding var chatHistories: [ChatHistory]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(chatHistories) { history in
                NavigationLink(destination: ChatHistoryDetailView(history: history)) {
                    VStack(alignment: .leading) {
                        Text(history.name)
                            .font(.headline)
                        Text("共 \(history.messages.count) 条消息")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(4)
                }
            }
            .onDelete(perform: deleteHistory)
        }
        .navigationTitle("记忆")
    }
    
    // 删除历史记录
    func deleteHistory(at offsets: IndexSet) {
        chatHistories.remove(atOffsets: offsets)
        saveToUserDefaults()
    }

    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(chatHistories) {
            UserDefaults.standard.set(data, forKey: "chatHistories")
        }
    }
}

// 历史记录详情视图，展示保存的聊天对话
struct ChatHistoryDetailView: View {
    let history: ChatHistory
    
    var body: some View {
        List(history.messages) { message in
            HStack {
                if message.role == "system" || message.role == "assistant" {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.role == "system" ? "设定" : "琴里")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(message.role == "system" ? .pink : .green)
                        // 使用 MarkdownUI 渲染 Markdown 文本
                        Markdown(message.content) // 可根据需要自定义样式
                            .font(.footnote)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else if message.role == "sys" {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("system")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(message.content)
                            .font(.footnote)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("我")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text(message.content)
                            .font(.footnote)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(4)
        }
    }
}

struct SettingsView: View {
    @AppStorage("max_token") private var maxToken: Int = 8192
    @AppStorage("temperature") private var temperature: Double = 0.4
    @AppStorage("tok_k") private var tokK: Int = 6
    @AppStorage("system_prompt") private var systemPrompt: String = "你是约会大作战里主角的妹妹五河琴里，请依照角色语气的风格解释我的问题，首要解决问题，可以有小脾气，可以撒娇，尽量多说点话，更加贴合原著"
    
    var body: some View {
        Form {
            Section(header: Text("API 参数")) {
                Stepper(value: $maxToken, in: 1000...8192, step: 512) {
                    Text("max_token: \(maxToken)")
                        .font(.footnote)
                }
                
                Stepper(value: $tokK, in: 1...6){
                    Text("tok_k: \(tokK)")
                        .font(.footnote)
                }
                
                Stepper(value: $temperature, in: 0...1,step: 0.1){
                    Text("temperature: \(temperature, specifier: "%.1f")")
                        .font(.footnote)
                }
            }
            
            Section(header: Text("提示词")) {
                // watchOS 不支持 TextEditor，改为使用 NavigationLink 进入编辑页面
                NavigationLink(destination: EditPromptView(prompt: $systemPrompt)) {
                    VStack(alignment: .leading) {
                        Text("编辑提示词")
                        Text(systemPrompt)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                Button("重置提示词") {
                    resetPrompt()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("设置")
    }
    
    private func resetPrompt() {
        systemPrompt = "你是约会大作战里主角的妹妹五河琴里，请依照角色语气的风格解释我的问题，首要解决问题，可以有小脾气，可以撒娇，尽量多说点话，更加贴合原著"
    }
}

// 编辑提示词页面
struct EditPromptView: View {
    @Binding var prompt: String
    
    var body: some View {
        VStack {
            TextField("提示词", text: $prompt)
                .font(.footnote)
                .padding()
            Spacer()
            ScrollView{
                Section(header: Text("提示词")){
                    Text(prompt)
                        .font(.footnote)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("编辑提示词")
    }
}

// 主视
struct Ai: View {
    @StateObject var consoleManager = ConsoleManager()  // 共享日志管理器
    @State private var chatHistories: [ChatHistory] = []
    
    var body: some View {
        TabView {
                // 传入 consoleManager，让聊天界面也能记录日志
            ChatInterfaceView(consoleManager: consoleManager, chatHistories: $chatHistories)
            .tabItem {
                Label("聊天", systemImage: "message")
            }
            
            NavigationView {
                ChatHistoryListView(chatHistories: $chatHistories)
            }.toolbar(.hidden, for: .navigationBar)
            .tabItem {
                Label("历史", systemImage: "clock")
            }
            
            NavigationView {
                ConsoleView(consoleManager: consoleManager)
            }.toolbar(.hidden, for: .navigationBar)
            .tabItem {
                Label("日志", systemImage: "terminal")
            }
            
            NavigationView {
                SettingsView()
            }.toolbar(.hidden, for: .navigationBar)
            .tabItem {
                Label("设置", systemImage: "gear")
            }
        }
    }
}

// MARK: - 日志
class ConsoleManager: ObservableObject {
    @Published var logs: [String] = []
    
    func addLog(_ log: String) {
        // 将日志信息附上时间戳，并确保在主线程更新
        DispatchQueue.main.async {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let timeStamp = formatter.string(from: Date())
            self.logs.append("[\(timeStamp)] \(log)")
        }
    }
}
struct ConsoleView: View {
    @ObservedObject var consoleManager: ConsoleManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("控制台日志")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
                .padding()
            
            ScrollView {
                ForEach(consoleManager.logs, id: \.self) { log in
                    Text(log)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(2)
                }
            }
            .padding()
            .frame(height: 150)
        }
    }
}

// MARK: - 预览
#Preview {
    ContentView()
}
