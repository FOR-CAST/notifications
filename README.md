# notifications

<!-- badges: start -->
<!-- badges: end -->

Send notifications via messaging apps from R.

Currently supports the following messaging apps:

- Google Workspace Spaces
- Pushbullet
- Slack
- Zulip

## Installation

``` r
# install.packages("remotes")
remotes::install_github("FOR-CAST/notifications")
```

## Example: Google Workspace Spaces

### Configuration

see `?notify_google`

### Usage

``` r
library(notifications)
notify_google("Here's an important message about the code you just ran: it worked!")
```

## Example: Pushbullet

### Configuration

see `?notify_pushbullet`

### Usage

``` r
library(notifications)
notify_pushbullet("Your job has compeleted.")
```

## Example: Slack

### Configuration

see `?notify_slack`

### Usage

``` r
library(notifications)
notify_slack("Error running job. See `traceback()` for more details.")
```

## Example: Zulip

### Configuration

see `?notify_zulip`

### Usage

``` r
library(notifications)
notify_zulip("There was a problem with your script - please check the logs.")
```

