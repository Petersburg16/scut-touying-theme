
// =============================================================================
// SCUT Touying Theme | 华南理工大学 Typst 幻灯片主题
// =============================================================================
// 
// [致谢与溯源 / Acknowledgment & Origin]
// 本项目基于 `touying-simpl-swufe` 主题进行修改与适配。
// 衷心感谢原作者 Lei Chao <le.haibo@qq.com> 在 `touying-simpl-swufe` 上的卓越工作与审美设计。
// 你们的开源贡献为华南理工大学的同学们提供了一个优雅、高效的排版起点。
//
// This theme is inspired by and derived from the `touying-simpl-swufe` project.
// We express our deepest gratitude to the original creators for their 
// fantastic foundational work and aesthetic design.
//
// -----------------------------------------------------------------------------
//
// [授权协议 / License]
// Copyright (c) 2026 Petersburg16
//
// 本项目遵循 MIT 开源协议。你可以自由地使用、修改和分发本模板，
// 但请务必在你的派生版本中保留此版权声明。
//
// Licensed under the MIT License.
// You are free to use, modify, and distribute this theme, provided that
// this copyright notice is included in all copies or substantial portions.
//
// Modified by: Petersburg16 <wming1116@icloud.com>
// Date: 2026-01-03
//
// =============================================================================
#import "@preview/touying:0.6.1": *


#let _tblock(self: none, title: none, it) = {
  grid(
    columns: 1,
    row-gutter: 0pt,
    block(
      fill: self.colors.primary-dark.lighten(15%),
      width: 100%,
      radius: (top: 6pt),
      inset: (top: 0.4em, bottom: 0.3em, left: 0.5em, right: 0.5em),
      text(fill: self.colors.neutral-lightest, weight: "bold", title),
    ),

    rect(
      fill: gradient.linear(self.colors.primary-dark, self.colors.primary.lighten(90%), angle: 90deg),
      width: 100%,
      height: 4pt,
    ),

    block(
      fill: self.colors.primary.lighten(90%),
      width: 100%,
      radius: (bottom: 6pt),
      inset: (top: 0.5em, bottom: 0.5em, left: 0.5em, right: 0.5em),
      it,
    ),
  )
}


/// Theorem block for the presentation.
///
/// - title (string): The title of the theorem. Default is `none`.
///
/// - it (content): The content of the theorem.
#let tblock(title: none, it) = touying-fn-wrapper(_tblock.with(title: title, it))


/// Default slide function for the presentation.
///
/// - title (string): The title of the slide. Default is `auto`.
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - repeat (auto): The number of subslides. Default is `auto`, which means touying will automatically calculate the number of subslides.
///
///   The `repeat` argument is necessary when you use `#slide(repeat: 3, self => [ .. ])` style code to create a slide. The callback-style `uncover` and `only` cannot be detected by touying automatically.
///
/// - setting (dictionary): The setting of the slide. You can use it to add some set/show rules for the slide.
///
/// - composer (function): The composer of the slide. You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]` will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - bodies (content): The contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  title: auto,
  header: auto,
  footer: auto,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  if align != auto {
    self.store.align = align
  }
  if title != auto {
    self.store.title = title
  }
  if header != auto {
    self.store.header = header
  }
  if footer != auto {
    self.store.footer = footer
  }
  let new-setting = body => {
    show: std.align.with(self.store.align)
    set par(
      justify: self.store.at("justify", default: false),
      first-line-indent: self.store.at("first-line-indent", default: 2em),
    )
    show: setting
    body
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})


/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: swufe-theme.with(
///   config-info(
///     title: [Title],
///     subtitle: [Subtitle],
///     short-title: [Short Title for Footer],
///     authors: [Author One#super("1"), Author Two#super("1,2")],
///     author: [Author for Footer],
///     institution: ([#super("1")Institution One], [#super("2")Institution Two]),
///     date: datetime.today(),
///     banner: #image("assets/swufebanner.svg"),
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle])
/// ```
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
  )
  self.store.title = none
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let body = {
    let content-info = {
      set std.align(center + horizon)
      block(
        fill: self.colors.primary,
        inset: 1.5em,
        radius: 0.5em,
        breakable: false,
        {
          text(size: 1.2em, fill: self.colors.neutral-lightest, weight: "bold", info.title)
          if info.subtitle != none {
            parbreak()
            text(size: 1.0em, fill: self.colors.neutral-lightest, weight: "bold", info.subtitle)
          }
        },
      )
      // authors
      grid(
        columns: (1fr,) * calc.min(info.authors.len(), 3),
        column-gutter: 1em,
        row-gutter: 1em,
        ..info.authors.map(author => text(fill: black, author)),
      )
      v(0.5em)
      // institution
      if info.institution != none {
        parbreak()
        set text(size: 0.75em, weight: "regular")

        if type(info.institution) == array {
          grid(
            columns: 1,
            gutter: 0.4em,
            ..info.institution
          )
        } else {
          info.institution
        }
      }
      // date
      if info.date != none {
        parbreak()
        text(size: 1.0em, utils.display-info-date(self))
      }
    }
    // banner image
    if info.banner != none {
      grid(
        columns: 1,
        rows: (auto, 1fr),
        gutter: 1.5em,
        content-info,
        align(center + horizon, block(
          width: 100%,
          height: 100%,
          {
            set image(width: 100%, height: 100%, fit: "contain")
            utils.call-or-display(self, info.banner)
          },
        )),
      )
    } else {
      set std.align(center + horizon)
      content-info
    }
  }
  touying-slide(self: self, body)
})


/// Outline slide for the presentation.
/// Add bullet points for each section
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - title (string): is the title of the outline. Default is `utils.i18n-outline-title`.
///
/// - level (int, none): is the level of the outline. Default is `none`.
///
/// - numbered (boolean): is whether the outline is numbered. Default is `true`.
#let outline-slide(
  config: (:),
  title: utils.i18n-outline-title,
  numbered: true,
  level: none,
  ..args,
) = touying-slide-wrapper(self => {
  self.store.title = title
  touying-slide(
    self: self,
    config: config,
    std.align(
      self.store.align,
      components.adaptive-columns(
        text(
          fill: self.colors.primary,
          weight: "bold",
          components.custom-progressive-outline(
            level: level,
            alpha: self.store.alpha,
            indent: (0em, 1em),
            vspace: (.4em,),
            numbered: (numbered,),
            numbering: (
              (..nums) => {
                box(baseline: -0.65em, components.knob-marker(primary: self.colors.primary))
                h(0.25em)
              },
            ),
            depth: 1,
            ..args.named(),
          ),
        ),
      )
        + args.pos().sum(default: none),
    ),
  )
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - title (content, function): is the title of the section. The default is `utils.i18n-outline-title`.
///
/// - level (int): is the level of the heading. The default is `1`.
///
/// - numbered (boolean): is whether the heading is numbered. The default is `true`.
///
/// - body (none): is the body of the section. It will be passed by touying automatically.
#let new-section-slide(
  config: (:),
  title: utils.i18n-outline-title,
  level: 1,
  numbered: true,
  ..args,
  body,
) = outline-slide(config: config, title: title, level: level, numbered: numbered, ..args, body)



/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - align (alignment): is the alignment of the content. The default is `horizon + center`.
#let focus-slide(config: (:), align: horizon + center, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: self.colors.primary,
      margin: 2em,
      header: none,
      footer: none,
    ),
  )
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.5em)
  touying-slide(self: self, config: config, std.align(align, body))
})


/// End slide for the presentation.
/// Remove the title and center the content.
/// - config (dictionary): is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
///
/// - body (array): is the content of the slide.

#let ending-slide(config: (:), body) = touying-slide-wrapper(self => {
  self.store.title = none
  let content = {
    set std.align(center + horizon)
    move(dy: -1.5em)[#text(size: 3.5em)[
      #emph(body)
    ]]
  }

  touying-slide(self: self, config: config, content)
})

#let custom-mini-slides(
  self: none,
  fill: rgb("000000"),
  alpha: 60%,
  display-section: false,
  display-subsection: true,
  linebreaks: true,
  short-heading: true,
  text-size: .7em,      // 新增：控制文字大小
  marker-size: .5em,    // 新增：控制圆圈大小
  text-marker-spacing: 0.2em, // 新增：控制文字和圆圈的垂直间距
) = (
  context {
    let headings = query(heading.where(level: 1).or(heading.where(level: 2)))
    let sections = headings.filter(it => it.level == 1)
    if sections == () {
      return
    }
    let first-page = sections.at(0).location().page()
    headings = headings.filter(it => it.location().page() >= first-page)
    let slides = query(<touying-metadata>).filter(it => (
      utils.is-kind(it, "touying-new-slide") and it.location().page() >= first-page
    ))
    let current-page = here().page()
    let current-index = sections.filter(it => it.location().page() <= current-page).len() - 1
    let cols = ()
    let col = ()
    for (hd, next-hd) in headings.zip(headings.slice(1) + (none,)) {
      let next-page = if next-hd != none {
        next-hd.location().page()
      } else {
        calc.inf
      }
      if hd.level == 1 {
        if col != () {
          cols.push(align(left, col.sum()))
          col = ()
        }
        col.push({
          let body = if short-heading {
            utils.short-heading(self: self, hd)
          } else {
            hd.body
          }
          [#link(hd.location(), body)<touying-link>]
          linebreak()
          v(text-marker-spacing)
          while slides.len() > 0 and slides.at(0).location().page() < next-page {
            let slide = slides.remove(0)
            if display-section {
              let next-slide-page = if slides.len() > 0 {
                slides.at(0).location().page()
              } else {
                calc.inf
              }
              if slide.location().page() <= current-page and current-page < next-slide-page {
                [#link(slide.location(), sym.circle.filled)<touying-link>]
              } else {
                [#link(slide.location(), sym.circle)<touying-link>]
              }
            }
          }
          if display-section and display-subsection and linebreaks {
            linebreak()
          }
        })
      } else {
        col.push({
          while slides.len() > 0 and slides.at(0).location().page() < next-page {
            let slide = slides.remove(0)
            if display-subsection {
              let next-slide-page = if slides.len() > 0 {
                slides.at(0).location().page()
              } else {
                calc.inf
              }
              if slide.location().page() <= current-page and current-page < next-slide-page {
                [#link(slide.location(), sym.circle.filled)<touying-link>]
              } else {
                [#link(slide.location(), sym.circle)<touying-link>]
              }
            }
          }
          if display-subsection and linebreaks {
            linebreak()
          }
        })
      }
    }
    if col != () {
      cols.push(align(left, col.sum()))
      col = ()
    }
    if current-index < 0 or current-index >= cols.len() {
      cols = cols.map(body => text(fill: fill, body))
    } else {
      cols = cols.enumerate().map(pair => {
        let (idx, body) = pair
        if idx == current-index {
          text(fill: fill, body)
        } else {
          text(fill: utils.update-alpha(fill, alpha), body)
        }
      })
    }
    set align(top)
    show: block.with(inset: (top: .5em, x: 2em))
    show linebreak: it => it + v(-1em)
    
    // 核心修改：分别应用大小
    set text(size: text-size) 
    show sym.circle: set text(size: marker-size)
    show sym.circle.filled: set text(size: marker-size)

    grid(columns: cols.map(_ => auto).intersperse(1fr), ..cols.intersperse([]))
  }
)
/// SCUT touying theme.
///
/// Example:
///
/// ```typst
/// #show: swufe-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// Consider using:
///
/// ```typst
/// #set text(font: "Fira Sans", weight: "light", size: 20pt)`
/// #show math.equation: set text(font: "Fira Math")
/// #set strong(delta: 100)
/// #set par(justify: true)
/// ```
/// The default colors:
///
///
/// ```typst
/// config-colors(
///   primary: rgb("#005bac"),
///   primary-dark: rgb("#004078"),
///   secondary: rgb("#ffffff"),
///   tertiary: rgb("#005bac"),
///   neutral-lightest: rgb("#ffffff"),
///   neutral-darkest: rgb("#000000"),
/// )
/// ```
///
/// - aspect-ratio (string): is the aspect ratio of the slides. The default is `16-9`.
///
/// - align (alignment): is the alignment of the content. The default is `horizon`.
///
/// - title (content, function): is the title in the header of the slide. The default is `self => utils.display-current-heading(depth: self.slide-level)`.
///
/// - header-right (content, function): is the right part of the header. The default is `self => self.info.logo`.
///
/// - footer (content, function): is the footer of the slide. The default is `none`.
///
/// - footer-right (content, function): is the right part of the footer. The default is `context utils.slide-counter.display() + " / " + utils.last-slide-number`.
///
/// - progress-bar (boolean): is whether to show the progress bar in the footer. The default is `true`.
///
/// - footer-columns (array): is the columns of the footer. The default is `(1fr, 2fr, 0.7fr, 0.3fr)`.
///
/// - footer-a (content, function): is the left part of the footer. The default is `self => self.info.author`.
///
/// - footer-b (content, function): is the second right part of the footer. The default is `self => if self.info.short-title == auto { self.info.title } else { self.info.short-title }`.
///
/// - footer-c (content, function): is the second left part of the footer. The default is `self => utils.display-info-date(self)`.
///
/// - footer-d (content, function): is the right part of the footer. The default is `context utils.slide-counter.display() + " / " + utils.last-slide-number`.
#let scut-touying-theme(
  aspect-ratio: "16-9",
  lang: "en",
  font: ("Libertinus Serif",),
  text-size: 20pt,
  footnote-size:10pt,
  justify: true, // 新增：是否两端对齐
  first-line-indent: 2em, // 新增：首行缩进量

  align: horizon,
  alpha: 20%,
  title: self => utils.display-current-heading(depth: self.slide-level),

  footer-columns: (0.8fr, 2fr, 0.5fr, 0.3fr),
  footer-a: self => self.info.author,
  footer-b: self => if self.info.short-title == auto {
    self.info.title
  } else {
    self.info.short-title
  },
  footer-c: self => utils.display-info-date(self),
  footer-d: self => context utils.slide-counter.display() + " / " + utils.last-slide-number,

  ..args,
  body,
) = {
  // 全文字体设置
  set text(
    lang: lang,
    font: font, 
    size: text-size
    )
  
  show: if lang == "zh" {
    import "@preview/cuti:0.3.0": show-cn-fakebold
    show-cn-fakebold
  } else {
    it => it
  }

  let nav-bar(self) = block(
    width: 100%,
    fill: self.colors.primary-dark,
    inset: (top: -0.2em, bottom: 0.3em, left: -1em, right: 0em),
    //components.mini-slides(
    custom-mini-slides(
      self: self,
      fill: self.colors.neutral-lightest,
      alpha: 55%,
      display-section: false,
      display-subsection: true,
      linebreaks: false,
      text-size: 0.8em,   // 在这里调整文字大小
      marker-size:0.6em,//
      text-marker-spacing: 4pt
    ),
  )

  // add gradient transitions in header
  let header(self) = {
    set std.align(top)
    let header-content = utils.call-or-display(self, self.store.header)
    grid(
      columns: 1,
      // 消除渐变线中间的空白线条，使过渡更加自然
      row-gutter: -0.5pt,
      utils.call-or-display(self, self.store.navigation),
      if self.store.title != none {
        rect(
          width: 100%,
          height: 5pt,
          stroke:none,
          fill: gradient.linear(self.colors.primary-dark, self.colors.primary, angle: 90deg),
        )
      } else {
        rect(
          width: 100%,
          height: 6pt,
          stroke:none,
          fill: gradient.linear(self.colors.primary-dark, self.colors.neutral-lightest, angle: 90deg),
        )
      },
      header-content,
      if self.store.title != none {
        rect(
          width: 100%,
          height: 6pt,
          stroke:none,
          fill: gradient.linear(self.colors.primary, self.colors.neutral-lightest, angle: 90deg),
        )
      },
    )
  }


  let footer(self) = {
    set text(
      size: .5em,
      // 避免文字太靠近底部
      bottom-edge: "descender")

    set std.align(center + bottom)
    grid(
      rows: (auto, auto),
      utils.call-or-display(self, self.store.footer),
      stroke:none,
      // 消除最下方空白，可能由中文字体导致
      gutter: -1pt,
    )
  }

  show: touying-slides.with(
    config-info(
      banner: image("assets/SCUTbanner.jpg", height: 3em),
      
      //logo:image("assets/SCUTlogo.jpg" ,height: 3em)
      ),
    config-page(
      paper: "presentation-" + aspect-ratio,
      header: header,
      footer: footer,
      header-ascent: 0em,
      footer-descent: 0em,
      margin: (top: 3.5em, bottom: 1.2em, x: 2.5em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      scale-list-items: 0.85,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(size: text-size)
        set list(marker: components.knob-marker(primary: self.colors.primary))
        show figure.caption: set text(size: 0.6em)
        
        show heading: set text(fill: self.colors.primary)
        show link: it => if type(it.dest) == str {
          set text(fill: self.colors.primary)
          it
        } else {
          it
        }

        show figure.where(kind: table): set figure.caption(position: top)

        // 配置单页引文脚注
        set footnote.entry(
          separator: line(length: 34%, stroke: 0.5pt), // 设置分隔线
          clearance: 0em,                               // 正文与分隔线之间的距离
          gap: 0.4em,                                     // 多个脚注条目之间的间距
          indent: 0em,                                // 脚注条目的缩进
        )
        show footnote.entry: it => {
          set text(size: footnote-size)
          let loc = it.note.location()
          let number = counter(footnote).at(loc).first()
          // 直接拼接：正常基线的编号 + 空格 + 内容
          [\[#number\] #it.note.body]
        }
        set footnote(numbering: "[1]")

        body
      },
      alert: utils.alert-with-primary-color,
      tblock: _tblock,
    ),
    config-colors(
      primary: rgb(1, 83, 139),
      primary-dark: rgb(0, 37, 79),
      secondary: rgb(255, 255, 255),
      neutral-lightest: rgb(255, 255, 255),
      neutral-darkest: rgb(0, 0, 0),
    ),
    // save the variables for later use
    config-store(
      align: align,
      alpha: alpha,
      title: title,
      footer-columns: footer-columns,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
      footer-d: footer-d,
      navigation: nav-bar,
      justify: justify, // 新增：是否两端对齐
      first-line-indent: first-line-indent, 
      header: self => if self.store.title != none {
        block(
          width: 100%,
          height: 1.6em,
          fill: self.colors.primary,

          place(
            left + horizon,
            text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.1em, 
            utils.call-or-display(
              self,
              self.store.title,
            )),
            dx: 1em,
            dy: -0.1em,
            
          ),
        )
      },
      footer: self => {
        let cell(fill: none, it) = rect(
          width: 100%,
          height: 100%,
          inset: 1mm,
          outset: 0mm,
          fill: fill,
          stroke: none,
          std.align(align, text(fill: self.colors.neutral-lightest, it)),
        )
        grid(
          columns: self.store.footer-columns,
          rows: 1.5em,
          cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-a)),
          cell(fill: self.colors.primary-dark, utils.call-or-display(self, self.store.footer-b)),
          cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-c)),
          cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-d)),
        )
      },
    ),
    ..args,
  )

  body
}
