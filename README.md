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

## Deployment

To mimic running the application in a deployed state you can run
`make image` and this will run through the assets precompilation, linting and testing before creating a Docker image. To view the Docker container you can run `make run`

To bypass the need for running locally AWS you can pass a global variable to the command with `ECR=local make image`

You can run `make help` to view a list of other make commands available

## Entrypoint.sh

* The Rails Framework requires certain values to be set as a Global environment variable when starting. To ensure the `RAILS_RELATIVE_URL_ROOT` is only set in one place per application we have added this to the Entrypoint file along with the `SCRIPT_NAME`.
* The Rails secret is also created here.
* There is a workaround to removing the PID lock of the Rails process in the event of the application crashing and not releasing the process.
* We have to pass the `API_SERVICE_URL` so that it is available in the Entrypoint.sh or the application will throw an error and exit before starting

### Tests

Simply:

    bundle exec rails test
