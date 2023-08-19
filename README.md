# uAssets

This repository is for the resources of [uBlock Origin (uBO)](https://github.com/gorhill/uBlock). It receives all reports for new filters or existing filters that cause web page breakage. Any contributors are welcome. Contributors who are proven valuable will get write permissions to the repository.

The rationale for including a specific filter in uBO's filter lists is the same as the [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html) and also takes into account whether a filter requires uBO's extended filter syntax.

It is preferred to fix filter issues in EasyList. Any filters included in uBO's filter lists must use the [extended syntax](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#extended-syntax).

The EasyList-compatible fixes for high-traffic websites are added to uBO filters until they become added to EasyList.

uAssets will fix the following exceptions even if they do not require using the extended syntax:

- Ad-Reinsertion
- Anti-Blocker
- Context Menu Blockage
- Cut/Copy/Paste Blockage
- Popups/Popunders
- Website Breakage
- Video Ads

uAssets will not address the following:

- Paywalls
- Porn Farms

#### Support Forum

For support, questions, or help, visit [/r/uBlockOrigin](https://www.reddit.com/r/uBlockOrigin/).

#### uBO Issues

Report issues with uBO in the [uBO issue tracker](https://github.com/uBlockOrigin/uBlock-issues/issues).

#### uBO Lite (uBOL) Issues

Report issues specific to the Manifest Version 3 (MV3) variant in the [uBOL issue tracker](https://github.com/uBlockOrigin/uBOL-home/issues).

#### Similarly-Purposed Blockers

Do **NOT** use any other [similarly-purposed blockers](https://twitter.com/gorhill/status/1033706103782170625) concurrently with uBO. It can result in website breakage or undefined results.
