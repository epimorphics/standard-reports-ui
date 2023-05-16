# Price Paid Standard Reports UI

This project provides a straighforward user experience for users who want to
define and download a Price Paid Standard Report. Standard Reports aggregate
various slices of Price Paid (PPD) data, according to property type, region and
date. The basic workflow is fairly simple: users step through a wizard interface
making selections for the various report criteria, then at the end they click to
download the selected report which will kick off a background batch job, using
our report generator API. This batch job will either return with the report
download link, if a report with those options has already been generated and
cached, or a queue position as the job moves up the batch queue.

## Running this service

This application can be run stand-alone as a rails server in `development` mode.
However, when deployed, applications will run behind a reverse proxy.

This enables request to be routed to the appropriate application base on the
request path. In order to simplifiy the proxy configuration we retain the
original path where possible.

For information on how to running a proxy to mimic production and run multple
services together read through the information in our
[simple-web-proxy](https://github.com/epimorphics/simple-web-proxy/edit/main/README.md)
repository.

If running more than one application locally ensure that each is listerning on a
separate port and separate path. In the case of running local docker images, the
required configuration is captured in the `Makefile` and an image can be run by
using

### Development and Production mode

Applications running in `development` mode default to *not* use a sub-directory
to aid stand-alone development.

Applications running in `production` mode *do* use a sub-directory i.e.
`/app/standard-reports`.

In each case the is achieved by setting `config.relative_url_root` property to
this sub-directory within the file
`config/environments/(development|production).rb`.

If need be, `config.relative_url_root` may by overridden by means of the
`RAILS_RELATIVE_URL_ROOT` environment variable, althought this could also
require rebuilding the assets or docker image.

### Running Rails as a server

For developing rails applications you can start the server locally using the
following command:

```sh
rails server
```

and visit <localhost:3000> in your browser.

To change to using `production` mode use the `-e` option; or to change to a
different port use the `-p` option.

Note: In `production` mode, `SECRET_KEY_BASE` is also required. It is
insufficient to just set this as the value must be exported. e.g.

```sh
export SECRET_KEY_BASE=$(./bin/rails secret)
```

#### Running Rails as a server with a sub-directory via Makefile

```sh
API_SERVICE_URL=<data-api url> RAILS_ENV=<mode> RAILS_RELATIVE_URL_ROOT=/<path> make server
```

The default for `RAILS_ENV` here is `development`.

### Building and Running the docker container

It can be useful to run the compiled Docker image, that will mirror the
production installation, locally yourself. Assuming you have the [Standard
Reports Manager running](#running-the-standard-reports-manager-locally), then
you can run the Docker image for the app itself as follows:

```sh
make image run
```

or, if the image is already built, simply

```sh
make run
```

Docker images run in `production` mode.

To test the running application visit `localhost:<port>/<application path>`.

## Runtime Configuration environment variables

We use a number of environment variables to determine the runtime behaviour of
the application:

| name                       | description                                                             | default value              |
| -------------------------- | ----------------------------------------------------------------------- | -------------------------- |
| `API_SERVICE_URL`          | The base URL from which data is accessed, including the HTTP scheme eg. | None                       |
|                            | <http://localhost:8888> if running a `data-api service` locally         |                            |
|                            | <http://data-api:8080>  if running a `data-api docker` image locally    |                            |
| `SECRET_KEY_BASE`          | See [description](https://api.rubyonrails.org/classes/Rails/Application.html#method-i-secret_key_base). | |
|                            | For `development` mode a acceptable value is already configured, in production mode this should be set to the output of `rails secret`. | |
|                            | This is handled automatically when starting a docker container, or the `server` `make` target | |
| `SENTRY_API_KEY`           | The DSN for sending reports to the PPD Sentry account                   | None                       |

### Running the Standard Reports Manager locally

The application connects to the Standard Reports Manager service to submit
requests.

The easiest way to do this is as a local docker container. The image can be
built from [standard reports
manager](https://github.com/epimorphics/standard-reports-manager/) repository.
or pulled from the Amazon Elastic Container Registry
[ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1).

#### Building and running from [standard reports manager](https://github.com/epimorphics/standard-reports-manager/) repository

To build and a run a new docker image check out the  [standard reports
manager](https://github.com/epimorphics/standard-reports-manager/) repository
and run

```sh
make image run
```

#### Running an existing [ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1) image

Obtaining an ECR image requires:

- AWS IAM credentials to connect to the HMLR AWS account
- the ECR credentials helper installed locally (see
  [here](https://github.com/awslabs/amazon-ecr-credential-helper))
- Set the contents of your `~/.docker/config.json` file to be:

```sh
{
 "credsStore": "ecr-login"
}
```

This configures the Docker daemon to use the credential helper for all Amazon
ECR registries.

To use a credential helper for a specific ECR registry[^1], create a
`credHelpers` section with the URI of your ECR registry:

```sh
{
  [...]
  "credHelpers": {
    "public.ecr.aws": "ecr-login",
    "018852084843.dkr.ecr.eu-west-1.amazonaws.com": "ecr-login"
  }
}
```

Once you have a local copy of you required image, it is advisable to run a local
docker bridge network to mirror production and development environments.

Running a client application as a docker image from their respective `Makefile`s
will set this up automatically, but to confirm run

```sh
docker network inspect dnet
```

To create the docker network run

```sh
docker network create dnet
```

### To run the Standard Reports Manager as a docker container

Take a copy of the latest Manager development configuation file

```sh
wget -O test/fixtures/conf/app.conf https://raw.githubusercontent.com/epimorphics/standard-reports-manager/master/dev/app.conf
```

```sh
docker run --network dnet -p 8081:8080 --rm --name standard-reports-manager \
    -v $(pwd)/test/fixtures/conf/app.conf:/etc/standard-reports/app.conf \
    018852084843.dkr.ecr.eu-west-1.amazonaws.com/epimorphics/standard-reports-manager/dev:733e91d
```

the latest image can be found here
[dev](https://github.com/epimorphics/hmlr-ansible-deployment/blob/master/ansible/group_vars/dev/tags.yml)
and
[production](https://github.com/epimorphics/hmlr-ansible-deployment/blob/master/ansible/group_vars/prod/tags.yml).

The full list of versions can be found at [AWS
ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1)

Note: port 8080 should be avoided to allow for a reverse proxy to run on this
port.

With this set up, the api service is available on `http://localhost:8081` from
the host or `http://standard-reports-manager:8080` from inside other docker containers.

## Developer notes

### Structure

This is a fairly standard Rails project, with no particular surprises.

### Coding standards

Rubocop should complete with no warnings.

### Tests

Simply:

```sh
bundle exec rails test
```

## Issues

Please add issues to the [shared issues
list](https://github.com/epimorphics/hmlr-linked-data/issues)

## Additional Information

### Deployment

The detailed deployment mapping is described in `deployment.yml`. At the time of
writing, using the new infrastructure, the deployment process is as follows:

- commits to the `dev-infrastructure` branch will deploy the dev server
- commits to the `preprod` branch will deploy the pre-production server
- any commit on the `prod` branch will deploy the production server as a new
  release

If the commit is a "new" release, the deployment should be tagged with the same
semantic version number matching the  `BREAKING.FEATURE.PATCH` format, e.g.
`v1.2.3`, the same as should be set in the `/app/lib/version.rb`; also, a short
annotation summarising the updates should be included in the tag as well.

Once the production deployment has been completed and verified, please create a
release on the repository using the same semantic version number. Utilise the
`Generate release notes from commit log` option to create specific notes on the
contained changes as well as the ability to diff agains the previous version.

#### `entrypoint.sh` features

- Workaround to removing the PID lock of the Rails process in the event of the
  application crashing and not releasing the process.
- Guards to ensure the required environment variables are set accordingly and
  trigger the build to fail noisily and log to the system.
- Rails secret creation for `SECRET_KEY_BASE` assignment; see [Runtime
  Configuration environment
  variables](#runtime-configuration-environment-variables).

[^1]: With Docker 1.13.0 or greater, you can configure Docker to use different
credential helpers for different registries.
