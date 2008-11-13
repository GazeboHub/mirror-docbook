//
// asciidoc -a toc -a toclevels=3 -a numbered 00_readme_first.txt
//

= 翻译 DocBook4 文档的方法

== docbook 的开发资源
 * http://docbook.org/
 * http://docbook.sourceforge.net/
 * http://sourceforge.net/projects/docbook/

 * http://docbook.svn.sourceforge.net/svnroot/docbook/[DocBook SVN]

 * http://www.sagehill.net/docbookxsl/[DocBook XSL: The Complete Guide]

== defguide 的翻译方法

=== 更新 po 文件
----------------------------------------------------------------
    msgmerge --width=80 --sort-by-file -o zh_CN_new.po zh_CN.po defguide.pot
    mv -f zh_CN_new.po zh_CN.po
----------------------------------------------------------------

=== 翻译 po 文件
使用 poedit 或 KBabel，甚至普通文本编辑器。

=== 查阅上下文
如果翻译时不能确定语义环境，那么请运行 ant pot，则对应的条目有其在
source/defguide.xml 中的位置，例如：

----------------------------------------------------------------
    #. (para)
    #: ../source/defguide.xml:8360
    msgid "Add new elements"
    msgstr "增加元素"
----------------------------------------------------------------

    打开 source/defguide.xml，定位到 8360 行即可。

=== 格式化 po 文件

统一采用 80 列宽，按照文件位置排序的 gettext 翻译格式，请在提交之前先格式化
po 文件。

gettext 的 Windows 平台二进制包可以从 i18n-zh 下载。
----------------------------------------------------------------
    msgcat --width=80 --sort-by-file -o zh_CN_new.po zh_CN.po
    mv -f zh_CN_new.po zh_CN.po
----------------------------------------------------------------

=== 合并 po 文件
如果合作者有约定协作翻译的方法，请略过本节。

下面的例子是以他人的翻译(zh_CN-other.po)为准合并。如果需要以自己的翻译(zh_CN.po)
为准合并，交换下述命令中的 zh_CN.po 和 zh_CN-other.po 即可。

==== 使用 Subversion 的 po-merge.py
----------------------------------------------------------------
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po
----------------------------------------------------------------

==== 使用 translation tookit 的 pomerge
----------------------------------------------------------------
    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po
----------------------------------------------------------------

=== 检查 po 文件
----------------------------------------------------------------
    msgfmt --statistics -c zh_CN.po
----------------------------------------------------------------

== defguide 的构建方法
=== 安装软件包
在 Debian 系统中，安装方法如下：
----------------------------------------------------------------
% sudo apt-get install openjdk-6-jdk ant ant-optional libbsf-java bsh \
    libsaxon-java docbook-xml docbook-xsl python-libxml2 gettext
----------------------------------------------------------------
对于其它系统，请参考 Debian 系统的安装方法。

此外，还需要手工安装 docbook 5.0 和 RELAX NG Support(jing)，配置 ant
支持 BeanShell 脚本。如果要生成 pdf，还需要安装中文字体，以及 fop trunk
2008-09-25(r698670) 以上版本。

=== 配置构建环境
请根据 build.properties.tmpl 创建 build.properties：
----------------------------------------------------------------
docbook5.home ----- docbook 5.0 安装的根目录
docbook5.xsl ------ docbook-xsl 安装的根目录(e.g. /usr/share/xml/docbook/stylesheet/nwalsh)
usr.share.java ---- 存放共享 jar 文件的目录(e.g. /usr/share/java)
----------------------------------------------------------------

=== 配置 xml catalog
在 Debian 系统中，直接复制 CatalogManager.properties.tmpl
为 CatalogManager.properties，放到 ${usr.share.java} 目录即可。
对于其它系统，可能需要少许修改。
----------------------------------------------------------------
catalogs=/etc/xml/catalog
relative-catalogs=true
static-catalog=yes
catalog-class-name=org.apache.xml.resolver.Resolver
verbosity=1
----------------------------------------------------------------

=== 配置构建环境
然后就可以构建 html 或 pdf 输出格式的文档了：
----------------------------------------------------------------
Building 'The Definitive Guide' - html
    $ ant html

Building 'The Definitive Guide' - pdf
    $ ant pdf
----------------------------------------------------------------
请付出耐心，因为在 Intel Xeon 2.00GHz 的主机上，完全构建 html
需要近 100 分钟，完全构建 pdf 需要近 80 分钟。

祝你好运！
