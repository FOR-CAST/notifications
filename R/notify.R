#' Send a notification
#'
#' Send a notification via one of the following message/notification apps:
#'
#' - Google Workspace Spaces
#' - Pushbullet
#' - Slack
#' - Zulip
#'
#' See below for more details.
#'
#' @param msg the message to send
#' @param config_file character specifying the path to a credentials configuration file
#' @param ... additional arguments to internal functions
#'
#' @return the response (invisibly)
#'
#' @name notify
#' @rdname notify
NULL

#' @section Google Workspace Spaces:
#'
#' `notify_google()` is a wrapper around `httr::POST()`
#'
#' Requires a Google Workspace account and 'Space' be setup and configured with a webhook url:
#'
#' 1. From Gmail, go to 'Spaces' on the left hand navigation bar;
#' 2. Create a new space or select an existing one;
#' 3. From the space's dropdown menu, select 'Apps & integrations';
#' 4. Click on 'Manage webhooks' band create an incoming webhook;
#' 5. Copy the webhook url;
#' 6. Create a text file `~/.rgooglespaces`, and add the following using your copied webhook url:
#'     ```
#'     webhook_url: https://chat.googleapis.com/v1/spaces/your_key_and_token_etc
#'     ```
#'
#' @export
#' @importFrom httr POST
#' @name notify_google
#' @rdname notify
notify_google <- function(msg, config_file = "~/.rgooglespaces", ...) {
  config <- yaml::read_yaml(config_file)
  if (file.exists(config_file)) {
    resp <-  httr::POST(url = config$webhook_url, body = list(text = msg), encode = "json")
  } else {
    stop(paste("Configuration file", config_file, "not found. See ?notify_google."))
  }

  return(invisible(resp))
}

#' @section Pushbullet:
#'
#' `notify_pushbullet()` is a wrapper around `RPushbullet::pbPost()`
#'
#' Use `RPushbullet::pbSetup()` to configure your machine to use Pushbullet.
#'
#' @export
#' @importFrom RPushbullet pbPost
#' @name notify_slack
#' @rdname notify
notify_pushbullet <- function(msg, ...) {
  resp <- RPushbullet::pbPost(body = msg, ...)

  return(invisible(resp))
}

#' @section Slack:
#'
#' `notify_slack()` is a wrapper around `slackr::slackr_msg()`
#'
#' @export
#' @importFrom slackr slackr_msg slackr_setup
#' @name notify_slack
#' @rdname notify
notify_slack <- function(msg, config_file = "~/.slackr", ...) {
  slackr::slackr_setup(config_file = config_file)
  resp <- slackr::slackr_msg(txt = msg, ...)

  return(invisible(resp))
}

#' @section Zulip:
#'
#' `notify_zulip()` is a wrapper around `httr::POST()`
#'
#' Requires Zulip be setup and configured with a webhook url:
#'
#' 1. Make note of your Zulip domain (e.g., `yourZulipDomain.zulipchat.com`)
#' 2. Create a Zulip bot of type 'Incoming Webhook' following <https://zulip.com/help/add-a-bot-or-integration>;
#' 3. Note the bot's API key following <https://zulip.com/api/api-keys>;
#' 4. Create a text file `~/.rgooglespaces`, and add the following using your bot's API key,
#'    your Zulip domain, and optionally a default stream and topic to post notifications to:
#'     ```
#'     zulip_apikey:
#'     zulip_domain: yourZulipDomain.zulipchat.com
#'     zulip_stream: optional stream name
#'     zulip_topic: optional topic name
#'     ```
#' If a stream is not specified, private messages will be sent to the creator of the bot.
#'
#' @export
#' @importFrom httr POST
#' @importFrom utils URLencode
#' @name notify_google
#' @rdname notify
notify_zulip <- function(msg, config_file = "~/.rzulip", ...) {
  dots <- list(...)
  config <- yaml::read_yaml(config_file)
  ## see <https://zulip.com/integrations/doc/slack_incoming>
  url <- paste0(
    "https://", config$zulip_domain, "/api/v1/external/slack_incoming",
    "?api_key=", config$zulip_apikey,
    if (!is.null(config$stream))
      paste0("&stream=", URLencode(config$zulip_stream, reserved = TRUE)),
    if (!is.null(config$stream) && !is.null(config$topic))
                  paste0("&topic=", URLencode(config$zulip_topic, reserved = TRUE))
  )

  if (file.exists(config_file)) {
    resp <-  httr::POST(url = url, body = list(text = msg), encode = "json")
  } else {
    stop(paste("Configuration file", config_file, "not found. See ?notify_zulip."))
  }

  return(invisible(resp))
}
