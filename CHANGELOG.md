# Standard Reports UI: change log

## 1.4.2 - 2023-03-10

- (Jon) Added a cli recommendation for running the `sr-manager` locally;
  resolved a markdown linting issue with using HTML in markdown; as well as
  fixed a simple typo in the `localhost:3001` port example
- (Jon) Refactors the elapsed time calculated for API requests to be resolved
  as microseconds rather than milliseconds. This is to improve the reporting of
  the elapsed time in the system tooling logs.
- (Jon) Minor text changes to the `Gemfile` to include instructions for running
  Epimorphics specific gems locally during the development of those gems.
- (Jon) Updated the production `json_rails_logger` gem version to be at least the
  current version `~>1.3.5` (this is to cover out of sync release versions)
- (Jon) Updated the production `lr_common_styles` gem version to be at least the
  current version `~>1.9.1` (this is to cover out of sync release versions)
- (Jon) Renamed the global env variable `RAILS_RELATIVE_URL_ROOT` to
  `APPLICATION_ROOT` to be more clear on it's use in the `entrypoint.sh` code.
- (Jon) Refactored better guards in `entrypoint.sh` to ensure the required env
  vars are set accordingly or deployment will fail noisily.
- (Jon) Refactored the version cadence creation to include a SUFFIX value if
  provided; otherwise no SUFFIX is included in the version number.

## 1.4.1 - 2022-07-11

- (Jon) Set the default root path environment variable to be
 `/app/standard-reports` in the production environment as well as updated
  variable requests to use `fetch` to future proof the codebase

## 1.4.0 - 2022-04-07

- (Ian) Adopt all of the current Epimorphics best-practice deployment patterns,
  including shared GitHub actions, updated Makefile and Dockerfile, Prometheus
  monitoring, and updated version of Sentry.
- (Ian) Updated the README as part of handover.

## 1.3.5 - 2021-12-11

- (Mairead) Added deployment sub repo and assisting deployment files

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

- Updates to various gem dependencies following some CVE warnings, but keeping
  Rails at version 5 for now.

## 1.2.0 - 2019-12-17

- Changed minor version number as we've switched to using a separate Sentry
  project for this app.

## 1.1.3 - 2019-12-11

- Add validation to avoid SPARQL-injection attack via postal codes

## 1.1.2 - 2019-12-09

- Add `ActionController::BadRequest` to the list of exceptions that Sentry will
  ignore

## 1.1.1 - 2019-10-10

- General update of gem dependencies
- Address deprecation warnings in MiniTest expectations
- Added changelog
