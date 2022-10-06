import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct CustomTheme: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case portfolio
        case about
        case posts
        case contact
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "CustomTheme"
    var description = "A description of CustomTheme"
    var language: Language { .english }
    var imagePath: Path? { Path("assets") }
}

// This will generate your website using the built-in Foundation theme:
try CustomTheme().publish(withTheme: .myTheme)
