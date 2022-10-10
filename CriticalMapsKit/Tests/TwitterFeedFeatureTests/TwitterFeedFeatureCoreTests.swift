import ApiClient
import Combine
import ComposableArchitecture
import CustomDump
import SharedDependencies
import SharedModels
import TwitterFeedFeature
import UIApplicationClient
import XCTest

@MainActor
final class TwitterFeedCoreTests: XCTestCase {
  func test_onAppear_shouldFetchTwitterData() async throws {
    let decoder: JSONDecoder = .twitterFeedDecoder
    let tweetData = try XCTUnwrap(twitterFeedData)
    let feed = try decoder.decode(TwitterFeed.self, from: tweetData)
    
    let store = TestStore(
      initialState: TwitterFeedFeature.State(),
      reducer: TwitterFeedFeature()
    )
    store.dependencies.twitterService.getTweets = { feed.statuses }
    
    await _ = store.send(.onAppear)
    await store.receive(.fetchData) {
      $0.twitterFeedIsLoading = true
    }
    
    await store.receive(.fetchDataResponse(.success(feed.statuses))) {
      $0.twitterFeedIsLoading = false
      $0.tweets = IdentifiedArray(uniqueElements: feed.statuses)
    }
  }
  
  func test_tweetDecodingTest() throws {
    let decoder: JSONDecoder = .twitterFeedDecoder

    let tweetData = try XCTUnwrap(twitterFeedData)
    let feed = try decoder.decode(TwitterFeed.self, from: tweetData)
        
    XCTAssertNoDifference(
      feed,
      TwitterFeed(statuses: [
        Tweet(
          id: "1452287570415693850",
          text: "RT @CriticalMassR: @CriticalMaps Venerdì 29 ottobre, festa per la riapertura della",
          createdAt: Date(timeIntervalSinceReferenceDate: 656780113.0),
          user: .init(
            name: "Un Andrea Qualunque",
            screenName: "0_0_A_B_0_0",
            profileImageUrl: "https://pbs.twimg.com/profile_images/1452271548644134918/YCKQHQRL_normal.jpg"
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
        "created_at": "Sun Oct 24 14:55:13 +0000 2021",
        "id": 1452287570415693800,
        "id_str": "1452287570415693850",
        "text": "RT @CriticalMassR: @CriticalMaps Venerdì 29 ottobre, festa per la riapertura della",
        "truncated": false,
        "entities": {
          "hashtags": [
            {
              "text": "Ciclofficina",
              "indices": [
                83,
                96
              ]
            }
          ],
          "symbols": [],
          "user_mentions": [
            {
              "screen_name": "CriticalMassR",
              "name": "#CriticalMassRoma",
              "id": 3063043545,
              "id_str": "3063043545",
              "indices": [
                3,
                17
              ]
            },
            {
              "screen_name": "CriticalMaps",
              "name": "Critical Maps",
              "id": 2881177769,
              "id_str": "2881177769",
              "indices": [
                19,
                32
              ]
            }
          ],
          "urls": []
        },
        "metadata": {
          "iso_language_code": "it",
          "result_type": "recent"
        },
        "source": "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>",
        "in_reply_to_status_id": null,
        "in_reply_to_status_id_str": null,
        "in_reply_to_user_id": null,
        "in_reply_to_user_id_str": null,
        "in_reply_to_screen_name": null,
        "user": {
          "id": 2824973992,
          "id_str": "2824973992",
          "name": "Un Andrea Qualunque",
          "screen_name": "0_0_A_B_0_0",
          "location": "Roma, Lazio",
          "description": "Curiosità atta a migliorare questo mondo. Amo il Mediterraneo e tutti i suoi popoli.",
          "url": null,
          "entities": {
            "description": {
              "urls": []
            }
          },
          "protected": false,
          "followers_count": 24,
          "friends_count": 372,
          "listed_count": 0,
          "created_at": "Sun Oct 12 12:32:19 +0000 2014",
          "favourites_count": 192,
          "utc_offset": null,
          "time_zone": null,
          "geo_enabled": false,
          "verified": false,
          "statuses_count": 112,
          "lang": null,
          "contributors_enabled": false,
          "is_translator": false,
          "is_translation_enabled": false,
          "profile_background_color": "C0DEED",
          "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
          "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
          "profile_background_tile": false,
          "profile_image_url": "http://pbs.twimg.com/profile_images/1452271548644134918/YCKQHQRL_normal.jpg",
          "profile_image_url_https": "https://pbs.twimg.com/profile_images/1452271548644134918/YCKQHQRL_normal.jpg",
          "profile_banner_url": "https://pbs.twimg.com/profile_banners/2824973992/1509895265",
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
        },
        "geo": null,
        "coordinates": null,
        "place": null,
        "contributors": null,
        "retweeted_status": {
          "created_at": "Sun Oct 24 14:17:11 +0000 2021",
          "id": 1452277997453590500,
          "id_str": "1452277997453590541",
          "text": "@CriticalMaps Venerdì 29 ottobre",
          "truncated": true,
          "entities": {
            "hashtags": [
              {
                "text": "Ciclofficina",
                "indices": [
                  64,
                  77
                ]
              }
            ],
            "symbols": [],
            "user_mentions": [
              {
                "screen_name": "CriticalMaps",
                "name": "Critical Maps",
                "id": 2881177769,
                "id_str": "2881177769",
                "indices": [
                  0,
                  13
                ]
              }
            ],
            "urls": [
              {
                "url": "https://t.co/D7PFyPBCp2",
                "expanded_url": "https://twitter.com/i/web/status/1452277997453590541",
                "display_url": "twitter.com/i/web/status/1…",
                "indices": [
                  117,
                  140
                ]
              }
            ]
          },
          "metadata": {
            "iso_language_code": "it",
            "result_type": "recent"
          },
          "source": "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>",
          "in_reply_to_status_id": null,
          "in_reply_to_status_id_str": null,
          "in_reply_to_user_id": 2881177769,
          "in_reply_to_user_id_str": "2881177769",
          "in_reply_to_screen_name": "CriticalMaps",
          "user": {
            "id": 3063043545,
            "id_str": "3063043545",
            "name": "#CriticalMassRoma",
            "screen_name": "CriticalMassR",
            "location": "https://www.facebook.com/group",
            "description": "https://t.co/jaQM8xZQpU",
            "url": "https://t.co/TwygvcjXc3",
            "entities": {
              "url": {
                "urls": [
                  {
                    "url": "https://t.co/TwygvcjXc3",
                    "expanded_url": "http://criticalmassroma.caster.fm",
                    "display_url": "criticalmassroma.caster.fm",
                    "indices": [
                      0,
                      23
                    ]
                  }
                ]
              },
              "description": {
                "urls": [
                  {
                    "url": "https://t.co/jaQM8xZQpU",
                    "expanded_url": "https://www.facebook.com/CriticalMassRM/",
                    "display_url": "facebook.com/CriticalMassRM/",
                    "indices": [
                      0,
                      23
                    ]
                  }
                ]
              }
            },
            "protected": false,
            "followers_count": 1020,
            "friends_count": 1543,
            "listed_count": 27,
            "created_at": "Wed Feb 25 19:35:19 +0000 2015",
            "favourites_count": 2162,
            "utc_offset": null,
            "time_zone": null,
            "geo_enabled": false,
            "verified": false,
            "statuses_count": 2068,
            "lang": null,
            "contributors_enabled": false,
            "is_translator": false,
            "is_translation_enabled": false,
            "profile_background_color": "0099B9",
            "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_tile": true,
            "profile_image_url": "http://pbs.twimg.com/profile_images/610546977202241536/axclfbgj_normal.jpg",
            "profile_image_url_https": "https://pbs.twimg.com/profile_images/610546977202241536/axclfbgj_normal.jpg",
            "profile_banner_url": "https://pbs.twimg.com/profile_banners/3063043545/1424893766",
            "profile_link_color": "0099B9",
            "profile_sidebar_border_color": "000000",
            "profile_sidebar_fill_color": "000000",
            "profile_text_color": "000000",
            "profile_use_background_image": true,
            "has_extended_profile": false,
            "default_profile": false,
            "default_profile_image": false,
            "following": false,
            "follow_request_sent": false,
            "notifications": false,
            "translator_type": "none",
            "withheld_in_countries": []
          },
          "geo": null,
          "coordinates": null,
          "place": null,
          "contributors": null,
          "is_quote_status": false,
          "retweet_count": 2,
          "favorite_count": 3,
          "favorited": false,
          "retweeted": false,
          "possibly_sensitive": false,
          "lang": "it"
        },
        "is_quote_status": false,
        "retweet_count": 2,
        "favorite_count": 0,
        "favorited": false,
        "retweeted": false,
        "lang": "it"
      }
  ]
}
"""#.data(using: .utf8)
