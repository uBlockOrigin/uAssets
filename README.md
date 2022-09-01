# uAssets
Resources for [uBlock Origin (uBO)](https://github.com/gorhill/uBlock): static filter lists, ready-to-use rulesets, etc.

The goal of this repository is to receive all the reports on the need for new filters or reports of web pages broken by existing filters and will be open for people to contribute (those who have proven to be valuable contributors will receive write permissions on the project). Ideally, I wish for a small army of dedicated volunteers to deal solely with filter issues.

The rationale on whether to include a specific filter in one of uBO's filter lists is the same as outlined by [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html), also taking into account whether a filter requires uBO's extended filter syntax.

Any resolution of issues without using extended syntax ([scriptlet injection](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#scriptlet-injection), [redirect](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#redirect), [procedural cosmetic filters](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#procedural-cosmetic-filters), etc.) will not occur in uAssets. The preferable way is to fix it in EasyList, if possible.

Issues involving the following will be fixed in uAssets even if they don't require extended syntax:

- ad-reinsertion
- anti-blocker
- context menu blockage
- copy/cut/paste blockage
- popups/popunders
- site breakage
- video ads

If the ABP-compatible fixes are for high-traffic sites, they need to be added to uBO filters until they get added to EasyList.

#### Paywall
Circumventing a paywall is considered [out of scope](https://github.com/uBlockOrigin/uAssets/issues/2317#issuecomment-392009540).

#### GDPR
[uAssets](https://github.com/uBlockOrigin/uAssets/issues/4123#issuecomment-439232886) will not address GDPR modals.

#### Porn farms
Sites found to be porn farms (families of mass-produced porn sites without original content) or are part of a porn farm will not be addressed in uAssets.

#### Support forum
For any support, questions or help, visit [/r/uBlockOrigin](https://www.reddit.com/r/uBlockOrigin/).

#### Similarly purposed blocker
Using a similarly purposed blocker with uBO can result in site breakage or undefined results. See https://twitter.com/gorhill/status/1033706103782170625.
