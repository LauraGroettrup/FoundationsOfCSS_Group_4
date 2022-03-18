# filter and combine Tweets and stock values

# read Tesla and Bitcoin files ----
tesla_df <- read.csv("data/Tesla.csv")
bitcoin_df <- read.csv("data/BTC-USD.csv", sep=";")

# remove all stock data, who are later than the last tweet ----
last_date <- as.Date(strtrim(tail(tweets_df,1)$data.created_at, 10))
bitcoin_df <- bitcoin_df %>% filter(date >= last_date)
tesla_df$Date <- as.Date(tesla_df$Date, "%m/%d/%Y")
tesla_df <- tesla_df %>% filter(Date >= last_date)

# calculate stock movement and add it to dfs ----
movement_col  <- c()
for (row in 1:nrow(bitcoin_df)) {
  movement <- as.double(bitcoin_df[row, "close"]) - as.double(bitcoin_df[row, "open"])
  movement_col <- rbind(movement_col, movement)
}
bitcoin_df$movement <- movement_col
movement_col  <- c()
for (row in 1:nrow(tesla_df)) {
  movement <- as.double(sub(".", "", tesla_df[row, "Close.Last"])) - as.double(sub(".", "", tesla_df[row, "Open"]))
  movement_col <- rbind(movement_col, movement)
}
tesla_df$movement <- movement_col

# filter tweets who have at least one keyword----
keywords_bitcoin <- c("Doge", "Coin", "Crypto", "Hodl")
keywords_tesla <- c("Model", "stock", "Tesla", "Supercharger", "Giga", "car", "AI", "autopilot", "powerwall")
keyword_list_bitcoin <- list()
keyword_list_tesla <- list()
for (row in 1:nrow(tweets_df)) {
  message <- tweets_df[row, "data.text"]
  word_counter_bitcoin <- c()
  word_counter_tesla <- c()
  for (word in keywords_bitcoin){
    if(grepl(tolower(word), tolower(message), fixed=TRUE)){
      word_counter_bitcoin <- cbind(word_counter_bitcoin, word)
    }
  }
  for (word in keywords_tesla){
    if(grepl(tolower(word), tolower(message), fixed=TRUE)){
      word_counter_tesla <- cbind(word_counter_tesla, word)
    }
  }
  # extra handling for regex "to the moon!"
  if(str_detect(message, regex("To the moo[o]*n[!]*", ignore_case = TRUE))){
    word_counter_bitcoin <- cbind(word_counter_bitcoin, "To the moon!")
  }
  keyword_list_tesla[[row]] <-  c(word_counter_tesla)
  keyword_list_bitcoin[[row]] <-  c(word_counter_bitcoin)
}


# list gets shorten when last element is NULL
keyword_list_bitcoin[[row+1]] <-  c("Ende")
keyword_list_bitcoin <- data.frame(keywords_bitcoin=I(keyword_list_bitcoin))
keyword_list_bitcoin <- head(keyword_list_bitcoin,-1)
tweets_df <- cbind(tweets_df, keyword_list_bitcoin)
keyword_list_tesla[[row+1]] <-  c("Ende")
keyword_list_tesla <- data.frame(keywords_tesla=I(keyword_list_tesla))
keyword_list_tesla <- head(keyword_list_tesla,-1)
tweets_df <- cbind(tweets_df, keyword_list_tesla)
# delete all NULL rows (not nan means no na.ommit)
relevant_tweets_df <- data.frame()
for (row in 1:nrow(tweets_df)) {
  if(tweets_df$keywords_bitcoin[row]!="NULL" || tweets_df$keywords_tesla[row]!="NULL"){
    relevant_tweets_df <- rbind(relevant_tweets_df, tweets_df[row,])
  }
}


# combine stock movement with relevant tweets----
keywords_bitcoin <- relevant_tweets_df$keywords_bitcoin[1]
keywords_tesla <- relevant_tweets_df$keywords_tesla[1]
combined_df <- data.frame(date=last_date, text="ello world", keywords_tesla=keywords_tesla, keywords_bitcoin=keywords_bitcoin, movement_same_day_bitcoin=2.0, movement_next_day_bitcoin=2.0, movement_same_day_tesla=2.0, movement_next_day_tesla=2.0,stringsAsFactors=FALSE)
for (row in 1:nrow(relevant_tweets_df)) {
  date <- as.Date(strtrim(relevant_tweets_df$data.created_at[row], 10))
  time <- substr(relevant_tweets_df$data.created_at[row], 12, 13)
  keywords_tesla <- relevant_tweets_df$keywords_tesla[row]
  keywords_bitcoin <- relevant_tweets_df$keywords_bitcoin[row]
  text <- relevant_tweets_df$data.text[row]
  
  if (length(which(tesla_df$Date == date))==0) {
    movement_same_day_tesla <- NaN
  }else{
    movement_same_day_tesla <- tesla_df[which(tesla_df$Date == date), ]$movement
  }
  if (length(which(tesla_df$Date == date+1))==0) {
    movement_next_day_tesla <- NaN
  }else{
    movement_next_day_tesla <- tesla_df[which((tesla_df$Date == date+1)), ]$movement
  }
  if (length(which(bitcoin_df$date == date))==0) {
    movement_same_day_bitcoin <- NaN
  }else{
    movement_same_day_bitcoin <- bitcoin_df[which(bitcoin_df$date == date), ]$movement
  }
  if (length(which(bitcoin_df$date == date+1))==0) {
    movement_next_day_bitcoin <- NaN
  }else{
    movement_next_day_bitcoin <- bitcoin_df[which((bitcoin_df$date == date+1)), ]$movement
  }
  combined_df <- combined_df %>% add_row(date, text, keywords_tesla, keywords_bitcoin, movement_same_day_bitcoin, movement_next_day_bitcoin, movement_same_day_tesla, movement_next_day_tesla)
}
combined_df = combined_df[- 1, ]


# add column if on day in tesla stock market musk posted a (relevant) tweet
tweet_dates <- c()
for (i in 1:nrow(tweets_df)){
  time <- substr(tweets_df$data.created_at[i], 12, 13)
  if(time <= 12){
    tweet_dates <- append(tweet_dates, as.Date(strtrim(tweets_df$data.created_at[i], 10)))
  }
  if(time > 12){
    tweet_dates <- append(tweet_dates, as.Date(strtrim(tweets_df$data.created_at[i], 10))+1)
  }
  
}

tweet_relevant_dates_bitcoin <- c()
tweet_relevant_dates_tesla <- c()
for (i in 1:nrow(relevant_tweets_df)){
  time <- substr(relevant_tweets_df$data.created_at[i], 12, 13)
  if(time <= 12 && relevant_tweets_df$keywords_bitcoin[i]!="NULL"){
    tweet_relevant_dates_bitcoin <- append(tweet_relevant_dates_bitcoin, as.Date(strtrim(relevant_tweets_df$data.created_at[i], 10)))
  } 
  if(time > 12 && relevant_tweets_df$keywords_bitcoin[i]!="NULL"){
    tweet_relevant_dates_bitcoin <- append(tweet_relevant_dates_bitcoin, as.Date(strtrim(relevant_tweets_df$data.created_at[i], 10))+1)
  }
  if(time <= 12 && relevant_tweets_df$keywords_tesla[i]!="NULL"){
    tweet_relevant_dates_tesla <- append(tweet_relevant_dates_tesla, as.Date(strtrim(relevant_tweets_df$data.created_at[i], 10)))
  }
  if(time > 12 && relevant_tweets_df$keywords_tesla[i]!="NULL"){
    tweet_relevant_dates_tesla <- append(tweet_relevant_dates_tesla, as.Date(strtrim(relevant_tweets_df$data.created_at[i], 10))+1)
  }
}
relevant_tweet_posted <- vector()
tweet_posted <- vector()
for (i in 1:nrow(tesla_df)){
  if (length(which(tweet_relevant_dates_tesla == tesla_df$Date[i]))==0) {
    relevant_tweet_posted <- append(relevant_tweet_posted, 0)
  }else{
    relevant_tweet_posted <- append(relevant_tweet_posted, 1)
  }
  if (length(which(tweet_dates == tesla_df$Date[i]))==0) {
    tweet_posted <- append(tweet_posted, 0)
  }else{
    tweet_posted <- append(tweet_posted, 1)
  }
}
tesla_df <- cbind(tesla_df, relevant_tweet_posted)
tesla_df <- cbind(tesla_df, tweet_posted)

# add column if on day in bitcoin stock market musk posted a (relevant) tweet
relevant_tweet_posted <- vector()
tweet_posted <- vector()
for (i in 1:nrow(bitcoin_df)){
  if (length(which(tweet_relevant_dates_bitcoin == bitcoin_df$date[i]))==0) {
    relevant_tweet_posted <- append(relevant_tweet_posted, 0)
  }else{
    relevant_tweet_posted <- append(relevant_tweet_posted, 1)
  }
  if (length(which(tweet_dates == bitcoin_df$date[i]))==0) {
    tweet_posted <- append(tweet_posted, 0)
  }else{
    tweet_posted <- append(tweet_posted, 1)
  }
}
bitcoin_df <- cbind(bitcoin_df, relevant_tweet_posted)
bitcoin_df <- cbind(bitcoin_df, tweet_posted)

# absolute value to df
movement_absolute_value_tesla <- abs(tesla_df$movement)
tesla_df <- cbind(tesla_df, movement_absolute_value_tesla)
movement_absolute_value_bitcoin <- abs(bitcoin_df$movement)
bitcoin_df <- cbind(bitcoin_df, movement_absolute_value_bitcoin)

#percent
movement_absolute_in_percent <-tesla_df$movement_absolute_value_tesla / as.double(sub(".", "", tesla_df$Open))
tesla_df <- cbind(tesla_df, movement_absolute_in_percent)
movement_absolute_in_percent <-bitcoin_df$movement_absolute_value_bitcoin / as.double(sub(".", "", bitcoin_df$open))
bitcoin_df <- cbind(bitcoin_df, movement_absolute_in_percent)

movement_in_percent <-tesla_df$movement / as.double(sub(".", "", tesla_df$Open))
tesla_df <- cbind(tesla_df, movement_in_percent)
movement_in_percent <-bitcoin_df$movement / as.double(sub(".", "", bitcoin_df$open))
bitcoin_df <- cbind(bitcoin_df, movement_in_percent)