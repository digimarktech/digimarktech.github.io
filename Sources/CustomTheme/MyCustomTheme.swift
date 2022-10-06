//
//  MyCustomTheme.swift
//  
//
//  Created by Marc Aupont on 10/6/22.
//

import Plot
import Publish

public extension Theme {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var myTheme: Self {
        Theme(
            htmlFactory: MyCustomThemeHTMLFactory(),
            resourcePaths: ["Resources/MyCustomTheme/styles.css"]
        )
    }
}

private struct MyCustomThemeHTMLFactory<Site: Website>: HTMLFactory {

    func makeIndexHTML(for index: Publish.Index, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
//                Wrapper {
//                    Div {
//                        H1(index.title)
//                        Paragraph(context.site.description)
//                            .class("description")
//                    }
//                    .class("main-intro")
//                    H2("Latest content")
//                    ItemList(
//                        items: context.allItems(
//                            sortedBy: \.date,
//                            order: .descending
//                        ),
//                        site: context.site
//                    )
//                }
//                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Publish.Section<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: section.id)
                Wrapper {
                    H1(section.title)
                    ItemList(items: section.items, site: context.site)
                }
//                SiteFooter()
            }
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
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Span("Tagged with: ")
                            ItemTagList(item: item, site: context.site)
                        }
                    }
//                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                // alternative header
                Header {
                    Wrapper {
                        Div {
                            Link(context.site.name, url: "/")
                                .class("site-name")
                        }
                        .class("title")

                        Div {
                            if Site.SectionID.allCases.count > 1 {
                                Navigation {
                                    List(Site.SectionID.allCases) { sectionID in
                                        let section = context.sections[sectionID]
                                        return Link(section.title,
                                            url: section.path.absoluteString
                                        )
                                        .class(sectionID.rawValue == page.title ? "selected" : "")
                                    }
                                }
                            }
                        }
                        .class("navigation")
                    }
                }
                // alternative header end
                Wrapper(page.body)
//                SiteFooter()
            }
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

//    <nav class="navbar navbar-expand-lg bg-secondary text-uppercase fixed-top" id="mainNav">
//                <div class="container">
//                    <a class="navbar-brand" href="#page-top">Start Bootstrap</a>
//                    <button class="navbar-toggler text-uppercase font-weight-bold bg-primary text-white rounded" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
//                        Menu
//                        <i class="fas fa-bars"></i>
//                    </button>
//                    <div class="collapse navbar-collapse" id="navbarResponsive">
//                        <ul class="navbar-nav ms-auto">
//                            <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#portfolio">Portfolio</a></li>
//                            <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#about">About</a></li>
//                            <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#contact">Contact</a></li>
//                        </ul>
//                    </div>
//                </div>
//            </nav>

    var body: Component {
        Header {
            Navigation {
                Div {
                    Link(context.site.name, url: "#page-top")
                        .class("navbar-brand")
                    Button("Menu")
                        .class("navbar-toggler text-uppercase font-weight-bold bg-primary text-white rounded")
                        .data(named: "toggle", value: "collapse")
                        .data(named: "target", value: "#navbarResponsive")
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
        }
//        Header {
//            Wrapper {
//                Div {
//                    Link(context.site.name, url: "/")
//                        .class("site-name")
//                }
//                .class("title")
//
//                Div {
//                    if Site.SectionID.allCases.count > 1 {
//                        navigation
//                    }
//                }
//                .class("navigation")
//            }
//        }
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
