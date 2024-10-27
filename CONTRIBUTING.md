### Filter Lists

#### Ordering of Filters

- New filters must be added at the end of the list.
  
  This approach allows for an easy assessment of a filter's relevance. Filters at the top will be the oldest and most likely to be obsolete.

- Old filters confirmed to still be required should also be moved to the end of the list.

#### Issue Number Association

- **All** added filters must be associated with a formal issue number. For example:

  ```
  ! https://github.com/uBlockOrigin/uAssets/issues/2
  ||data.inertanceretinallaurel.com^
  ```

  This practice documents the reason for adding a filter and provides a way to verify if an old filter is still necessary. The comment line preceding the filter(s) should consist solely of the URL to the issue, which contains all relevant details about the resolution.

#### Commit Message

- Keep it simple. For example: `this fixes #2`. The issue itself will contain all the necessary details.
