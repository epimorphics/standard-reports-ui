# Price Paid Standard Reports UI

This is the HM Land Registry [Standard Reports UI](http://landregistry.data.gov.uk/app/standard-reports),
a web application that allows users to define and download Price Paid Standard Reports.
Standard Reports aggregate slices of Price Paid (PPD) data by property type, region, and date.
Users step through a wizard interface making selections for the various report criteria, then
download the selected report. This kicks off a background batch job via the Standard Reports
Manager API, which either returns immediately with a cached report download link or provides
a queue position as the job works through the batch queue.

Please see the other repositories in the [HM Land Registry Open
Data](https://github.com/epimorphics/hmlr-linked-data/) project for more details.

For more information about this project visit [the wiki](https://github.com/epimorphics/standard-reports-ui/wiki).

## Tech stack

| Layer | Technology |
|---|---|
| Backend | Ruby on Rails, served via Puma |
| Assets | Sprockets + Dart Sass (dartsass-sprockets) |
| Templates | HAML |
| Data | Standard Reports Manager API queried via Faraday |
| Maps | Leaflet |
| Error tracking | Sentry |
| Metrics | Prometheus (`prometheus-client`, `puma-metrics`) |

This is a server-rendered Rails application with no Node.js build tooling. There is
no package.json, no Vite, and no Webpack.

## Developer setup

### 1. Install Ruby

Use [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://asdf-vm.com) to install
the version pinned in `.ruby-version` (currently `3.4.9`).

With rbenv:

```bash
rbenv install        # reads .ruby-version automatically
gem install bundler
```

### 2. Authenticate with the private gem registry

The `json_rails_logger` and `lr_common_styles` gems are hosted on the Epimorphics
GitHub Package Registry. You need a GitHub Personal Access Token with the
`read:packages` scope.

Configure Bundler with your token:

```bash
./bin/bundle config set --local rubygems.pkg.github.com epimorphics:<your-token>
```

### 3. Install dependencies

```bash
./bin/bundle install
```

No Node or Yarn installation is required.

### 4. Environment variables

`.env.development` contains sensible defaults for local development and is checked
in — no copying required. The app will start without any further configuration.

To override a value, create `.env.local` and set it there — Rails loads `.env.local`
first and falls back to `.env.development`. `.env.local` is gitignored.

| Variable | Default | Purpose |
|---|---|---|
| `API_SERVICE_URL` | `http://localhost:8081` | Standard Reports Manager API |
| `PORT` | `3003` | Rails server port |
| `METRICS_PORT` | `9396` | Prometheus metrics port |
| `SENTRY_ENABLED` | `false` | Enable Sentry error tracking |
| `SENTRY_AUTH_TOKEN` | — | Required only for production builds (source map upload) |
| `SENTRY_API_KEY` | — | Required only if `SENTRY_ENABLED=true` |

## Data API

The app queries a backing Standard Reports Manager API at `API_SERVICE_URL` (default
`http://localhost:8081`). Refer to the
[standard-reports-manager](https://github.com/epimorphics/standard-reports-manager)
repository for instructions on running it locally.

## Running locally

```bash
./bin/rails server -p 3003
```

The app is served on port 3003 by default and expects the Manager API at `API_SERVICE_URL`
(see `.env.development`).

## Testing

```bash
./bin/rails test
```

Tests use VCR cassettes under `fixtures/vcr_cassettes/`. To discard cassettes and force
live HTTP calls on the next run:

```bash
rm fixtures/vcr_cassettes/*
```

View the coverage report after a test run:

```bash
open coverage/index.html
```

## Linting

```bash
./bin/bundle exec rubocop -a    # Ruby — auto-corrects safe offences
```

There is no JavaScript linting (no JS build tooling) and no HAML linting configured.

## Building and publishing

The `Makefile` is scoped to the Docker image build and publish pipeline.

```bash
make image     # Build the Docker image (requires GitHub token configured)
make publish   # Push to AWS ECR
make vars      # Print all build variables
make tag       # Print the computed image tag
make version   # Print the application version
```

Variables can be overridden on the command line, e.g.:

```bash
STAGE=preprod make publish
```

Branch-to-environment mapping is defined in `deployment.yaml`. CI runs `publish` and
`deploy` automatically on push via `.github/workflows/publish-deploy.yml`.

## Releasing

This repository uses long-lived environment branches (`preprod`, `prod`) that are kept
as strict fast-forward pointers to tagged commits on `dev`. CI deploys automatically
on push, so promoting an environment is a case of fast-forwarding its branch and
pushing.

**Key invariant:** environment branches always point to a tagged commit on `dev`'s
linear history. Direct pushes to environment branches are not permitted.

### Standard release

**1. Finish work on `dev`**

Merge all feature branches into `dev` and ensure CI passes.

**2. Bump the version and update the changelog**

Edit `app/lib/version.rb` and `CHANGELOG.md`, then commit and push to `dev`:

```bash
git add app/lib/version.rb CHANGELOG.md
git commit -m "chore: release vx.y.z"
git push origin dev
```

**3. Tag the release commit**

```bash
git tag vx.y.z
git push origin vx.y.z
```

**4. Promote each environment branch in turn**

Fast-forward `preprod` first, verify the deployment, then repeat for `prod`:

```bash
git checkout preprod
git merge --ff-only vx.y.z
git push origin preprod
```

CI triggers automatically on push. Verify before promoting the next environment. If
`--ff-only` is refused, the branch has diverged — investigate before proceeding.

```bash
git checkout prod
git merge --ff-only vx.y.z
git push origin prod
```

**5. Optionally create a GitHub release**

Go to **Releases** on the repository page, draft a new release from the tag, and
publish.

---

### Hotfix release

**1. Branch off the current production tag**

```bash
git checkout -b hotfix/vx.y.z vx.y.(z-1)
```

**2. Make the fix, tag it, and push**

```bash
git add <files>
git commit -m "fix: <description>"
git tag vx.y.z
git push origin hotfix/vx.y.z vx.y.z
```

**3. Bring the fix into `dev`**

Preferred — rebase:

```bash
git rebase hotfix/vx.y.z dev
git push --force-with-lease origin dev
```

Safe fallback — cherry-pick:

```bash
git checkout dev
git cherry-pick vx.y.z
git push origin dev
```

**4. Promote environment branches to the hotfix tag**

Same as a standard release — fast-forward `preprod` then `prod`, verifying each
before moving to the next.

**5. Clean up the hotfix branch**

```bash
git branch -d hotfix/vx.y.z
git push origin --delete hotfix/vx.y.z
```

## Dependency maintenance

```bash
./bin/bundle update --patch              # Update all gems to latest patch version
./bin/bundle outdated --only-explicit    # Check for outdated gems
```
