Resource
--------
    https://docbook.org
    https://docbook.sourceforge.net
    https://sourceforge.net/projects/docbook

    https://docbook.svn.sourceforge.net/svnroot/docbook/trunk


Update
------
    #msgmerge --no-wrap --sort-by-file --update zh.po defguide5.pot
    #msgmerge --width=80 --sort-by-file -o zh_new.po zh.po defguide5.pot

    msgmerge --update zh.po defguide5.pot


Check
-----
    msgfmt --statistics -c -o zh.mo zh.po
    msgfmt --statistics -c --check-accelerators -o Tortoise_zh.mo Tortoise_zh.po


Format
------
    msgcat --width=80 --sort-by-file -o zh_new.po zh.po
    mv -f zh_new.po zh.po


Merge
-----

Using po-merge.py from subversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    subversion/tools/dev/po-merge.py zh.po < zh-other.po

Using pomerge from translation tookit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    pomerge -i zh-other.po -o zh-new.po -t zh.po


Commit
------

--------------------------------------
Simplified Chinese translation.
* defguide5/zh/po/defguide5.pot
  Regenerate in Linux box, LC_ALL=en_US.utf8.

* defguide5/zh/po/zh.po
  Translate & review all messages.
--------------------------------------
