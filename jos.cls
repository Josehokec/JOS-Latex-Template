%% ======================================================================
%%  jos.cls —— 《软件学报》(Journal of Software) 中文论文 LaTeX 模板
%%  依据 2021 年《软件学报》Word 投稿/排版文件的版式复刻
%%  编译方式：XeLaTeX（推荐 Overleaf 选 XeLaTeX，或本地 TeX Live / MiKTeX）
%%
%%  版式要点（均取自 Word 样式定义）：
%%    纸张 184mm x 260mm；左右边距 14.5mm；下边距 22mm
%%    正文 9pt（小五）宋体 / Times New Roman，行距 14.25pt，首行缩进 2 字
%%    一级标题 10.5pt（五号）黑体；二级标题 9pt 黑体；三级标题 9pt 宋体
%%    题目 14pt 黑体；作者 12pt 仿宋（横向压缩 66%）；单位 8pt
%%    中文摘要 9pt 楷体；英文摘要 7.5pt；参考文献 7.5pt
%%    图题 9pt 宋体（图在上、题在下）；表题 9pt 黑体（表题在上）；表内 7.5pt
%%    首页无页眉；之后偶数页（相对首页）为 “页码 | Journal of Software 软件学报 卷期”，
%%    奇数页为 “作者 等: 题目 | 页码”
%% ======================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jos}[2026/10/25 v1.1 Journal of Software (Ruan Jian Xue Bao) template]

%% ---- 选项：未知选项（如 fontset=windows / mac / fandol）传给 ctex ----
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{ctex}}
\ProcessOptions\relax

\LoadClass[twoside]{article}

%% ---- 中文支持 ----
\RequirePackage[UTF8,heading=false]{ctex}
\renewcommand\baselinestretch{1}   % ctex 默认会放大行距，这里按 Word 的固定行距重设

%% ---- 西文字体：Times New Roman（无则用 TeX Gyre Termes）----
\IfFontExistsTF{Times New Roman}
  {\setmainfont{Times New Roman}}
  {\setmainfont{TeX Gyre Termes}}

%% ---- 中文缺字自动补字 ----
%% 仿宋、楷体以及 Fandol 字体只收 GB2312 常用字，人名中的“喆、堃、珺、玥”等字会缺失。
%% 开启 xeCJK 的 AutoFallBack：当前字体没有某字时，自动改用系统中字库更全的同类字体。
%% 回退字体按顺序取第一个已安装的（Overleaf 有 Noto CJK；macOS 有宋体-简/苹方；Windows 有宋体/微软雅黑）。
\ExplSyntaxOn
\tl_new:N \l__jos_fb_tl
\clist_new:N \l__jos_fb_clist
\cs_new_protected:Npn \__jos_pick_font:Nn #1#2
  {
    \tl_clear:N #1
    \clist_set:Nx \l__jos_fb_clist {#2}
    \clist_map_inline:Nn \l__jos_fb_clist
      { \IfFontExistsTF {##1} { \tl_set:Nn #1 {##1} \clist_map_break: } { } }
  }
\cs_new_protected:Npn \__jos_set_fallback:nn #1#2
  {
    \__jos_pick_font:Nn \l__jos_fb_tl {#2}
    \tl_if_empty:NF \l__jos_fb_tl
      { \exp_args:NnV \setCJKfallbackfamilyfont {#1} \l__jos_fb_tl }
  }
\clist_const:Nn \c__jos_fb_song_clist
  { Noto~Serif~CJK~SC, Source~Han~Serif~SC, Songti~SC, STSong, SimSun, NSimSun }
\clist_const:Nn \c__jos_fb_hei_clist
  { Noto~Sans~CJK~SC, Source~Han~Sans~SC, PingFang~SC, Heiti~SC, STHeiti, Microsoft~YaHei, SimHei }
\cs_if_exist:NT \setCJKfallbackfamilyfont
  {
    \xeCJKsetup { AutoFallBack = true }
    \__jos_set_fallback:nn { \CJKrmdefault } { \c__jos_fb_song_clist }
    \__jos_set_fallback:nn { \CJKsfdefault } { \c__jos_fb_hei_clist }
    \__jos_set_fallback:nn { zhsong } { \c__jos_fb_song_clist }
    \__jos_set_fallback:nn { zhhei }  { \c__jos_fb_hei_clist }
    \__jos_set_fallback:nn { zhkai }
      { Kaiti~SC, STKaiti, KaiTi, \c__jos_fb_song_clist }
    \__jos_set_fallback:nn { zhfs }
      { STFangsong, FangSong, Kaiti~SC, STKaiti, KaiTi, \c__jos_fb_song_clist }
  }
%% 手动指定补字字体（导言区使用），例如 \setjosfallback{Songti SC}
\NewDocumentCommand \setjosfallback { m }
  {
    \cs_if_exist:NT \setCJKfallbackfamilyfont
      {
        \xeCJKsetup { AutoFallBack = true }
        \clist_map_inline:nn { \CJKrmdefault, \CJKsfdefault, zhsong, zhhei, zhkai, zhfs }
          { \setCJKfallbackfamilyfont {##1} {#1} }
      }
  }
\ExplSyntaxOff

%% ---- 常用宏包 ----
\RequirePackage{amsmath,amssymb,amsthm}
\IfFileExists{newtxmath.sty}{\RequirePackage{newtxmath}}{}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{array}
\RequirePackage{calc}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage[font=small]{caption}
\RequirePackage{subcaption}
\RequirePackage[super,square,comma,sort&compress]{natbib}
\RequirePackage[hidelinks]{hyperref}
\urlstyle{same}

%% ---- 版面 ----
\RequirePackage[paperwidth=184mm,paperheight=260mm,
  left=14.5mm,right=14.5mm,top=19mm,bottom=22mm,
  headheight=10pt,headsep=4mm,footskip=10mm]{geometry}

%% ---- 字号（全部用绝对磅值，与 Word 对齐）----
\renewcommand\normalsize{%
  \@setfontsize\normalsize{9pt}{14.25pt}%
  \abovedisplayskip 4pt plus 2pt minus 2pt
  \belowdisplayskip \abovedisplayskip
  \abovedisplayshortskip 2pt plus 1pt
  \belowdisplayshortskip 2pt plus 1pt
  \let\@listi\@listI}
\renewcommand\small{\@setfontsize\small{8pt}{11pt}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{7.5pt}{11pt}}
\renewcommand\scriptsize{\@setfontsize\scriptsize{6.5pt}{8pt}}
\renewcommand\large{\@setfontsize\large{10.5pt}{14.25pt}}
\renewcommand\Large{\@setfontsize\Large{12pt}{16pt}}
\renewcommand\LARGE{\@setfontsize\LARGE{14pt}{18pt}}
\newcommand\josfont[2]{\fontsize{#1}{#2}\selectfont}
\normalsize

\setlength\parindent{2em}
\setlength\parskip{0pt}
\setlength\columnsep{0pt}
\linespread{1}

%% ---- 标题层级 ----
%% 1  一级标题：10.5pt 黑体，编号 Times 加粗，段前段后 8pt
\titleformat{\section}
  {\heiti\josfont{10.5pt}{14.25pt}\raggedright}
  {\textbf{\thesection}}{1em}{}
\titlespacing*{\section}{0pt}{8pt}{8pt}
%% 1.1  二级标题：9pt 黑体，编号加粗
\titleformat{\subsection}
  {\heiti\josfont{9pt}{14.25pt}\raggedright}
  {\textbf{\thesubsection}}{1em}{}
\titlespacing*{\subsection}{0pt}{2pt}{2pt}
%% 1.1.1  三级标题：9pt 宋体，编号不加粗
\titleformat{\subsubsection}
  {\songti\josfont{9pt}{14.25pt}\raggedright}
  {\thesubsubsection}{1em}{}
\titlespacing*{\subsubsection}{0pt}{2pt}{0pt}
%% 1.1.1.1  四级标题：9pt 黑体
\setcounter{secnumdepth}{4}
\titleformat{\paragraph}
  {\heiti\josfont{9pt}{14.25pt}\raggedright}
  {\textbf{\theparagraph}}{1em}{}
\titlespacing*{\paragraph}{0pt}{2pt}{0pt}

%% ---- 图表题注 ----
\DeclareCaptionLabelFormat{jos}{#1#2}          % “图1”，中间无空格
\DeclareCaptionLabelFormat{jostab}{#1\textbf{#2}} % “表1”，编号加粗
\DeclareCaptionFont{josnine}{\josfont{9pt}{12pt}}
\DeclareCaptionFont{jossub}{\josfont{7.5pt}{10pt}}
\DeclareCaptionFont{joshei}{\heiti}
\captionsetup{labelformat=jos,labelsep=quad,font=josnine,
  justification=centering,singlelinecheck=false,skip=4pt}
\captionsetup[figure]{name=图,position=bottom,
  labelfont={},textfont={}}
\captionsetup[table]{name=表,position=top,labelformat=jostab,
  font={josnine,joshei},labelfont={},textfont={}}   % 表题为黑体
\captionsetup[sub]{labelformat=parens,labelsep=space,font=jossub,skip=2pt}
\renewcommand\thesubfigure{\alph{subfigure}}
\renewcommand\thesubtable{\alph{subtable}}

%% 表格内部文字 7.5pt；三线表：顶/底线 1pt，栏目线 0.5pt
\newcommand\tablefont{\songti\josfont{7.5pt}{10pt}}
\AtBeginEnvironment{table}{\tablefont}        % 表格内容自动为 7.5pt
\setlength\heavyrulewidth{1pt}
\setlength\lightrulewidth{0.5pt}
\setlength\cmidrulewidth{0.4pt}

\setlength\floatsep{8pt plus 2pt minus 2pt}
\setlength\textfloatsep{10pt plus 2pt minus 2pt}
\setlength\intextsep{8pt plus 2pt minus 2pt}

%% ---- 定理类环境：标签黑体，正文宋体 ----
\newtheoremstyle{jos}{2pt}{2pt}{\normalfont}{2em}{\heiti}{.}{0.5em}{}
\theoremstyle{jos}
\newtheorem{definition}{定义}
\newtheorem{theorem}{定理}
\newtheorem{lemma}{引理}
\newtheorem{corollary}{推论}
\newtheorem{proposition}{命题}
\newtheorem{example}{例}
\renewenvironment{proof}[1][证明]{\par\noindent\hspace*{2em}{\heiti #1.}\enspace}{\hfill$\square$\par}

%% ---- 列表 ----
\setlist{nosep,leftmargin=*,labelindent=2em}
\setlist[enumerate,1]{label=(\arabic*)}

%% ---- 脚注：7.5pt，首行缩进 ----
\renewcommand\footnoterule{\kern-3pt\hrule width 0.25\columnwidth height 0.4pt\kern 2.6pt}
\renewcommand\@makefntext[1]{%
  \setlength\parindent{1.5em}\noindent\hspace*{1.5em}%
  \hb@xt@ 1em{\hss\@makefnmark}\,#1}

%% ======================================================================
%%  首页信息
%% ======================================================================
\def\jos@title{}\def\jos@authors{}\def\jos@affils{}\def\jos@corr{}
\def\jos@cnabstract{}\def\jos@cnkeywords{}\def\jos@clc{}
\def\jos@cncite{}\def\jos@encite{}
\def\jos@entitle{}\def\jos@enauthors{}\def\jos@enaffils{}
\def\jos@enabstract{}\def\jos@enkeywords{}
\def\jos@fund{}\def\jos@dates{}
\def\jos@headauthor{作者\hspace{0.25em}等}\def\jos@headtitle{}
\def\jos@journalinfo{Vol.32, No.7, July 2021}
\def\jos@doi{10.13328/j.cnki.jos.000000}
\def\jos@startpage{1}

\renewcommand\title[1]{\def\jos@title{#1}}
\renewcommand\author[1]{\def\jos@authors{#1}}
\newcommand\affmark[1]{\textsuperscript{#1}}
\newcommand\affiliation[2]{\g@addto@macro\jos@affils{%
  \par\noindent\hangindent=3.5pt\hangafter=1\textsuperscript{#1}(#2)}}
\newcommand\corresponding[2]{\def\jos@corr{通讯作者: #1, E-mail: \nolinkurl{#2}}}
\newcommand\cnabstract[1]{\def\jos@cnabstract{#1}}
\newcommand\cnkeywords[1]{\def\jos@cnkeywords{#1}}
\newcommand\clc[1]{\def\jos@clc{#1}}
\newcommand\cncitation[1]{\def\jos@cncite{#1}}
\newcommand\encitation[1]{\def\jos@encite{#1}}
\newcommand\entitle[1]{\def\jos@entitle{#1}}
\newcommand\enauthor[1]{\def\jos@enauthors{#1}}
\newcommand\enaffiliation[2]{\g@addto@macro\jos@enaffils{%
  \par\noindent\hangindent=3.3pt\hangafter=1\textsuperscript{#1}(#2)}}
\newcommand\enabstract[1]{\def\jos@enabstract{#1}}
\newcommand\enkeywords[1]{\def\jos@enkeywords{#1}}
\newcommand\fund[1]{\def\jos@fund{#1}}
\newcommand\dates[3]{\def\jos@dates{收稿时间: #1; 修改时间: #2; 采用时间: #3}}
\newcommand\headauthor[1]{\def\jos@headauthor{#1}}   % 例：\headauthor{张三\hspace{0.25em}等}（汉字间直接打空格会被 xeCJK 删除）
\newcommand\headtitle[1]{\def\jos@headtitle{#1}}
\newcommand\journalinfo[1]{\def\jos@journalinfo{#1}}
\def\doi#1{\def\jos@doi{#1}}
\newcommand\startpage[1]{\def\jos@startpage{#1}}
\AtBeginDocument{\setcounter{page}{\jos@startpage}}

%% ---- 作者行字体：整行统一 ----
%% 作者行用仿宋。若姓名中有仿宋字库缺的字（如“喆”），逐字补字会造成一行里字体不一。
%% 这里先检查 \author 中的全部汉字，从下列候选字体中选第一个能显示所有字的，整行都用它：
%% 仿宋（Word 同款仿宋 / 华文仿宋 / 方正仿宋）→ 楷体 → 宋体。也可手动指定：\setjosauthorfont{字体名}
\ExplSyntaxOn
\clist_new:N \g__jos_authorfont_clist
\clist_gset:Nn \g__jos_authorfont_clist
  {
    FangSong, STFangsong, FZFangSong-Z02S, FZFangSong-Z02, FandolFang-Regular.otf,
    KaiTi, Kaiti~SC, STKaiti, FZKai-Z03S, FandolKai-Regular.otf,
    SimSun, Songti~SC, STSong, Noto~Serif~CJK~SC, Source~Han~Serif~SC, FandolSong-Regular.otf
  }
\tl_new:N \g__jos_authorfont_tl
\tl_new:N \l__jos_authorchars_tl
\bool_new:N \g__jos_cover_bool
\NewDocumentCommand \setjosauthorfont { m }
  { \clist_gset:Nn \g__jos_authorfont_clist {#1} }
%% 检查字体 #1 是否包含 #2 中的全部字符
\cs_new_protected:Npn \__jos_font_covers:nn #1#2
  {
    \bool_gset_false:N \g__jos_cover_bool
    \IfFontExistsTF {#1}
      {
        \group_begin:
          \fontspec {#1}
          \bool_gset_true:N \g__jos_cover_bool
          \tl_map_inline:nn {#2}
            { \iffontchar \font `##1 \scan_stop: \else: \bool_gset_false:N \g__jos_cover_bool \fi: }
        \group_end:
      }
      { }
  }
%% 从 \author{...} 中取出汉字（跳过命令、上标编号、标点等）
\cs_new_protected:Npn \__jos_collect_cjk:N #1
  {
    \tl_clear:N \l__jos_authorchars_tl
    \tl_map_inline:Nn #1
      {
        \tl_if_single_token:nT {##1}
          {
            \token_if_cs:NF ##1
              {
                \int_compare:nNnT { `##1 } > { "2E7F }
                  { \tl_put_right:Nn \l__jos_authorchars_tl {##1} }
              }
          }
      }
  }
\cs_new_protected:Npn \__jos_choose_authorfont:
  {
    \__jos_collect_cjk:N \jos@authors
    \tl_gclear:N \g__jos_authorfont_tl
    \tl_if_empty:NF \l__jos_authorchars_tl
      {
        \clist_map_inline:Nn \g__jos_authorfont_clist
          {
            \exp_args:NnV \__jos_font_covers:nn {##1} \l__jos_authorchars_tl
            \bool_if:NT \g__jos_cover_bool
              { \tl_gset:Nn \g__jos_authorfont_tl {##1} \clist_map_break: }
          }
        \tl_if_empty:NTF \g__jos_authorfont_tl
          { \msg_warning:nn { jos } { no-author-font } }
          { \msg_info:nnV { jos } { author-font } \g__jos_authorfont_tl }
      }
  }
\msg_new:nnn { jos } { author-font } { 作者行使用字体:~#1 }
\msg_new:nnn { jos } { no-author-font }
  { 候选字体都不能完整显示作者姓名,作者行将逐字补字.可用~\token_to_str:N \setjosauthorfont {字体名}~手动指定. }
\cs_new_protected:Npn \jos@authorfont
  {
    \cs_if_exist:NT \CJKfontspec
      {
        \__jos_choose_authorfont:
        \tl_if_empty:NF \g__jos_authorfont_tl
          { \exp_args:NV \CJKfontspec \g__jos_authorfont_tl }
      }
  }
\ExplSyntaxOff

%% 灰底引用格式框（Word 中底纹为 F2F2F2）
\definecolor{josgray}{HTML}{F2F2F2}
\newcommand\jos@shadebox[1]{%
  \par\noindent\begingroup\setlength\fboxsep{1.5pt}%
  \colorbox{josgray}{\parbox{\dimexpr\linewidth-2\fboxsep}{#1}}\endgroup\par}

\renewcommand\maketitle{%
  \thispagestyle{josfirst}%
  \begingroup
  \setlength\parindent{0pt}%
  %% 期刊信息块（7.5pt）
  {\josfont{7.5pt}{12pt}%
   软件学报 ISSN 1000-9825, CODEN RUXUEW\hfill E-mail: jos@iscas.ac.cn\par
   \textit{Journal of Software}, [doi: \jos@doi]\hfill http://www.jos.org.cn\par
   \copyright 中国科学院软件研究所版权所有.\hfill Tel: +86-10-62562563\par}
  %% 中文题目 14pt 黑体
  \vspace{16pt}%
  {\raggedright\heiti\josfont{14pt}{20pt}\jos@title
   \ifx\jos@fund\@empty\else\textsuperscript{$\ast$}\fi\par}
  %% 作者 12pt 仿宋，横向压缩
  \vspace{8pt}%
  {\fangsong\jos@authorfont\josfont{12pt}{16pt}\scalebox{0.66}[1]{\jos@authors}\par}
  \vspace{10pt}%
  %% 单位 8pt
  {\songti\josfont{8pt}{12pt}\jos@affils
   \ifx\jos@corr\@empty\else\par\noindent\jos@corr\fi\par}
  \vspace{10pt}%
  %% 中文摘要、关键词：标签黑体，内容楷体 9pt
  {\josfont{9pt}{14.25pt}%
   \noindent{\heiti 摘\hspace{1em}要:}\enspace{\kaishu\jos@cnabstract}\par
   \noindent\hangindent=21.45pt\hangafter=1{\heiti 关键词:}\enspace{\kaishu\jos@cnkeywords}\par}
  \ifx\jos@clc\@empty\else
   \vspace{4pt}{\noindent\josfont{9pt}{14.25pt}{\heiti 中图法分类号:}\enspace\jos@clc\par}%
  \fi
  %% 引用格式（灰底）8pt
  \vspace{8pt}%
  {\songti\josfont{8pt}{12pt}%
   \ifx\jos@cncite\@empty\else\jos@shadebox{中文引用格式: \jos@cncite}\fi
   \vspace{2.85pt}%
   \ifx\jos@encite\@empty\else\jos@shadebox{英文引用格式: \jos@encite}\fi}
  %% 英文题目 10.5pt 加粗
  \vspace{12pt}%
  {\raggedright\bfseries\josfont{10.5pt}{14pt}\jos@entitle\par}
  \vspace{9pt}%
  {\josfont{9pt}{13pt}\jos@enauthors\par}
  \vspace{7pt}%
  {\josfont{7.5pt}{11pt}\jos@enaffils\par}
  %% 英文摘要 7.5pt，行距 11.7pt
  \vspace{7pt}%
  {\josfont{7.5pt}{11.7pt}%
   \noindent\textbf{Abstract}:\enspace\jos@enabstract\par
   \noindent\hangindent=58pt\hangafter=1\textbf{Key words}:\enspace\jos@enkeywords\par}
  \vspace{12pt}%
  \endgroup
  %% 首页脚注：基金项目 + 收稿时间
  \ifx\jos@fund\@empty\else
   \begingroup\renewcommand\thefootnote{$\ast$}%
   \footnotetext{基金项目: \jos@fund
     \ifx\jos@dates\@empty\else\par\hspace*{2.5em}\jos@dates\fi}%
   \endgroup
  \fi
  \setcounter{footnote}{0}%
  \@afterindenttrue
}

%% ======================================================================
%%  页眉页脚
%% ======================================================================
%% 以首页为第 1 页：第 2,4,6… 页为“期刊信息”页眉，第 3,5,7… 页为“作者 等: 题目”页眉
\newcommand\jos@ifjournalside[2]{%
  \ifodd\numexpr\value{page}-\jos@startpage\relax #1\else #2\fi}
\fancypagestyle{josmain}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  %% 页眉 9pt（小五）；中文为楷体，西文为 Times（Journal of Software 斜体）
  \fancyhead[L]{\kaishu\josfont{9pt}{11pt}\jos@ifjournalside
    {\thepage}{\jos@headauthor: \jos@headtitle}}%
  \fancyhead[R]{\kaishu\josfont{9pt}{11pt}\jos@ifjournalside
    {\textit{Journal of Software}~软件学报~\jos@journalinfo}{\thepage}}}
\fancypagestyle{josfirst}{\fancyhf{}\renewcommand\headrulewidth{0pt}}
\pagestyle{josmain}

%% ======================================================================
%%  参考文献
%% ======================================================================
\renewcommand\bibsection{%
  \par\vspace{14pt}\noindent{\heiti\bfseries\josfont{9pt}{14.25pt}References:}\par\vspace{2pt}}
\renewcommand\bibfont{\songti\josfont{7.5pt}{13pt}}
\setlength\bibsep{0pt}
\setlength\bibhang{21pt}
%% 正文中非上标引用，如“文献[5]”：\inlinecite{key}
\newcommand\inlinecite[1]{\begingroup\setcitestyle{numbers,square}\citep{#1}\endgroup}

%% 附中文参考文献：编号与英文 References 中的编号保持一致，需手动给出
\newenvironment{cnreferences}{%
  \par\vspace{12pt}\noindent{\heiti\josfont{9pt}{14.25pt}附中文参考文献:}\par\vspace{2pt}%
  \songti\josfont{7.5pt}{13pt}%
  \begin{list}{}{\settowidth\labelwidth{[99]}\setlength\labelsep{0.5em}%
    \setlength\leftmargin{\dimexpr\labelwidth+\labelsep\relax}%
    \setlength\itemsep{0pt}\setlength\parsep{0pt}\setlength\topsep{0pt}}}
  {\end{list}}
\newcommand\cnbibitem[1]{\item[{[#1]}]}

%% ======================================================================
%%  作者简介（文末，每行两人：照片 + 简介）
%% ======================================================================
\newcounter{jos@bio}
%% 版式取自 Word：每行两人，照片栏 20.2mm（照片约 17mm x 22mm，居中）+ 文字栏 51.6mm（左右各留 1.5mm），
%% 两人之间空 7.7mm，整表宽 151.4mm 居中；文字 7.5pt（六号）宋体，姓名黑体，行距最小 12pt
\newenvironment{biographies}{%
  \par\vspace{12pt}\setcounter{jos@bio}{0}%
  \begingroup\raggedright\setlength\parindent{0pt}%
  \let\par\relax   % 作者之间的空行不打断排版；换行由 \bio 自己控制
  \ignorespaces}
  {\@@par\endgroup\par}
%% 用法：\bio{照片文件}{姓名}{(1983-),男,博士,...}   姓名自动为黑体
%%   或：\bio{照片文件}{整段简介}                    （兼容旧写法，不单独处理姓名）
%% 不用 xparse 的 g 型参数（新版 LaTeX 中需额外加载 xparse），这里自己判断后面是否还有一个 {…}
\ExplSyntaxOn
\cs_new_protected:Npn \bio #1#2
  {
    \peek_catcode_ignore_spaces:NTF \c_group_begin_token
      { \__jos_bio:nnn {#1} {#2} }
      { \__jos_bio:nnn {#1} { } {#2} }
  }
\cs_new_protected:Npn \__jos_bio:nnn #1#2#3
  {
    \stepcounter{jos@bio}
    % 每行第一人从固定位置开始（使 151.4mm 宽的整组在版心居中）；第二人与第一人相隔 7.7mm
    % 作者数为单数时，最后一人自然排在左栏
    \int_if_odd:nTF { \value{jos@bio} }
      { \noindent \hspace*{ \dim_eval:n { ( \linewidth - 151.4mm ) / 2 } } }
      { \hspace{7.7mm} }
    \begin{minipage}[t]{20.2mm} \vspace{0pt} \centering
      \includegraphics[width=17mm,height=22mm,keepaspectratio=false]{#1}
    \end{minipage}
    \begin{minipage}[t]{51.6mm} \vspace{0pt}
      \hspace*{1.5mm}
      \begin{minipage}[t]{48.6mm} \vspace{0pt}
        % 文字两端对齐
        \leftskip=0pt \rightskip=0pt \parfillskip=0pt~plus~1fil \scan_stop:
        \songti \josfont{7.5pt}{12pt}
        \tl_if_blank:nF {#2} { { \heiti #2 } } #3 \par
      \end{minipage}
    \end{minipage}
    \int_if_odd:nF { \value{jos@bio} } { \tex_par:D \vspace{2mm} }
    \ignorespaces
  }
\ExplSyntaxOff

\endinput