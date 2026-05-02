import Helpers
import Testing

struct StringAdditionsTests {
  @Test
  func `Remove Date Pattern should remove date pattern`() {
    // given
    let title = "Critical Mass Berlin"
    let date = "28.02.2020"
    let titleWithDate = "\(title) \(date)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle == title)
  }

  @Test
  func `Remove Date Pattern should remove date pattern with slash`() {
    // given
    let title = "Critical Mass Berlin"
    let date = "28/02/2020"
    let titleWithDate = "\(title) \(date)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle == title)
  }

  @Test
  func `Remove Date Pattern should not remove pattern with slash`() {
    // given
    let title = "Critical Mass Berlin"
    let date = "02/28/20"
    let titleWithDate = "\(title) \(date)"
    // when
    let strippedTitle = titleWithDate.removedDatePattern()
    // then
    #expect(strippedTitle != title)
  }

  @Test
  func `Remove Date Pattern should not remove pattern with special pattern`() {
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
