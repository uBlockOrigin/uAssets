# uAssets

This repository is dedicated to the resources for [uBlock Origin (uBO)](https://github.com/gorhill/uBlock). It serves as a hub for reporting new filters or existing filters that may cause webpage breakage. Contributions are welcome, and valuable contributors may be granted write permissions to the repository.

## Filter Inclusion Rationale

The rationale for including specific filters in uBO's filter lists aligns with the [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html) and considers whether a filter requires uBO's extended filter syntax. 

It is preferred to address filter issues in EasyList first. Any filters included in uBO's filter lists must utilize the [extended syntax](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#extended-syntax).

High-traffic websites will have EasyList-compatible fixes added to uBO filters until they are incorporated into EasyList.

## Exceptions Handled by uAssets

uAssets will address the following exceptions even if they do not require the extended syntax:

- Ad-Reinsertion
- Anti-Blocker
- Context Menu/Dev Console Blockage
- Cut/Copy/Paste/Drag Blockage
- Popups/Popunders
- Website Breakage
- Video Ads

### Exclusions

uAssets will **not** address the following:

- Paywalls
- Porn Farms

## Reporting an Issue

To report an issue correctly:

1. Disable all other browser extensions to see if the problem persists.
2. If the issue continues:
   - On the problematic website, click the uBlock Origin icon.
   - Click the chat icon.
   - Click "Troubleshooting Information" to expand, and copy that information into the relevant GitHub issue.

## Support Forum

For support, questions, or assistance, visit [/r/uBlockOrigin](https://www.reddit.com/r/uBlockOrigin/).

## uBO Issues

For issues related to uBO, please report them in the [uBO issue tracker](https://github.com/uBlockOrigin/uBlock-issues/issues).

## uBO Lite (uBOL) Issues

For issues specific to the Manifest Version 3 (MV3) variant, report them in the [uBOL issue tracker](https://github.com/uBlockOrigin/uBOL-home/issues).

## Concurrent Blockers

Do **NOT** use any other [similarly-purposed blockers](https://x.com/gorhill/status/1033706103782170625) concurrently with uBO, as this may lead to website breakage or unpredictable results.
