# get, save and sample Elon Musks Twitter tweets


# Authorize the requests ----
# bearer_token <- "TheBearerToken"
# headers <- c(`Authorization` = sprintf('Bearer %s', bearer_token))
# lookup userid Elon Musk ----
# lookup_url <- "https://api.twitter.com/2/users/by?usernames=elonmusk"
# lookup_request <- httr::GET(url = lookup_url, httr::add_headers(.headers = headers))
# user_json <- httr::content(lookup_request, as = "text")
# user_df <- fromJSON(user_json, flatten = TRUE) %>% as.data.frame
# user_id <- user_df$data.id
# get the last 800 tweets (API cap without replies) from Elon Musk
# first time version----
# first request for 100 tweets
#params <- list(exclude = "replies", max_results=100, tweet.fields="public_metrics,created_at")
#tweet_url <- sprintf('https://api.twitter.com/2/users/%s/tweets', user_id)
#twitter_response <- httr::GET(url = tweet_url, httr::add_headers(.headers = headers), query=params)
#tweets_json <- httr::content(twitter_response, as = "text")
#tweets_df <- fromJSON(tweets_json, flatten = TRUE) %>% as.data.frame
#pagination_token <- tweets_df$meta.next_token[1]
# get the rest with pagination
#repeat{
#  tweet_url <- sprintf('https://api.twitter.com/2/users/%s/tweets?pagination_token=%s', user_id, pagination_token)
#  twitter_response <- httr::GET(url = tweet_url, httr::add_headers(.headers = headers), query=params)
#  tweets_json <- httr::content(twitter_response, as = "text")
#  tweets_looped_df <- fromJSON(tweets_json, flatten = TRUE) %>% as.data.frame
#  pagination_token <- tweets_looped_df$meta.next_token[1]
#  if (ncol(tweets_looped_df)==ncol(tweets_df)+1){
#    tweets_df <- rbind (tweets_df, subset(tweets_looped_df, select = -c(meta.previous_token)))
#  }
#  if(is.null(pagination_token)){
#    break
#  }
#}
# save the tweets and sample for reproducibility 
# write.csv(tweets_df,"data\\Tweets.csv", row.names = FALSE)
# sample <- sample_n(as.data.frame(tweets_df$data.text),300)
# write.table(sample, "data\\sample.txt", append = FALSE, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE)
# load version ----
tweets_df <- read.csv("data/Tweets.csv")

