# uAssets

This repository is for the resources of [uBlock Origin (uBO)](https://github.com/gorhill/uBlock). It receives all reports for new filters or existing filters that cause web page breakage. Any contributors are welcome. Contributors who are proven valuable will receive write permissions to the project.

The rationale for including a specific filter in uBO's filter lists is the same as the [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html) + [here](https://github.com/easylist/easylist#readme) and also takes into account whether a filter requires uBO's extended filter syntax.

It is preferred to fix filter issues in EasyList. Any filters included in uBO's filter lists must use the [extended syntax](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#extended-syntax).

The following exceptions will be fixed in uAssets even if they do not require using the extended syntax:

- Ad-Reinsertion
- Anti-Blocker
- Context Menu/Dev Console Blockage
- Cut/Copy/Paste/Drag Blockage
- Popups/Popunders
- Website Breakage
- Resource Abuse/Coin Mining
- Video/Audio Ads

The EasyList-compatible fixes for high-traffic websites need to be added to uBO filters until they become added to EasyList.

#### Support Forum

For support, questions, or help, visit [/r/uBlockOrigin](https://www.reddit.com/r/uBlockOrigin/).

#### uBO Issues

Report any issues with uBO in the [uBO issue tracker](https://github.com/uBlockOrigin/uBlock-issues/issues).

#### uBO Lite (uBOL) Issues

Report issues specific to the Chromium Manifest Version 3 (MV3) variant in the [uBOL issue tracker](https://github.com/uBlockOrigin/uBOL-issues/issues).

#### uBO Legacy Issues

Report issues specific to the legacy variant in the [uBO Legacy issue tracker](https://github.com/gorhill/uBlock-for-firefox-legacy/issues).

#### Paywall

Circumventing a paywall is considered [out of scope](https://github.com/uBlockOrigin/uAssets/issues/2317#issuecomment-392009540).

#### GDPR Modals

[uAssets](https://github.com/uBlockOrigin/uAssets/issues/4123#issuecomment-439232886) will not address GDPR modals.

#### Porn Farms

Websites found to be porn farms (families of mass-produced porn websites without original content) or are part of a porn farm will not be addressed in uAssets.

#### Similarly-Purposed Blockers

Do **NOT** use uBO along with other [similarly-purposed blockers](https://twitter.com/gorhill/status/1033706103782170625); this can result in website breakage or undefined results.
