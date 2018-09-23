# uAssets
Resources for [uBlock Origin](https://github.com/gorhill/uBlock) ("uBO"), [uMatrix](https://github.com/gorhill/uMatrix/): static filter lists, ready-to-use rulesets, etc.

The goal of this repository is to receive all the reports for the need of new filters, or reports of web pages broken by existing filters, and will be open for people to contribute (those who have proven to be valuable contributors will be given write permissions on the project). Ideally I wish eventually there will be a small army of volunteers dedicated to deal with filter issues.

The rationale on whether to include a specific filter in one of uBO's own filter lists is the same as outlined by [EasyList/EasyPrivacy policies](https://easylist.to/pages/policy.html), also taking into account whether a filter requires uBO's extended filter syntax.

If an issue can be fixed without using extended syntax, i.e. [scriptlet injection](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#scriptlet-injection), [redirect](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#redirect), [procedural cosmetic filters](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax#procedural-cosmetic-filters), etc. the issue will, as a rule of thumb, not be fixed by uAssets, because fixing it in EasyList if possible is preferable.

Issues involving

- anti-adblock
- ad-reinsertion
- popups/popunders
- site breakage

will always be fixed in uAssets even if they don't require extended syntax.


If the ABP-compatible fixes are for high-traffic sites, they should be added to uBO filters until they are added to EasyList.
