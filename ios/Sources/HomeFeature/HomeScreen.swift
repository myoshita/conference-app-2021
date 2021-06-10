import Component
import ComposableArchitecture
import Styleguide
import SwiftUI

public struct HomeScreen: View {
    private let store: Store<HomeState, HomeAction>

    public init(store: Store<HomeState, HomeAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            InlineTitleNavigationBarScrollView {
                ZStack(alignment: .top) {
                    AssetColor.primary.color
                        .frame(width: nil, height: 200)
                        .clipShape(CutCornerRectangle(targetCorners: [.topLeft], radius: 42))
                    WithViewStore(store) { viewStore in
                        VStack(alignment: .trailing, spacing: 16) {
                            MessageBar(title: viewStore.message)
                                .padding(.top, 16)
                            if let topic = viewStore.topic {
                                LargeCard(
                                    title: topic.title,
                                    imageURL: URL(string: topic.imageURLString),
                                    tag: topic.media,
                                    date: topic.publishedAt,
                                    isFavorited: false,
                                    tapAction: {},
                                    tapFavoriteAction: {}
                                )
                            }
                            Divider()
                                .foregroundColor(AssetColor.Separate.contents.color)
                            QuestionnaireView(tapAnswerAction: {
                                viewStore.send(.answerQuestionnaire)
                            })
                            Divider()
                                .foregroundColor(AssetColor.Separate.contents.color)
                            ForEach(viewStore.listFeedItems) { feedItem in
                                ListItem(
                                    title: feedItem.title,
                                    tag: feedItem.media,
                                    imageURL: URL(string: feedItem.imageURLString),
                                    users: [],
                                    date: feedItem.publishedAt,
                                    isFavorited: true,
                                    tapFavoriteAction: {},
                                    tapAction: {}
                                )
                                .padding(.bottom, 16)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(AssetColor.Background.primary.color.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AssetImage.logoTitle.image
                }
            }
            .navigationBarItems(
                trailing: AssetImage.iconSetting.image
                    .renderingMode(.template)
                    .foregroundColor(AssetColor.Base.primary.color)
            )
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen(
                store: .init(
                    initialState: .init(
                        feedItems: [.mock(), .mock()],
                        message: "DroidKaigi 2021 (7/31) D-7"
                    ),
                    reducer: homeReducer,
                    environment: .init()
                )
            )
            .previewDevice(.init(rawValue: "iPhone 12"))
            .environment(\.colorScheme, .dark)
            HomeScreen(
                store: .init(
                    initialState: .init(
                        feedItems: [.mock(), .mock()],
                        message: "DroidKaigi 2021 (7/31) D-7"
                    ),
                    reducer: homeReducer,
                    environment: .init()
                )
            )
            .previewDevice(.init(rawValue: "iPhone 12"))
            .environment(\.colorScheme, .light)
        }
    }
}

extension FeedItem {
    static func mock(
        id: String = UUID().uuidString,
        imageURLString: String = "",
        link: String = "",
        media: TagType = .medium,
        publishedAt: Date = Date(),
        summary: String = "",
        title: String = "DroidKaigi 2021とその他活動予定についてのお知らせ"
    ) -> FeedItem {
        .init(id: id, imageURLString: imageURLString, link: link, media: media, publishedAt: publishedAt, summary: summary, title: title)
    }
}
