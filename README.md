# Price Paid Standard Reports UI

This project provides a straighforward user experience for users who want to
define and download a Price Paid Standard Report. Standard Reports aggregate
various slices of Price Paid (PPD) data, according to property type, region and
date. The basic workflow is fairly simple: users step through a wizard
interface making selections for the various report criteria, then at the end
they click to download the selected report which will kick off a background
batch job, using an API that Dave wrote. This batch job will either return with
the report download link, if a report with those options has already been
generated and cached, or a queue position as the job moves up the batch queue.

## Running this service

This application can be run stand-alone as a rails server in `development` mode. 
However, when deployed, applications will run behind a reverse proxy.

This enables request to be routed to the appropriate application base on the request path.
In order to simplifiy the proxy configuration we retain the original path where possible.

For information on how to running a proxy to mimic production and run multple services
together see [simple-web-proxy](https://github.com/epimorphics/simple-web-proxy/edit/main/README.md)

If running more than one application locally ensure that each is listerning on a
separate port and separate path. In the case of running local docker images, the required
configuration is captured in the `Makefile` and an image can be run by using

### Development and Production mode

Applications running in `development` mode default to not use a sub-directory to aid 
stand-alone development.

Applications running in `production` mode default to use a sub-directory i.e `/app/standard-reports`.

n each case the is achieved by setting `config.relative_url_root` property to this 
sub-directory within the file `config/environments/(development|production).rb`.

If need be, `config.relative_url_root` may by overridden by means of the
`RAILS_RELATIVE_URL_ROOT` environment variable, althought this could also
require rebuilding the assets or docker image.

### Building and Running the docker container

```sh
make image run
```

or, if the image is already built, simply

```sh
make run
```
Docker images run in `production` mode.

### Running Rails as a server

For rails applications you can start the server locally using the following command:

```sh
rails server -e production -p <port>
```

#### Running Rails as a server with a sub-directory

```sh
API_SERVICE_URL=<data-api url> RAILS_ENV=<mode> RAILS_RELATIVE_URL_ROOT=/<path> make server
```
The default for `RAILS_ENV` here is `development`.

Note: In `production` mode, `SECRET_KEY_BASE` is also rquired. It is insufficient to just
set this as the value must be exported. i.e.
```sh
export SECRET_KEY_BASE=$(./bin/rails secret)
```


To test the running application visit `localhost:<port>/{application path}`.

## Runtime Configuration environment variables

We use a number of environment variables to determine the runtime behaviour
of the application:

| name                       | description                                                             | default value              |
| -------------------------- | ----------------------------------------------------------------------- | -------------------------- |
| `API_SERVICE_URL`          | The base URL from which data is accessed, including the HTTP scheme eg. | None                       |
|                            | http://localhost:8888 if running a `data-api service` locally           |                            |
|                            | http://data-api:8080  if running a `data-api docker` image locally      |                            |
| `SECRET_KEY_BASE`          | See [description](https://api.rubyonrails.org/classes/Rails/Application.html#method-i-secret_key_base).
For `development` mode a acceptable value is already configured, in production mode this should be set to the output of `rails secret`.
This is handled automatically when starting a docker container, or the `server` `make` target | |
| `SENTRY_API_KEY`           | The DSN for sending reports to the PPD Sentry account                   | None                       |




### Running the Standard Reports Manager locally

The application connects to the Standard Reports Manager service to submit requests.

The easiest way to do this is as a local docker container. The image can be built from [standard reports manager](https://github.com/epimorphics/standard-reports-manager/) repository.
or pulled from the Amazon Elastic Container Registry [ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1).

#### Building and running from [standard reports manager](https://github.com/epimorphics/standard-reports-manager/) repository

To build and a run a new docker image check out the  [standard reports manager](https://github.com/epimorphics/standard-reports-manager/) repository and run
```sh
make image run
```

#### Running an existing [ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1) image

Obtaining an ECR image requires:

- AWS IAM credentials to connect to the HMLR AWS account
- the ECR credentials helper installed locally (see [here](https://github.com/awslabs/amazon-ecr-credential-helper))
- this line: `"credsStore": "ecr-login"` in `~/.docker/config.json`

Once you have a local copy of you required image, it is advisable to run a local docker bridge network to mirror 
production and development environments.

Running a client application as a docker image from their respective `Makefile`s will set this up 
automatically, but to confirn run

```sh
docker network inspect dnet
```

To create the docker network run
```sh
docker network create dnet
```

To run the Data API as a docker container:

Take a copy of the latest Manager development configuation file 
```sh
wget -O test/fixtures/conf/app.conf https://raw.githubusercontent.com/epimorphics/standard-reports-manager/master/dev/app.conf
```

```sh
docker run --network dnet -p 8084:8080 --rm --name standard-reports-manager \
    -v $(pwd)/test/fixtures/conf/app.conf:/etc/standard-reports/app.conf \
    018852084843.dkr.ecr.eu-west-1.amazonaws.com/epimorphics/standard-reports-manager/dev:733e91d
```

the latest image can be found here [dev](https://github.com/epimorphics/hmlr-ansible-deployment/blob/master/ansible/group_vars/dev/tags.yml) 
and [production](https://github.com/epimorphics/hmlr-ansible-deployment/blob/master/ansible/group_vars/prod/tags.yml).

The full list of versions can be found at [AWS
ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1)

Note: port 8080 should be avoided to allow for a reverse proxy to run on this port.

With this set up, the api service is available on `http://localhost:8888` from the host or `http://data-api:8080`
from inside other docker containers.


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
