#### Filter lists

##### Ordering of filters

New filter must be added at the end of the list.

The reason is to provide an easy way to check whether a filter is still relevant. The filters at the top of the file will be the oldest filters, and also the most likely to maybe be obsolete.

Old filters which are confirmed to still be required must be moved to the end of the list.

##### Issue number association

**All** added filters must be associated with a formal issue number, example:

    ! https://github.com/uBlockOrigin/uAssets/issues/2
    ||data.inertanceretinallaurel.com^

This way this documents why a filter was added, and how to verify whether an old filter is still needed. The comment line preceding the filter(s) to solve a specific issue should be only a URL to the issue. The issue itself can contains all the details about how the issue was solved, and why it was solved this way, etc.

##### Commit message

Keep it simple, example: `this fixes #2`. The issue itself will contains all the details.
