1. Check
    msgfmt --statistics -c zh_CN.po

2. Format
    msgmerge --no-wrap -o zh_CN-new.po zh_CN.po defguide5.pot
    mv -f zh_CN-new.po zh_CN.po

    msgmerge --no-wrap -o Tortoise_zh_CN-new.po Tortoise_zh_CN.po Tortoise.pot
    mv -f Tortoise_zh_CN-new.po Tortoise_zh_CN.po

    msgmerge --no-wrap -o TortoiseSVN_zh_CN-new.po TortoiseSVN_zh_CN.po TortoiseSVN.pot
    mv -f TortoiseSVN_zh_CN-new.po TortoiseSVN_zh_CN.po

    msgmerge --no-wrap -o TortoiseMerge_zh_CN-new.po TortoiseMerge_zh_CN.po TortoiseMerge.pot
    mv -f TortoiseMerge_zh_CN-new.po TortoiseMerge_zh_CN.po

3. Merge
    msgmerge -o zh_CN-new.po zh_CN-other.po zh_CN.po
    mv -f zh_CN-new.po zh_CN.po

4. Commit
    Update Simplified Chinese translation:
    * Tortoise_zh_CN.po: Update to Tortoise.pot@r9532.
    * TortoiseSVN_zh_CN.po: Translate some new/fuzzy messages.

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
