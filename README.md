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

Please see the other repositories in the [HM Land Registry Open
Data](https://github.com/epimorphics/hmlr-linked-data/) project for more
details.

For more information about this project visit [the wiki](https://github.com/epimorphics/standard-reports-ui/wiki).
