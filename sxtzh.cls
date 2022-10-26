\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sxtzh}
\LoadClass[no-math]{ctexart}
\RequirePackage{amssymb,enumitem}
\RequirePackage[b]{esvect}%esvect是向量宏包}
\RequirePackage[dvipsnames]{xcolor}
\definecolor{mycolor1}{RGB}{16,125,178}
\definecolor{mycolor2}{RGB}{5,119,72}
\RequirePackage[left=2cm,right=2cm,top=3cm,bottom=3cm]{geometry}
\RequirePackage[pagestyles]{titlesec}
\RequirePackage{unicode-math}%更改数学公式字体需要的宏包
\setmainfont{TeX Gyre Termes}
% \setmathfont{TeX Gyre Termes Math}
% \setmathfont{STIX Two Math}%免费可以商用,常用
% \setmathfont{XITS Math}%免费可以商用,  家里编译后\triangle 有问题
% \setmathfont{TeX Gyre Schola Math}%免费可以商用
% \setmathfont{TeX Gyre Pagella Math}%免费可以商用
% \setmathfont{OriSerif}%将数学公式字体更改为OriSerif Math 需要提前安装 记得右键为所有用户安装
% \setmathfont{Asana Math} %免费可以商用
% \setmathfont{TeX Gyre Termes}%免费可以商用
% \setmathfont{TeX Gyre Termes Math}%免费可以商用
\setmathfont{Cambria Math}
\RequirePackage{circledsteps}
\RequirePackage{tkz-euclide}
\RequirePackage{mathtools}
% \RequirePackage{unimath-symbols}
\usetikzlibrary{arrows.meta,calc,intersections}
\tikzset{global scale/.style={
    scale=#1,
    every node/.append style={scale=#1}
   }} 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%20220906解决了页脚样式，题源命令，解答后分割线，教师版、学生版总页数问题
%20220908解决了学生版命令后，题目后有分割线
% 设置行间距
\AtBeginDocument{
  \lineskiplimit=4pt
  \lineskip=5pt
}

\ExplSyntaxOn
\seq_new:N \my_seq_xsb_jianda
\seq_new:N \my_seq_xsb_xiangda
\int_new:N \my_int
\int_set:Nn \my_int{1}
\tl_new:N \c_teacher_xiangda
\tl_set:Nn \c_teacher_xiangda{教师版详答}
\tl_new:N \c_teacher_jianda
\tl_set:Nn \c_teacher_jianda{教师版简答}
\tl_new:N \c_student_xiangda
\tl_set:Nn \c_student_xiangda{学生版详答}
\tl_new:N \c_student_jianda
\tl_set:Nn \c_student_jianda{学生版简答}
\tl_new:N \g_tzhmode_tl

\cs_gset:Npn \tzh_mode_cs:n #1{
  \tl_set:Nn \g_tzhmode_tl{#1}}
% 答案命令改成 \tzhshowanswer 
\cs_set_eq:NN \tzhshowanswer \tzh_mode_cs:n

\NewDocumentCommand{\hezi}{ m O{white} O{Orange}}{\colorbox{#3}{\textbf{\textcolor{#2}{#1}}}}% 创建一个盒子命令

%列表环境设置
\RequirePackage{enumitem}
\setlist[enumerate,1]{label={$\arabic*$.},itemsep=0pt,partopsep=0pt,topsep=0pt} %在\begin{enumerate}[resume] resume将按照上一enumerate环境继续计数
\setlist[enumerate,2]{label=($\arabic*$),itemsep=0pt,partopsep=0pt,topsep=0pt}
\setlist[enumerate,3]{label=\Circled{$\arabic*$},itemsep=0pt,partopsep=0pt,topsep=0pt}

%创建解答环境
\NewDocumentEnvironment{solution}{s +b} %\begin{solution}*    \end{solution}       \begin{solution}         \end{solution}
{
  \tl_if_eq:NNTF \g_tzhmode_tl \c_teacher_xiangda
  {
    \par
    \IfBooleanTF{#1}
    {
      \hezi{\heiti \CJKfontspec{STXinwei}证明}[white][mycolor1] ~\kaishu #2
    }
    {
      \hezi{\heiti \CJKfontspec{STXinwei}解析}[white][mycolor1] ~\kaishu #2
    }
  }{}
  \seq_gput_right:Nn \my_seq_xsb_xiangda{#2 \par}
}
{
  \tl_if_eq:NNT \g_tzhmode_tl \c_teacher_xiangda
  {
    \par
    \hfill
    \tikz{
    \fill[color=mycolor1] (0,0) rectangle (6pt,6pt);
    \draw[color=mycolor1] (-0.75\linewidth,0)--(6pt,0);
  }
  }
%读取教师版详答最后一页的命令，需要编译两次XeLaTeX
  \iow_open:Nn \l_lastpage_file{\c_sys_jobname_str.page}
  \iow_now:Nx \l_lastpage_file 
  {
  \cs_set:Npn \exp_not:N \lastpage 
  {
    \thepage
  }
  }
  \iow_close:N \l_lastpage_file 
}


%弃用环境的答案命令
% \NewDocumentEnvironment{daan}{o +b}
% {
%   \tl_if_eq:NNTF \g_tzhmode_tl \c_printer_mode_tl
%   {
%     \IfNoValueTF{#1}{\hezi{答案:}[white][teal]~#2 \par }{\hezi{答案:}[white][teal]~#2 \hspace{1cm} \hezi{题目来源:}[white][CadetBlue]~#1 \par }
%   }
%   {
%     \tl_if_eq:NNT \g_tzhmode_tl \c_teacher_mode_tl
%     {
%       \IfNoValueTF{#1}{\hezi{答案:}[white][teal]~#2 \par }{\hezi{答案:}[white][teal]~#2 \hspace{1cm} \hezi{题目来源:}[white][CadetBlue]~#1 \par }
%     }
%   }
% }
% {}

%创建答案命令
\NewDocumentCommand{\daan}{+m}{
  \par
  \tl_if_eq:NNTF \g_tzhmode_tl \c_teacher_jianda
  {
    \hezi{ \CJKfontspec{STXinwei}答案 }[white][teal]~{\kaishu #1}
  }
  {
    \tl_if_eq:NNT \g_tzhmode_tl \c_teacher_xiangda
  {
    \hezi{ \CJKfontspec{STXinwei}答案 }[white][teal]~{\kaishu #1}
  }
  }
  \seq_gput_right:Nn \my_seq_xsb_jianda{#1}
}
%创建题源命令
\NewDocumentCommand{\tiyuan}{+m}
{
    \tl_if_eq:NNTF \g_tzhmode_tl \c_teacher_jianda
    {
       \ignorespace \textcolor{mycolor1}{【{\CJKfontspec{STXinwei}#1}】}
    }
    {
        \tl_if_eq:NNT \g_tzhmode_tl \c_teacher_xiangda
        {\textcolor{mycolor1}{【{\CJKfontspec{STXinwei}#1}】}}
    }
}
%创建选项命令
\cs_new_protected:Npn \tzh_xx: #1#2#3#4{
  \par\hspace{0em}
%把四个选项加上ABCD标签放进四个选项盒子
    \box_clear_new:N \l__choiceA_box
    \box_clear_new:N \l__choiceB_box
    \box_clear_new:N \l__choiceC_box
    \box_clear_new:N \l__choiceD_box
    \hbox_set:Nn \l__choiceA_box {A.#1\;\;}
    \hbox_set:Nn \l__choiceB_box {B.#2\;\;}
    \hbox_set:Nn \l__choiceC_box {C.#3\;\;}
    \hbox_set:Nn \l__choiceD_box {D.#4\;\;}
%计算四个选项中最长的那个
  \dim_zero_new:N \l__max_choice_length_d
  \dim_zero_new:N \l__max_length_AB_d
  \dim_zero_new:N \l__max_length_CD_d
  \dim_set:Nn \l__max_length_AB_d {\dim_max:nn {\box_wd:N \l__choiceA_box} {\box_wd:N \l__choiceB_box}}
  \dim_set:Nn \l__max_length_CD_d {\dim_max:nn {\box_wd:N \l__choiceC_box} {\box_wd:N \l__choiceD_box}}
  \dim_set:Nn \l__max_choice_length_d {\dim_max:nn {\dim_use:N \l__max_length_AB_d}{\dim_use:N \l__max_length_CD_d}}
%比较最长选项与四分之一行长度(一行四个),半行长度(一行两个),一行一个
    \dim_compare:nNnTF {\dim_use:N \l__max_choice_length_d} < {.25\linewidth}
    {%一行四个
    \box_set_wd:Nn \l__choiceA_box {.25\linewidth}
    \box_set_wd:Nn \l__choiceB_box {.25\linewidth}
    \box_set_wd:Nn \l__choiceC_box {.25\linewidth}
    \box_set_wd:Nn \l__choiceD_box {.25\linewidth}
    
    \box_use:N \l__choiceA_box
    \box_use:N \l__choiceB_box
    \box_use:N \l__choiceC_box
    \box_use:N \l__choiceD_box
        
    }
    {
        \dim_compare:nNnTF {\dim_use:N \l__max_choice_length_d} < {.5\linewidth}
        {%一行两个
      \box_set_wd:Nn \l__choiceA_box {.5\linewidth}
      \box_set_wd:Nn \l__choiceB_box {.5\linewidth}
      \box_set_wd:Nn \l__choiceC_box {.5\linewidth}
      \box_set_wd:Nn \l__choiceD_box {.5\linewidth}
      
      \box_use:N \l__choiceA_box
      \box_use:N \l__choiceB_box
      \par\hspace{0em}
      \box_use:N \l__choiceC_box
      \box_use:N \l__choiceD_box
            
        }
        {%一行一个
      \box_set_wd:Nn \l__choiceA_box {.5\linewidth}
      \box_set_wd:Nn \l__choiceB_box {.5\linewidth}
      \box_set_wd:Nn \l__choiceC_box {.5\linewidth}
      \box_set_wd:Nn \l__choiceD_box {.5\linewidth}
      
      \box_use:N \l__choiceA_box
      \par\hspace{0em}
      \box_use:N \l__choiceB_box
      \par\hspace{0em}
      \box_use:N \l__choiceC_box
      \par\hspace{0em}
      \box_use:N \l__choiceD_box
        }
    }
  
}
\cs_set_eq:NN \xx \tzh_xx:
%读取最后一页的命令，需要编译两次XeLaTeX
\iow_new:N \l_lastpage_file 
\file_if_exist:nTF{\c_sys_jobname_str.page}
{
  \file_input:n{\c_sys_jobname_str.page}
}
{
  \cs_set_eq:NN \lastpage \relax
}
%学生版详答与简答的输出
\AtEndDocument
{
  \newpage
  \def\xsbxd{
    \int_step_inline:nnn{1}{\seq_count:N \my_seq_xsb_xiangda}
    {
      \noindent \hezi{\int_use:N \my_int}~
      \seq_item:Nn \my_seq_xsb_jianda{##1}\par
      \noindent \seq_item:Nn \my_seq_xsb_xiangda{##1}\par
      \int_incr:N \my_int
    }
  }
  \def\xsbjd{
    \int_step_inline:nnn{1}{\seq_count:N \my_seq_xsb_xiangda}
    {
      \noindent \hezi{\int_use:N \my_int}~
      \seq_item:Nn \my_seq_xsb_jianda{##1}~
      \int_incr:N \my_int
    }
  }
%\newpage
  \tl_if_eq:NNTF \g_tzhmode_tl  \c_student_jianda
  {
    \begin{center}
      \Large {\CJKfontspec{STZhongsong}{答案}}
    \end{center}
    \xsbjd
%读取学生版简答最后一页的命令，需要编译两次XeLaTeX
    \iow_open:Nn \l_lastpage_file{\c_sys_jobname_str.page}
    \iow_now:Nx \l_lastpage_file 
    {
    \cs_set:Npn \exp_not:N \lastpage 
    {
      \thepage
    }
    }
    \iow_close:N \l_lastpage_file 
  }
  {
    \tl_if_eq:NNT \g_tzhmode_tl \c_student_xiangda
    {
      \begin{center}
        \Large {\CJKfontspec{STZhongsong}{答案}}
      \end{center}
      \xsbxd
%读取学生版详答最后一页的命令，需要编译两次XeLaTeX
     \iow_open:Nn \l_lastpage_file{\c_sys_jobname_str.page}
     \iow_now:Nx \l_lastpage_file 
     {
     \cs_set:Npn \exp_not:N \lastpage 
     {
       \thepage
     }
     }
     \iow_close:N \l_lastpage_file 
  } 
}
}
\ExplSyntaxOff
%设置页脚
\RequirePackage{xfrac}
\newpagestyle{yemianshezhi}
{
  \headrule
  \setfoot{}{\LARGE {\color{mycolor2}\sfrac{$\thepage$}{\color{mycolor1}$\lastpage$}}}{}
}
\pagestyle{yemianshezhi}
%页脚的另一种设置方式
% \RequirePackage{fancyhdr}
% \RequirePackage{xfrac}
% \pagestyle{fancy}
% \cfoot{\LARGE {\color{mycolor2}\sfrac{$\thepage$}{\textcolor{mycolor1}{$\lastpage$}}}}
% \renewcommand{\headrulewidth}{0pt}

% \newpagestyle{yejiao}
% {
%   \setfoot{}{\bf 第\thepage 页 (共~\lastpage~页)}{}
% }
% \pagestyle{yejiao}

%单选、填空、解答
\newcommand{\danxuan}{\noindent {\bf 一、 选择题：本大题共12小题，每小题5分。在每小题给出的四个选项中，只有一项是符合题目要求的。}\par}

\newcommand{\tiankong}{{\noindent\bf 二、 填空题：本大题共4小题，每小题5分。}\par}

\newcommand{\jieda}{{\noindent\bf 三、 解答题：本大题共6小题，第一小题10分，其余均为12分，解答应写出文字说明、证明过程或演算步骤。}\par}

%方法
\newcounter{ff}[enumi]
\newenvironment{fangfa}[1][]
    {\par {\bf \textcolor{red}{{\CJKfontspec{STXinwei}方法 }\hspace{0.1pt}{$\refstepcounter{ff} \theff$}} #1}\par }{}
