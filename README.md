# uAssets
Resources for [uBlock Origin](https://github.com/gorhill/uBlock) ("uBO"): static filter lists, ready-to-use rulesets, etc.

The goal of this repository is to receive all the reports for the need of new filters, or reports of web pages broken by existing filters, and will be open for people to contribute (those who have proven to be valuable contributors will be given write permissions on the project). Ideally I wish eventually there will be a small army of volunteers dedicated to deal with filter issues.

The rationale on whether to include a specific filter in one of uBO's own filter lists is the same as outlined by [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html), also taking into account whether a filter requires uBO's extended filter syntax.

If an issue can be fixed without using extended syntax, i.e. [scriptlet injection](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#scriptlet-injection), [redirect](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#redirect), [procedural cosmetic filters](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#procedural-cosmetic-filters), etc. the issue will, as a rule of thumb, not be fixed by uAssets, because fixing it in EasyList if possible is preferable.

Issues involving

- ad-reinsertion
- anti-adblock
- contextmenu blockage
- copy/cut/paste blockage 
- popups/popunders
- site breakage
- video ads

will always be fixed in uAssets even if they don't require extended syntax.


If the ABP-compatible fixes are for high-traffic sites, they should be added to uBO filters until they are added to EasyList.

Circumventing a paywall is considered [out of scope](https://github.com/uBlockOrigin/uAssets/issues/2317#issuecomment-392009540). GDPR messages will not be addressed in [uAssets](https://github.com/uBlockOrigin/uAssets/issues/4123#issuecomment-439232886).

Support issues and questions are handled at [/r/uBlockOrigin](https://old.reddit.com/r/uBlockOrigin/).

Using a similarly purposed blocker with uBO can result in site breakage or any undefined result, see https://twitter.com/gorhill/status/1033706103782170625.
