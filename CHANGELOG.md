# Standard Reports UI: change log

## 1.5.1 - 2023-11-23

- (Jon) Updated the `lr_common_styles` gem to the latest 1.9.2 patch release.
  - Also includes minor patch updates for gems, please see the `Gemfile.lock`
  for details.

## 1.5.0.1 - 2023-07-11

- (Jon) Updated the `app/controllers/application_controller.rb` to include the
  `before_action` for the `change_default_caching_policy` method to ensure the
  default `Cache-Control` header for all requests is set to 5 minutes (300 seconds).

## 1.5.0 - 2023-07-05

- (Jon) This sets the cache control headers to be public and cacheable with a
  retry limit of 5 mins as per the other cache settings.
  [GH-114](https://github.com/epimorphics/hmlr-linked-data/issues/114)
- (Jon) Primarily to add the Request ID in the headers to pass to SR Manager but
  also including the addition of the `detailed_request_log` to match the other
  apps and additional debugging messages while in development
  [GH-124](https://github.com/epimorphics/hmlr-linked-data/issues/124)
- (Jon) Keeping with the logging improvements this change rewrites the messages
  passed to the logging gem to ensure the included details are simple and
  straight to the point. This should also improve the issues reported in
  [GH-117](https://github.com/epimorphics/hmlr-linked-data/issues/117) ,
  at least from the front-end point of view!
- (Jon) Updated the [README](README.md) to include the `API_SERVICE_URL`
  variable to ensure the local `standard_reports_manager` instance is used in
  the test environment.
- (Jon) Ensures we're using the latest version of `json_rails_logger` as well as
  other minor and patch updated gems

## 1.4.4 - 2023-06-07

- (Jon) Updated the `json_rails_logger` gem to the latest 1.0.1 release.
  - Also includes minor patch updates for gems, please see the `Gemfile.lock`
  for details.

## 1.4.3 - 2023-06-03

- (Jon) Updated the `json_rails_logger` gem to the latest 1.0.0 release.

## 1.4.2 - 2023-03-10

- (Jon) Added a cli recommendation for running the `sr-manager` locally;
  resolved a markdown linting issue with using HTML in markdown; as well as
  fixed a simple typo in the `localhost:3001` port example
- (Jon) Refactors the elapsed time calculated for API requests to be resolved as
  microseconds rather than milliseconds. This is to improve the reporting of the
  elapsed time in the system tooling logs.
- (Jon) Minor text changes to the `Gemfile` to include instructions for running
  Epimorphics specific gems locally during the development of those gems.
- (Jon) Updated the production `json_rails_logger` gem version to be at least
  the current version `~>1.3.5` (this is to cover out of sync release versions)
- (Jon) Updated the production `lr_common_styles` gem version to be at least the
  current version `~>1.9.1` (this is to cover out of sync release versions)
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

## 1.3.7

- (Jon) Add Folkestone and Hythe to district names.

## 1.3.6 - 2021-10-22

- (Joseph) Add North and West Northamptonshire to county names.
- (Joseph) Add Bournemouth, Christchurch and Poole to county names.
- (Joseph) Add Somerset West and Taunton to district names.
- (Joseph) Add East Suffolk to district names.
- (Joseph) Add West Suffolk to district names.

## 1.3.5

- (Mairead) Added deployment sub repo and assisting deployment files
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
