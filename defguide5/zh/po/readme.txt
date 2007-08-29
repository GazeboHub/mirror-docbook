*) Check
    msgfmt --statistics -c zh_CN.po

*) Format
    msgmerge --no-wrap -o zh_CN-new.po zh_CN.po defguide5.pot
    mv -f zh_CN-new.po zh_CN.po

    msgmerge --no-wrap -o Tortoise_zh_CN-new.po Tortoise_zh_CN.po Tortoise.pot
    mv -f Tortoise_zh_CN-new.po Tortoise_zh_CN.po

    msgmerge --no-wrap -o TortoiseSVN_zh_CN-new.po TortoiseSVN_zh_CN.po TortoiseSVN.pot
    mv -f TortoiseSVN_zh_CN-new.po TortoiseSVN_zh_CN.po

    msgmerge --no-wrap -o TortoiseMerge_zh_CN-new.po TortoiseMerge_zh_CN.po TortoiseMerge.pot
    mv -f TortoiseMerge_zh_CN-new.po TortoiseMerge_zh_CN.po

*) Merge
    subversion/tools/dev/po-merge.py zh_CN.po < zh_CN-other.po
    msgmerge --no-wrap -o zh_CN-new.po zh_CN.po example.pot
    mv -f zh_CN-new.po zh_CN.po

    or

    pomerge -i zh_CN-other.po -o zh_CN-new.po -t zh_CN.po
    msgmerge --no-wrap -o zh_CN-new.po zh_CN.po example.pot
    mv -f zh_CN-new.po zh_CN.po

*) Commit

    Simplified Chinese defguide5 translation:
    * Update to r10315 of defguide5.pot

    Simplified Chinese gui translation:
    * Update to r10315 of TortoiseSVN.pot

    Simplified Chinese doc translation:
    * Update to r10265 of TortoiseSVN.pot
    * Update to r10308 of TortoiseMerge.pot

    ------------------------------------------------------------------------
    Follow-up to r25007, adding or improving a few comments.

    Suggested by: kfogel, joeswatosh

    * subversion/include/svn_client.h
      (svn_client_proplist3): Explain what happens in the svn_depth_unknown case.

    * subversion/libsvn_client/prop_commands.c
      (svn_client_proplist3): Explain initialization of adm_depth.
      (svn_client_proplist2): Explain why we need to convert recurse to depth
       manually, instead of using SVN_DEPTH_TO_RECURSE.
    ------------------------------------------------------------------------
    * www/svn_1.5_releasenotes.html
      Add link to Malcolm's blog post about FSFS sharding.
    ------------------------------------------------------------------------
