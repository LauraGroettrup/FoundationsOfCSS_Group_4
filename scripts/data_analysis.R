# analysis data to come to an result
sentiment <- vader_df(combined_df$text)
combined_df <- cbind (combined_df, sentiment["compound"])

sentiment <- vader_df(tweets_df$data.text)
tweets_df <- cbind (tweets_df, sentiment["compound"])
# TODO: TESLA+Bitcoin 24 hour matching ueberwieend
#same_day_movement_tweet <-  combined_df[!(is.na(combined_df$movement_same_day_tesla)), ]
#model <- lm(compound~movement_same_day_bitcoin, same_day_movement_tweet)
#model$coefficients



# Tesla ----
# non absolute
#movement_no_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==FALSE))$movement
#movement_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==TRUE))$movement
#movement_tesla <- tesla_df$relevant_tweet_posted
#length(movement_tweet_tesla)
#length(movement_tesla)

#no_tweet_at_all <- (filter(tesla_df, tweet_posted==FALSE))$movement
#all_tweet_at_all <- (filter(tesla_df, tweet_posted==TRUE))$movement
#varianzhomogenitaet_all <- var.test(no_tweet_at_all, all_tweet_at_all)
#varianzhomogenitaet_all

#t.test(tesla_df$movement_absolute_value_tesla~tesla_df$tweet_posted, var.equal = TRUE, alternative = "two.sided")

#res<-t.test(no_tweet_at_all, all_tweet_at_all)
#res

#varianzhomogenitaet <- var.test(movement_tweet_tesla, movement_tesla) 
#varianzhomogenitaet <- var.test(movement_tweet_tesla, movement_no_tweet_tesla) 

#res<-t.test(movement_tweet_tesla, movement_no_tweet_tesla, var.equal=TRUE, alternative = "two.sided")
#res

#res<-t.test(movement_tweet_tesla, movement_no_tweet_tesla, var.equal=TRUE, alternative = "one.sided")
#res

#positive_movement_no_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==FALSE, movement>0))$movement
#negative_movement_no_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==FALSE, movement<0))$movement
#positive_movement_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==TRUE, movement>0))$movement
#negative_movement_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==TRUE, movement<0))$movement

#res<-t.test(positive_movement_tweet_tesla, positive_movement_no_tweet_tesla, var.equal=TRUE, alternative = "two.sided")
#res

#res<-t.test(negative_movement_tweet_tesla, negative_movement_no_tweet_tesla, var.equal=TRUE, alternative = "two.sided")
#res
# absolute

movement_no_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==FALSE))$movement_absolute_value_tesla
movement_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==TRUE))$movement_absolute_value_tesla
#movement_tesla <- tesla_df$relevant_tweet_posted

no_tweet_at_all <- (filter(tesla_df, tweet_posted==FALSE))$movement_in_percent
all_tweet_at_all <- (filter(tesla_df, tweet_posted==TRUE))$movement_in_percent
#varianzhomogenitaet_all <- var.test(no_tweet_at_all, all_tweet_at_all)
varianzhomogenitaet_all <- var.test(tesla_df$movement_in_percent, all_tweet_at_all)
varianzhomogenitaet_all
# nicht zulaessig? res<-t.test(no_tweet_at_all, all_tweet_at_all)
t.test(tesla_df$movement_in_percent~tesla_df$tweet_posted, var.equal = TRUE, alternative = "two.sided")
res

#varianzhomogenitaet <- var.test(movement_tweet_tesla, movement_tesla) 
varianzhomogenitaet <- var.test(movement_tweet_tesla, movement_no_tweet_tesla) 

res<-t.test(movement_tweet_tesla, movement_no_tweet_tesla, var.equal=TRUE, alternative = "two.sided")
res

res<-t.test(movement_tweet_tesla, movement_no_tweet_tesla, var.equal=TRUE, alternative = "")
res

positive_movement_no_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==FALSE, movement>0))$movement_in_percent
negative_movement_no_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==FALSE, movement<0))$movement_in_percent
positive_movement_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==TRUE, movement>0))$movement_in_percent
negative_movement_tweet_tesla <- (filter(tesla_df, relevant_tweet_posted==TRUE, movement<0))$movement_in_percent

res<-t.test(positive_movement_tweet_tesla, positive_movement_no_tweet_tesla, var.equal=FALSE, alternative = "two.sided")
res

res<-t.test(negative_movement_tweet_tesla, negative_movement_no_tweet_tesla, var.equal=TRUE, alternative = "two.sided")
res


# bitcoin ----
movement_no_tweet_bitcoin <- (filter(bitcoin_df, relevant_tweet_posted==FALSE))$movement
movement_tweet_bitcoin <- (filter(bitcoin_df, relevant_tweet_posted==TRUE))$movement
movement_bitcoin <- bitcoin_df$relevant_tweet_posted
length(movement_tweet_bitcoin)
length(movement_bitcoin)

no_tweet_at_all <- (filter(bitcoin_df, tweet_posted==FALSE))$movement
all_tweet_at_all <- (filter(bitcoin_df, tweet_posted==TRUE))$movement
varianzhomogenitaet_all <- var.test(no_tweet_at_all, all_tweet_at_all)
varianzhomogenitaet_all
res<-t.test(no_tweet_at_all, all_tweet_at_all)
res

#varianzhomogenitaet <- var.test(movement_tweet_bitcoin, movement_bitcoin) 
varianzhomogenitaet <- var.test(movement_tweet_bitcoin, movement_no_tweet_bitcoin) 
print(varianzhomogenitaet)

res<-t.test(movement_tweet_bitcoin, movement_no_tweet_bitcoin, var.equal=TRUE)
res

positive_movement_no_tweet_bitcoin <- (filter(bitcoin_df, relevant_tweet_posted==FALSE, movement>0))$movement
negative_movement_no_tweet_bitcoin <- (filter(bitcoin_df, relevant_tweet_posted==FALSE, movement<0))$movement
positive_movement_tweet_bitcoin <- (filter(bitcoin_df, relevant_tweet_posted==TRUE, movement>0))$movement
negative_movement_tweet_bitcoin <- (filter(bitcoin_df, relevant_tweet_posted==TRUE, movement<0))$movement

res<-t.test(positive_movement_tweet_bitcoin, positive_movement_no_tweet_bitcoin, var.equal=TRUE)


res<-t.test(negative_movement_tweet_bitcoin, negative_movement_no_tweet_bitcoin, var.equal=TRUE)
res

write.table(tweets_df, file="data\\Tweets_df.csv", sep=";")
write.table(tesla_df, "data\\Tesla_df.csv",  sep=";")
write.table(bitcoin_df, "data\\Bitcoin_df.csv",  sep=";")
sentiment_tesla_df <- read.xlsx2("data\\LM_Tesla.xlsx", 1, header=TRUE)
sentiment_bitcoin_df <- read.xlsx2("data\\LM_bitcoin_new.xlsx", 1, header=TRUE)
sentiment_bitcoin_df <-sentiment_bitcoin_df %>% replace(.=="ERROR", NA)
sentiment_tesla_df <-sentiment_tesla_df %>% replace(.=="ERROR", NA)
