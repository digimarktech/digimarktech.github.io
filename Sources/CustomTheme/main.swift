import Foundation
import Publish
import Plot

public struct ItemData: Decodable, Equatable, Hashable {
    var id: Int

    var iconName: String {
        switch id {
        case 1:
            return "cabin.png"
        case 2:
            return "cake.png"
        case 3:
            return "circus.png"
        default: return ""
        }
    }

    var portfolioID: String {
        switch id {
        case 1:
            return "portfolioModal1"
        case 2:
            return "portfolioModal2"
        case 3:
            return "portfolioModal3"
        default: return ""
        }
    }
}

// This type acts as the configuration for your website.
struct CustomTheme: Website, CustomThemeWebsite {

    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case portfolio
        case about
        case posts
        case contact
    }

    struct ItemMetadata: WebsiteItemMetadata, CustomThemeWebsiteItemMetadata {
        var portfolioIcon: String?
        var data: ItemData
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "CustomTheme"
    var description = "A description of CustomTheme"
    var language: Language { .english }
    var imagePath: Path? { Path("assets") }
    var jobTitle = "Graphic Artist - Web Designer - Illustrator"
    var portfolioIcon: String = ""
}

// This will generate your website using the built-in Foundation theme:
try CustomTheme().publish(withTheme: .myTheme)
