Check
-----
    msgfmt --statistics -c zh_CN.po


Format
------
    msgmerge --no-wrap --update zh_CN.po defguide5.pot

    msgmerge --sort-by-file --update zh_CN.po subversion.pot
    "Last-Translator: Subversion Developers <dev@subversion.tigris.org>\n"
    "Language-Team: Simplified Chinese <dev@subversion.tigris.org>\n"

    msgmerge --no-wrap --update Tortoise_zh_CN.po Tortoise.pot

    msgmerge --no-wrap --update TortoiseSVN_zh_CN.po TortoiseSVN.pot

    msgmerge --no-wrap --update TortoiseMerge_zh_CN.po TortoiseMerge.pot


Merge
-----

Using po-merge.py from subversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po
    msgmerge --no-wrap --update zh_CN.po example.pot

Using pomerge from translation tookit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po
    msgmerge --no-wrap --update zh_CN.po example.pot


Commit
------

docbook
~~~~~~~
--------------------------------------
Simplified Chinese translation.
* defguide5/zh/po/defguide5.pot
  Regenerate in Linux box, LC_ALL=en_US.utf8.

* defguide5/zh/po/zh_CN.po
  Translate & review all messages.
--------------------------------------

subversion
~~~~~~~~~~
--------------------------------------
Simplified Chinese translation.
* subversion/po/zh_CN.po
  Translate new messages of subversion.pot@r26412.
--------------------------------------

TortoiseSVN GUI
~~~~~~~~~~~~~~~
--------------------------------------
Simplified Chinese GUI translation.
* Languages/Tortoise_zh_CN.po
  Update to r10455 of Tortoise.pot.
--------------------------------------

TortoiseSVN
~~~~~~~~~~~
--------------------------------------
Simplified Chinese DOC translation.
* doc/po/TortoiseSVN_zh_CN.po
  Translate some messages of TortoiseSVN.pot@r10472.
--------------------------------------

TortoiseMerge
~~~~~~~~~~~~~
--------------------------------------
Simplified Chinese DOC translation.
* doc/po/TortoiseMerge_zh_CN.po
  Update to r10471 of TortoiseMerge.pot.
--------------------------------------
