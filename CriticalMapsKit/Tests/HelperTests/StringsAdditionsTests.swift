import Helpers
import Testing

@Suite
struct StringAdditionsTests {
  @Test("Remove Date Pattern should remove date pattern")
  func removeDatePatternShouldRemovePattern1() {
    // given
    let title = "Critical Mass Berlin"
    let date = "28.02.2020"
    let titleWithDate = "\(title) \(date)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle == title)
  }

  @Test("Remove Date Pattern should remove date pattern with slash")
  func removeDatePatternShouldRemovePattern2() {
    // given
    let title = "Critical Mass Berlin"
    let date = "28/02/2020"
    let titleWithDate = "\(title) \(date)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle == title)
  }

  @Test("Remove Date Pattern should not remove pattern with slash")
  func removeDatePatternShouldNotRemovePattern1() {
    // given
    let title = "Critical Mass Berlin"
    let date = "02/28/20"
    let titleWithDate = "\(title) \(date)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle != title)
  }

  @Test("Remove Date Pattern should not remove pattern with special pattern")
  func removeDatePatternShouldNotRemovePattern2() {
    // given
    let title = "Critical Mass Berlin"
    let pattern = "Special Edition"
    let titleWithDate = "\(title) \(pattern)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle != title)
  }
}
