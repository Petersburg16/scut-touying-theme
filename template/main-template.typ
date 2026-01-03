// For template editing
//#import "lib.typ": *

// For template packaging
#import "@local/scut-touying:0.1.0": *

// DONE: 添加模板cite能力
// DONE: 添加字体配置
// DONE: 添加图片+文字的经典配置

// Roadmap
// TODO: 添加首行缩进功能，目前添加的配置未生效
// TODO: 解决重复引用的“同上”问题
// TODO: 补全并默认关闭显示logo的功能，目前logo显示没有完全实现
// TODO：配置允许自动开启二级标题编号，以符合个人汇报习惯
// TODO：自定义引文cls，避免加入网址等信息。
// TODO: 添加强调，加粗、更换颜色的关键词突出方法。

// If it's necessary to insert LaTexbib references, please prepare a "ref.bib" file.
// 如果需要插入引文，请删除这两行注释，并在根目录准备“ref.bib”文件。
// TODO： 将引文路径作为参数传入模板，自动检测是否启用引文。
#show bibliography: none
#bibliography("/ref.bib", style: "gb-7714-2015-note",title: none)

#show: scut-touying-theme.with(
  aspect-ratio: "16-9",
  lang: "zh", // ""en" for English, "zh" for Chinese
  // Recommended LXGW WenKai for Chinese slides
  font:((name: "LXGW WenKai", covers: "latin-in-cjk"),"LXGW WenKai","Microsoft Yahei"),

  // If you prefer a sans-serif font
  // font:((name: "Microsoft Yahei", covers: "latin-in-cjk"),"Microsoft Yahei","LXGW WenKai"),
  // Or try the deafult font:
  // font: ((name: "Libertinus Serif", covers: "latin-in-cjk"), "KaiTi", "Kaiti SC", "Kai", "楷体"),

  // 全文字体大小控制，建议在16~20pt之间
  text-size: 18pt,
  // 确保文字段落使用两端对齐
  justify: true,

  // Basic information
  config-info(
    title: [Typst Slide Theme for South China University of Technology and Based on Touying],
    subtitle: [基于Touying的华南理工大学Typst幻灯片模板],
    short-title: [Typst Slide Theme for SCUT Based on Touying],
    authors: [汇报人：汇报人姓名#super("1")\ 指导老师：指导教授#super("1,2")],
    author: [汇报人：汇报人姓名],
    date: datetime.today(),
    institution: ([#super("1")自动化科学与工程学院 华南理工大学],[#super("2")自动化科学与工程学院 华南理工大学]),

    // 可自行更换学校、学院banner
    // banner: image("/assets/scutbanner.jpg")
  ),

  // 如有需要，可自行配置主题色
  // config-colors(
  //   primary: rgb(1, 83, 139),
  //   primary-dark: rgb(0, 42, 70),
  //   secondary: rgb(255, 255, 255),
  //   neutral-lightest: rgb(255, 255, 255),
  //   neutral-darkest: rgb(0, 0, 0),
  // ),
)

#title-slide()
#outline-slide()

= 第一章标题
== 1.1 列表示例

可以添加观点列表。
// TODO：了解Touying提供的api，似乎可以通过动画的方式将列表生成为多页slides。
- #lorem(6)
  - #lorem(12)
  - #lorem(12) 
- #lorem(6)

== 1.2 正文及文献引用示例

 #lorem(60)
请确保已经导出.bib文件到根目录"ref.bib"下，然后添加引用@gao_prediction_2024。该方法可以自动配置页脚显示引文。

== 1.3 图片-文字搭配
#slide[
  #figure(
    image("/assets\SCUTbanner.jpg"),
    caption: [示例图片]
  )
][
  #lorem(40)
  同样，可以在分栏显示时正确添加引文格式@gao_prediction_2024，不过目前重复引用会显示“同上”，并且cls文件会添加冗余的网址信息，还需要进一步调整。@jaseena_decomposition-based_2021
]

= 第二章标题



== 2.1 插入图片
- Insert figure
```typst
#figure(
  image("fig.png", width: auto, height: 80%),
  caption: [Example Figure],
)
```

== 2.2 插入表格
#{
show table.cell: set text(size:16pt)
figure(
  table(
    columns: (1fr, 1fr, 1fr),
    stroke: none,
    align: center + horizon,
    inset: .5em,
    table.hline(stroke: 2pt),
    [Name], [Age], [Major],
    table.hline(stroke: 1pt),
    [Zhang San], [23], [Finance],
    [Li Si], [22], [Economics],
    [Wang Wu], [24], [Accounting],
    table.hline(stroke: 2pt),
  ),
  caption: "Example Table",
  
)

}




= 第三章标题
==
#ending-slide("谢谢！")



