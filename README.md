# uAssets

This repository is for the resources of [uBlock Origin (uBO)](https://github.com/gorhill/uBlock). It receives all reports for new filters or existing filters that cause web page breakage. Any contributors are welcome. Contributors who are proven valuable will get write permissions to the repository.

The rationale for including a specific filter in uBO's filter lists is the same as the [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html) and also takes into account whether a filter requires uBO's extended filter syntax.

It is preferred to fix filter issues in EasyList. Any filters included in uBO's filter lists must use the [extended syntax](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#extended-syntax).

The EasyList-compatible fixes for high-traffic websites are added to uBO filters until they become added to EasyList.

#### uAssets will fix the following exceptions even if they do not require using the extended syntax:

- Ad-Reinsertion
- Anti-Blocker
- Context Menu Blockage
- Cut/Copy/Paste Blockage
- Popups/Popunders
- Website Breakage
- Video Ads

#### uAssets will not address the following:

- Paywalls
- Porn Farms
- Annoyances (widgets, social media buttons, newsletter subscriptions, donation requests, etc)

#### How to correctly report an issue:

- Disable all other browser extensions and see if the issue still occurs

- If the issue still occurs when all other browser extensions are disabled, then provide the troubleshooting information:

  * Steps for uBO:  
  
    1. Open a new browser tab
    2. Go to the specific page where the issue occurs
    3. Click the 🛡️ uBO icon
    4. Click the 💬 chat icon
    5. Click `Troubleshooting Information`
    6. Click `Select all` and copy the contents
    7. Paste the contents into the appropriate GitHub thread

  * Steps for uBO Lite:  

    1. Open a new browser tab
    2. Go to the specific page where the issue occurs
    3. Click the 🛡️ uBO Lite icon
    4. Click the menu item for `💬 Report an issue`
    5. Click `Troubleshooting Information`
    6. Copy the contents
    7. Paste the contents into the appropriate GitHub thread
 
#### Filter List Requests

New filter list requests in the issue tracker are not permitted and will be declined and closed.

#### Support Forum

For support, questions, or help, visit [/r/uBlockOrigin](https://www.reddit.com/r/uBlockOrigin/).

#### uBO Issues

Report issues with uBO in the [uBO issue tracker](https://github.com/uBlockOrigin/uBlock-issues/issues).

#### uBO Lite (uBOL) Issues

Report issues specific to the Manifest Version 3 (MV3) variant in the [uBOL issue tracker](https://github.com/uBlockOrigin/uBOL-home/issues).

#### Similarly-Purposed Blockers

Do **NOT** use any other [similarly-purposed blockers](https://x.com/gorhill/status/1033706103782170625) concurrently with uBO. It can result in website breakage or undefined results.
