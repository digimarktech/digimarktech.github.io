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
            .raw(
                """
                <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
                """
            ),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)

                // Portfolio Section
                Element(name: "section") {
                    Div {
                        H2("Portfolio")
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
                        PortfolioItemGroup(items: context.sections.first(where: { section in
                            return section.title == "Portfolio"
                        })!.items, site: context.site)
                            .class("row justify-content-center")

                            
                    }
                    .class("container")
                }
                .class("page-section portfolio")
                .id("portfolio")

                // About Section
                Element(name: "section") {
                    Div {
                        // About Section Heading
                        H2("About")
                            .class("page-section-heading text-center text-uppercase text-white")

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
                        .class("divider-custom divider-light")

                        // About Section Content
                        Div {
                            Div {
                                Paragraph("Freelancer is a free bootstrap theme created by Start Bootstrap. The download includes the complete source files including HTML, CSS, and JavaScript as well as optional SASS stylesheets for easy customization.")
                                    .class("lead")
                            }
                            .class("col-lg-4 ms-auto")
                            Div {
                                Paragraph("You can create your own custom avatar for the masthead, change the icon in the dividers, and add your email address to the contact form to make it fully functional!")
                                    .class("lead")
                            }
                            .class("col-lg-4 me-auto")

                            // About Section Button
                            Div {
                                Link(url: "https://startbootstrap.com/theme/freelancer/") {
                                    Element(name: "i") {}
                                        .class("fas fa-download me-2")
                                    Text("Free Download")
                                }
                                .class("btn btn-xl btn-outline-light")
                            }
                            .class("text-center mt-4")
                        }
                        .class("row")
                    }
                    .class("container")
                }
                .class("page-section bg-primary text-white mb-0")
                .id("about")

                // Contact Section
                Element(name: "section") {
                    Div {
                        // Contact Section Heading
                        H2("Contact Me")
                            .class("page-section-heading text-center text-uppercase text-secondary mb-0")

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

                        // Contact Section Form
                        Div {
                            Div {
//                                <!-- * * * * * * * * * * * * * * *-->
//                                <!-- * * SB Forms Contact Form * *-->
//                                <!-- * * * * * * * * * * * * * * *-->
//                                <!-- This form is pre-integrated with SB Forms.-->
//                                <!-- To make this form functional, sign up at-->
//                                <!-- https://startbootstrap.com/solution/contact-forms-->
//                                <!-- to get an API token!-->
                                Form(url: "") {
                                    // Name
                                    Div {
                                        Input(type: .text, isRequired: true, placeholder: "Enter your name...")
                                            .class("form-control")
                                            .id("name")
                                            .data(named: "sb-validations", value: "required")
                                        Label("Full Name") {}
                                        Div {
                                            Text("A name is required.")
                                        }
                                        .class("invalid-feedback")
                                        .data(named: "sb-feedback", value: "name:required")
                                    }
                                    .class("form-floating mb-3")

                                    // Email Address Input
                                    Div {
                                        Input(type: .email, isRequired: true, placeholder: "name@example.com")
                                            .class("form-control")
                                            .id("email")
                                            .data(named: "sb-validations", value: "required,email")
                                        Label("Email address") {}
                                        Div {
                                            Text("An email is required.")
                                        }
                                        .class("invalid-feedback")
                                        .data(named: "sb-feedback", value: "email:required")
                                        Div {
                                            Text("Email is not valid.")
                                        }
                                        .class("invalid-feedback")
                                        .data(named: "sb-feedback", value: "email:email")
                                    }
                                    .class("form-floating mb-3")

                                    // Phone Number Input
                                    Div {
                                        Input(type: .tel, isRequired: true, placeholder: "(123) 456-7890")
                                            .class("form-control")
                                            .id("phone")
                                            .data(named: "sb-validations", value: "required")
                                        Label("Phone Number") {}
                                        Div {
                                            Text("A phone number is required.")
                                        }
                                        .class("invalid-feedback")
                                        .data(named: "sb-feedback", value: "phone:required")
                                    }
                                    .class("form-floating mb-3")

                                    // Message Input
                                    Div {
                                        TextArea()
                                            .class("form-control")
                                            .id("message")
                                            .data(named: "sb-validations", value: "required")
                                            .style("height: 10rem")
                                        Label("Message") {}
                                        Div {
                                            Text("A message is required.")
                                        }
                                        .class("invalid-feedback")
                                        .data(named: "sb-feedback", value: "message:required")
                                    }
                                    .class("form-floating mb-3")

//                                    <!-- Submit success message-->
//                                    <!---->
//                                    <!-- This is what your users will see when the form-->
//                                    <!-- has successfully submitted-->
                                    Div {
                                        Div {
                                            Div {
                                                Text("Form submission successful!")
                                            }
                                            .class("fw-bolder")
                                        }
                                        .class("text-center mb-3")
                                    }
                                    .class("d-none")
                                    .id("submitSuccessMessage")

//                                    <!-- Submit error message-->
//                                    <!---->
//                                    <!-- This is what your users will see when there is-->
//                                    <!-- an error submitting the form-->
                                    Div {
                                        Div {
                                            Text("Error sending message!")
                                        }
                                        .class("text-center text-danger mb-3")
                                    }
                                    .class("d-none")
                                    .id("submitErrorMessage")

                                    Button("Send")
                                        .class("btn btn-primary btn-xl disabled")
                                        .id("submitButton")

                                }
                                .data(named: "sb-form-api-token", value: "603e177d-76ef-4647-beaa-99588bbb05d3")
                                .id("contactForm")
                            }
                            .class("col-lg-8 col-xl-7")
                        }
                        .class("row justify-content-center")
                    }
                    .class("container")
                }
                .class("page-section")
                .id("contact")

                // Modals
                PortfolioItemModalGroup(items: context.sections.first(where: { section in
                    return section.title == "Portfolio"
                })!.items, site: context.site)
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

                if section.title == "Portfolio" {
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
                    .style("padding-top: 10rem;")
                    .id("portfolio")

                    // Modals
                    PortfolioItemModalGroup(items: section.items, site: context.site)
                }

                if section.title == "About" {
                    // About Section
                    Div {
                        Div {
                            // About Section Heading
                            H2("About")
                                .class("page-section-heading text-center text-uppercase text-white")

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
                            .class("divider-custom divider-light")

                            // About Section Content
                            Div {
                                Div {
                                    Paragraph("Freelancer is a free bootstrap theme created by Start Bootstrap. The download includes the complete source files including HTML, CSS, and JavaScript as well as optional SASS stylesheets for easy customization.")
                                        .class("lead")
                                }
                                .class("col-lg-4 ms-auto")
                                Div {
                                    Paragraph("You can create your own custom avatar for the masthead, change the icon in the dividers, and add your email address to the contact form to make it fully functional!")
                                        .class("lead")
                                }
                                .class("col-lg-4 me-auto")

                                // About Section Button
                                Div {
                                    Link(url: "https://startbootstrap.com/theme/freelancer/") {
                                        Element(name: "i") {}
                                            .class("fas fa-download me-2")
                                        Text("Free Download")
                                    }
                                    .class("btn btn-xl btn-outline-light")
                                }
                                .class("text-center mt-4")
                            }
                            .class("row")
                        }
                        .class("container")
                    }
                    .class("page-section bg-primary text-white mb-0")
                    .style("padding-top: 10rem;")
                    .id("about")
                }
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
                }
            )
        )
    }

    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        try makeIndexHTML(for: context.index, context: context)
    }

    func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        nil
    }

    func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        nil
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteHeader<Site: Website>: Component where Site: CustomThemeWebsite {
    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID?

    var body: Component {
        Div {
            Navigation {
                Div {
                    Link(context.site.name, url: "/")
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

            if selectedSelectionID == nil {
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

    }

    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]
                let activeString = sectionID == selectedSelectionID ? "active" : ""
                return ListItem {
                    Link(section.title,
                         url: "#\(section.path)"//section.path.absoluteString
                    )
                    .class("nav-link py-3 px-0 px-lg-3 rounded \(activeString)")
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
