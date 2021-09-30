# Standard Reports UI: change log

## 1.3.5 - 2021-09-29

- (Mairead) Added Object.assign polyfill

## 1.3.4 - 2021-06-25

- (Joseph) Small config change to allow linking to privacy notice.

## 1.3.3 - 2021-03-08

- Switch from Travis to Github actions for CI tests
- dependency updates

## 1.3.2

- added the accessibility statement

## 1.3.1 - 2020-09-22 (Ian)

- added skip-to-main-content link

## 1.3.0 - 2020-09-21 (Ian)

Updates to improve WCAG compliance, including:

- remove `.text-muted` on some elements to improve colour contrast
- ensure that hidden elements are not tabbable
- ensure that form elements have unique IDs
- add aria-label to ensure that action intents are clear and unique
- use standard button styles for the form actions

## 1.2.2 - 2020-07-06

- Updates to Gem dependencies following some CVE warnings

## 1.2.1 - 2020-03-19

- Updates to various gem dependencies following some CVE warnings,
  but keeping Rails at version 5 for now.

## 1.2.0 - 2019-12-17

- Changed minor version number as we've switched to using a
  separate Sentry project for this app.

## 1.1.3 - 2019-12-11

- Add validation to avoid SPARQL-injection attack via postal codes

## 1.1.2 - 2019-12-09

- Add `ActionController::BadRequest` to the list of exceptions that
  Sentry will ignore

## 1.1.1 - 2019-10-10

- General update of gem dependencies
- Address deprecation warnings in MiniTest expectations
- Added changelog
