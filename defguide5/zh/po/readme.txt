1. Check
    msgfmt --statistics -c zh_CN.po

2. Format
    msgmerge --no-wrap -o zh_CN.po.new zh_CN.po defguide5.pot
    mv -f zh_CN.po.new zh_CN.po

3. Merge
    msgmerge -o zh_CN-new.po zh_CN-other.po zh_CN.po
    mv -f zh_CN-new.po zh_CN.po

4. Commit
    Update Simplified Chinese translation:
    * Tortoise_zh_CN.po: Update to Tortoise.pot@r9488.
    * TortoiseSVN_zh_CN.po: Update some new/fuzzy messages.

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
