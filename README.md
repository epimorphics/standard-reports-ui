# PPD Standard Reports UI

This project provides a simple UI for users who want to
define and download a PPD standard report. Standard Reports
aggregate various slices of Price Paid Data, according to
property type, region and date. The basic workflow is fairly
simple: users step through a wizard interface making selections
for the various report criteria, then at the end they click
to download the selected report which will kick off a background
batch job that Dave wrote. This batch job will either return
with the report download link, if a report with those options
has already been generated and cached, or a queue position
as the job moves up the batch queue.

## Development

This is a fairly standard Rails project, with no particular
surprises.

### Batch API

In production, the batch API is available on `localhost:8080`.
In development, we use an ssh tunnel to proxy a remote endpoint
to localhost. See `bin/sr-tunnel-daemon`.

### Tests

Simply:

    bundle exec rails test

## Issues

Please use the [shared issues list](https://github.com/epimorphics/hmlr-linked-data/issues)
