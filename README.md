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

### Back-end batch processing API

The app requires a back-end batch processing API to run the queries, manage the
queue, and create the download links. All of this is provided by the [standard
reports manager](https://github.com/epimorphics/standard-reports-manager/). In
addition, the app relies on the `/sr-manager/latest-month-available` call to
configure the date options that are presented on the workflow step that
configures the dates for the report.

In production, the orchestration of which API the app will work with is handled
by the Ansible configuration.

### Running the API in development

In development, it is helpful to have an instance of the API available. The
preferred pattern is to run the Docker container that holds the `sr-manager`
API locally, but connected to the remote triple store. A suggested way to do
this is:

```sh
AWS_PROFILE=lr docker run \
  -v `pwd`/test/fixtures/conf/app.conf:/etc/standard-reports/app.conf
  -p 8080:8080 \
  018852084843.dkr.ecr.eu-west-1.amazonaws.com/epimorphics/standard-reports-manager/dev:d1418af
```

This maps a test fixture app configuration, which connects to the public Fuseki
instance. **Note** that connecting to the public Fuseki instance in this way
means that the default query timeout limits. To allow longer-running queries,
the private interface that the **production** service uses to the triple store
has longer timeouts. The consequence of this is: some queries that will perform
correctly when run via the production service will time-out when run in this
dev configuration. Performance investigations should be run using a production
instance of the service; running with the local dev Docker container as
described above should be limited to app development or maintainance tasks.

**Note** that the identity of the Docker image (`d1418af` in the example above)
will change periodically. The currently deployed dev api image version is given
by the `std_reports_mgr` tag in the ansible [dev
configuration](https://github.com/epimorphics/hmlr-ansible-deployment/blob/master/ansible/group_vars/dev/tags.yml).

If you need to run a different API version then the easiest route to
discovering the most recent is to use the [AWS
ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/018852084843/epimorphics/standard-reports-manager/dev?region=eu-west-1)
console.

### Running the app locally in dev mode

Assuming the API is running on port 8080 (the default), to start the standard
reports app:

```sh
API_SERVICE_URL=http://localhost:8080 rails server
```

And then visit [`localhost:3000`](http://localhost:3000/).

### Running the app locally as a Docker image

It can be useful to run the compiled Docker image, that will be run by the
production installation, locally yourself. Assuming you have the dev API
running on `localhost:8080` (the default), then you can run the Docker image
for the app itself as follows:

```sh
API_SERVICE_URL=http://host.docker.internal:8080 make run
```

Note that `host.docker.internal` is a special alias for `localhost`, which is
[supported by
Docker](https://medium.com/@TimvanBaarsen/how-to-connect-to-the-docker-host-from-inside-a-docker-container-112b4c71bc66).

Assuming the Docker container starts up OK, you will need a proxy to simulate
the effect of accessing the application via its ingress path
(`/app/standard-reports`). There is a [simple web
proxy](https://github.com/epimorphics/simple-web-proxy) that you can use.

With the simple web proxy, and the two Docker containers running, access the
application as
[`localhost:30001/app/standard-reports/`](http://localhost:3001/app/standard-reports/).

## Configuration environment variables

We use a number of environment variables to determine the runtime behaviour
of the application:

| name                       | description                                                          | typical value            |
| -------------------------- | -------------------------------------------------------------------- | ------------------------ |
| `RAILS_RELATIVE_URL_ROOT`  | The path from the server root to the application                     | `/app/standard-reports`  |
| `API_SERVICE_URL`          | The base URL from which data is accessed, including the HTTP scheme  | `http://localhost:8080`  |
| `SENTRY_API_KEY`           | The Sentry DSN for sending exceptions and errors to Sentry           |                          |
