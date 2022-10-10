//
//  MyCustomTheme.swift
//  
//
//  Created by Marc Aupont on 10/6/22.
//

import Plot
import Publish
import Foundation

extension Theme where Site: CustomThemeWebsite {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var myTheme: Self {
        Theme(
            htmlFactory: MyCustomThemeHTMLFactory(),
            resourcePaths: [
                "Resources/MyCustomTheme/styles.css",
                "Resources/assets/img/avataaars.svg",
                "Resources/js/scripts.js"
            ]
        )
    }
}

public protocol CustomThemeWebsiteItemMetadata {
    var portfolioIcon: String? { get }
    var data: ItemData { get }
}

public protocol CustomThemeWebsite {
    associatedtype ItemMetadata: CustomThemeWebsiteItemMetadata

    var portfolioIcon: String { get }
}

extension CustomThemeWebsite {
    var portfolioIcon: String  { "" }
}

private struct MyCustomThemeHTMLFactory<Site: Website>: HTMLFactory where Site: CustomThemeWebsite {

    func makeIndexHTML(for index: Publish.Index, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                H2("Cats")
            }
        )
    }

    func makeSectionHTML(for section: Publish.Section<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .raw(
                """
                <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
                """
            ),
            .body {
                SiteHeader(context: context, selectedSelectionID: section.id)
                // Portfolio Section
                Div {
                    Div {
                        H2(section.title)
                            .class("page-section-heading text-center text-uppercase text-secondary mb-0")
                        Div {
                            Div{}.class("divider-custom-line")
                            Div {
                                Element(name: "i") {}
                                    .class("fas fa-star")
                            }
                            .class("divider-custom-icon")
                            Div{}.class("divider-custom-line")
                        }
                        .class("divider-custom")
                        PortfolioItemGroup(items: section.items.sorted(by: { item1, item2 in
                            return item1.date < item2.date
                        }), site: context.site)
                            .class("row justify-content-center")
                    }
                    .class("container")
                }
                .class("page-section portfolio")
                .id("portfolio")

                // Modals
                PortfolioItemModalGroup(items: section.items, site: context.site)
            },
            .raw(
                """
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
                <script src="js/scripts.js"></script>
                """
            )
        )
    }

    func makeItemHTML(for item: Publish.Item<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    SiteHeader(context: context, selectedSelectionID: item.sectionID)
//                    Wrapper {
//                        Article {
//                            Div(item.content.body).class("content")
//                            Span("Tagged with: ")
//                            ItemTagList(item: item, site: context.site)
//                        }
//                    }
//                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
//            .lang(context.site.language),
//            .head(for: page, on: context.site),
//            .body {
//                // alternative header
//                Header {
//                    Wrapper {
//                        Div {
//                            Link(context.site.name, url: "/")
//                                .class("site-name")
//                        }
//                        .class("title")
//
//                        Div {
//                            if Site.SectionID.allCases.count > 1 {
//                                Navigation {
//                                    List(Site.SectionID.allCases) { sectionID in
//                                        let section = context.sections[sectionID]
//                                        return Link(section.title,
//                                            url: section.path.absoluteString
//                                        )
//                                        .class(sectionID.rawValue == page.title ? "selected" : "")
//                                    }
//                                }
//                            }
//                        }
//                        .class("navigation")
//                    }
//                }
//                // alternative header end
//                Wrapper(page.body)
////                SiteFooter()
//            }
        )
    }

    func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1("Browse all tags")
                    List(page.tags.sorted()) { tag in
                        ListItem {
                            Link(tag.string,
                                 url: context.site.path(for: tag).absoluteString
                            )
                        }
                        .class("tag")
                    }
                    .class("all-tags")
                }
//                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1 {
                        Text("Tagged with ")
                        Span(page.tag.string).class("tag")
                    }

                    Link("Browse all tags",
                        url: context.site.tagListPath.absoluteString
                    )
                    .class("browse-all")

                    ItemList(
                        items: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
//                SiteFooter()
            }
        )
    }

}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID?

    var body: Component {
        Div {
            Navigation {
                Div {
                    Link(context.site.name, url: "#page-top")
                        .class("navbar-brand")
                    Button("Menu")
                        .class("navbar-toggler text-uppercase font-weight-bold bg-primary text-white rounded")
                        .data(named: "bs-toggle", value: "collapse")
                        .data(named: "bs-target", value: "#navbarResponsive")
                        .attribute(named: "aria-controls", value: "navbarResponsive")
                        .attribute(named: "aria-expanded", value: "false")
                        .accessibilityLabel("Toggle navigation")
                }
                .class("container")

                Div {
                    if Site.SectionID.allCases.count > 1 {
                        navigation
                    }
                }
                .class("collapse navbar-collapse")
                .id("navbarResponsive")
            }
            .class("navbar navbar-expand-lg bg-secondary text-uppercase fixed-top")
            .id("mainNav")

            Header {
                Div {
                    Image("/assets/img/avataaars.svg")
                        .class("masthead-avatar mb-5")
                    H1(context.site.name)
                        .class("masthead-heading text-uppercase mb-0")
                    Div {
                        Div {}.class("divider-custom-line")
                        Div {
                            Element(name: "i") {}
                                .class("fas fa-star")
                        }
                        .class("divider-custom-icon")
                        Div {}.class("divider-custom-line")
                    }
                    .class("divider-custom divider-light")
                    Paragraph(context.site.name)
                        .class("masthead-subheading font-weight-light mb-0")
                }
                .class("container d-flex align-items-center flex-column")
            }
            .class("masthead bg-primary text-white text-center")
        }

    }

    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]
                return ListItem {
                    Link(section.title,
                        url: section.path.absoluteString
                    )
                    .class("nav-link py-3 px-0 px-lg-3 rounded")
                }
                .class("nav-item mx-0 mx-lg-1")
            }
            .class("navbar-nav ms-auto")
            .listStyle(.unordered)
        }
    }
}

private struct PortfolioItemModalGroup<Site: Website>: Component where Site: CustomThemeWebsite {
    var items: [Item<Site>]
    var site: Site
    var body: Component {
        CustomList(items) { item in
            Div {
                Div {
                    Div {
                        Div {
                            Button()
                                .class("btn-close")
                                .data(named: "bs-dismiss", value: "modal")
                                .attribute(named: "aria-label", value: "Close")
                        }
                        .class("modal-header border-0")
                        Div {
                            Div {
                                Div {
                                    Div {
                                        // Portfolio Modal - Title
                                        H2(item.title)
                                            .class("portfolio-modal-title text-secondary text-uppercase mb-0")

                                        // Icon Divider
                                        Div {
                                            Div{}.class("divider-custom-line")
                                            Div {
                                                Element(name: "i") {}
                                                    .class("fas fa-star")
                                            }
                                            .class("divider-custom-icon")
                                            Div{}.class("divider-custom-line")
                                        }
                                        .class("divider-custom")
                                        // Portfolio Modal - Image
                                        Image("/assets/img/portfolio/\(item.metadata.data.iconName)")
                                            .class("img-fluid rounded mb-5")

                                        // Body Text
                                        Paragraph(item.description)
                                            .class("mb-4")

                                        // Close Button
                                        Button("Close Window")
                                            .class("btn btn-primary")
                                            .data(named: "bs-dismiss", value: "modal")
                                    }
                                    .class("col-lg-8")
                                }
                                .class("row justify-content-center")
                            }
                            .class("container")
                        }
                        .class("modal-body text-center pb-5")
                    }
                    .class("modal-content")
                }
                .class("modal-dialog modal-xl")
            }
            .class("portfolio-modal modal fade")
            .id("\(item.metadata.data.portfolioID)")
            .attribute(named: "tabindex", value: "-1")
            .attribute(named: "aria-labelledby", value: "\(item.metadata.portfolioIcon ?? "")")
            .attribute(named: "aria-hidden", value: "true")
        }
    }
}

private struct PortfolioItemGroup<Site: Website>: Component where Site: CustomThemeWebsite {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        CustomList(items) { item in
            Div {
                Div {
                    Div {
                        Div {
                            Element(name: "i") {}
                                .class("fas fa-plus fa-3x")
                        }
                            .class("portfolio-item-caption-content text-center text-white")
                    }
                    .class("portfolio-item-caption d-flex align-items-center justify-content-center h-100 w-100")
                    Image("/assets/img/portfolio/\(item.metadata.data.iconName)")
                        .class("img-fluid")
                }
                .class("portfolio-item mx-auto")
                .data(named: "bs-toggle", value: "modal")
                .data(named: "bs-target", value: "#\(item.metadata.data.portfolioID)")
            }
            .class("col-md-6 col-lg-4 mb-5")

        }
    }
}

private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H1(Link(item.title, url: item.path.absoluteString))
                ItemTagList(item: item, site: site)
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
    }
}

public struct CustomList<Items: Sequence>: Component {
    /// The items that the list should render.
    public var items: Items
    /// A closure that transforms the list's items into renderable components.
    public var content: (Items.Element) -> Component

//    @EnvironmentValue(.listStyle) private var style

    /// Create a new list with a given set of items.
    /// - parameters:
    ///   - items: The items that the list should render.
    ///   - content: A closure that transforms the list's items into renderable components.
    public init(_ items: Items,
                content: @escaping (Items.Element) -> Component) {
        self.items = items
        self.content = content
    }

    /// Create a new list that renders a sequence of strings, each as its own item.
    /// - parameter items: The strings that the list should render.
    public init(_ items: Items) where Items.Element == String {
        self.init(items) { Text($0) }
    }

    public var body: Component {
        Div {
            for item in items {
                content(item)
            }
        }
//        Element(name: "portfolio-item") {
//            for item in items {
//                content(item)
//            }
//        }
//        Element(name: style.elementName) {
//            for item in items {
//                style.itemWrapper(content(item))
//            }
//        }
    }
}
