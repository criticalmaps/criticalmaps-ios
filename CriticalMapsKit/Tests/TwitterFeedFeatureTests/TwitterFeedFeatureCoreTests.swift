import ApiClient
import ComposableArchitecture
import CustomDump
import Combine
import SharedModels
import TwitterFeedFeature
import XCTest

class TwitterFeedCoreTests: XCTestCase {
  func test_onAppear_shouldFetchTwitterData() throws {
    let twitterFeedSubject = PassthroughSubject<[Tweet], NSError>()
    
    let request = TwitterFeedRequest()
    let decoder = request.decoder
    let tweetData = try XCTUnwrap(twitterFeedData)
    let feed = try decoder.decode(TwitterFeed.self, from: tweetData)
    
    var service = TwitterFeedService.noop
    service.getTwitterFeed = {
      twitterFeedSubject.eraseToAnyPublisher()
    }
    
    let store = TestStore(
      initialState: TwitterFeedState(),
      reducer: twitterFeedReducer,
      environment: TwitterFeedEnvironment(
        service: service,
        mainQueue: .immediate
      )
    )
    
    store.assert(
      .send(.onAppear),
      .receive(.fetchData) {
        $0.twitterFeedIsLoading = true
      },
      .do {
        twitterFeedSubject.send(feed.statuses)
      },
      .receive(.fetchDataResponse(.success(feed.statuses))) {
        $0.twitterFeedIsLoading = false
        $0.tweets = feed.statuses
      },
      .do { twitterFeedSubject.send(completion: .finished) }
    ) 
  }
  
  func test_tweetDecodingTest() throws {
    let request = TwitterFeedRequest()
    let decoder = request.decoder
    
    let tweetData = try XCTUnwrap(twitterFeedData)
    let feed = try decoder.decode(TwitterFeed.self, from: tweetData)
        
    XCTAssertNoDifference(
      feed,
      TwitterFeed(statuses: [
        Tweet(
          id: 1449032124787462100,
          text: "RT @cm_Mainz: Es wird heute einen Zubringen von Mainz zur @cm_WI geben.\n\nFalls jemand noch spontan dazustoßen möchte:\n\nTreffpunkt pünktlich…",
          createdAt: Date(timeIntervalSinceReferenceDate: 656003954.0),
          user: .init(
            name: "Lamima",
            screenName: "LamimaGC",
            profileImageUrlHttps: "https://pbs.twimg.com/profile_images/1087374277396054017/7_wQMi8R_normal.jpg"
          )
        )
      ])
    )
  }
}


let twitterFeedData = #"""
{
  "statuses": [
    {
      "created_at": "Fri Oct 15 15:19:14 +0000 2021",
      "id": 1449032124787462100,
      "text": "RT @cm_Mainz: Es wird heute einen Zubringen von Mainz zur @cm_WI geben.\n\nFalls jemand noch spontan dazustoßen möchte:\n\nTreffpunkt pünktlich…",
      "user": {
        "id": 214547004,
        "id_str": "214547004",
        "name": "Lamima",
        "screen_name": "LamimaGC",
        "location": "Mainz",
        "description": "Mainz, Bike-content auf und abseits der Straße, Fotographie und Geocaching",
        "url": null,
        "entities": {
          "description": {
            "urls": []
          }
        },
        "protected": false,
        "followers_count": 578,
        "friends_count": 272,
        "listed_count": 11,
        "created_at": "Thu Nov 11 17:19:11 +0000 2010",
        "favourites_count": 12665,
        "utc_offset": null,
        "time_zone": null,
        "geo_enabled": true,
        "verified": false,
        "statuses_count": 6057,
        "lang": null,
        "contributors_enabled": false,
        "is_translator": false,
        "is_translation_enabled": false,
        "profile_background_color": "C0DEED",
        "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
        "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
        "profile_background_tile": false,
        "profile_image_url": "http://pbs.twimg.com/profile_images/1087374277396054017/7_wQMi8R_normal.jpg",
        "profile_image_url_https": "https://pbs.twimg.com/profile_images/1087374277396054017/7_wQMi8R_normal.jpg",
        "profile_banner_url": "https://pbs.twimg.com/profile_banners/214547004/1576167220",
        "profile_link_color": "1DA1F2",
        "profile_sidebar_border_color": "C0DEED",
        "profile_sidebar_fill_color": "DDEEF6",
        "profile_text_color": "333333",
        "profile_use_background_image": true,
        "has_extended_profile": false,
        "default_profile": true,
        "default_profile_image": false,
        "following": false,
        "follow_request_sent": false,
        "notifications": false,
        "translator_type": "none",
        "withheld_in_countries": []
      }
    }
  ]
}
"""#.data(using: .utf8)
