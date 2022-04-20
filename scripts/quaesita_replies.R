library(tidyverse)
library(graphTweets)
library(rtweet)



tweets <- stream_in("/home/knut/Desktop/quaesita2.json")

long <- data.table::melt(tweets %>% select(name, reply_to.0.name, reply_to.1.name, reply_to.2.name, reply_to.3.name, reply_to.4.name, reply_to.5.name), id.vars = c("name"), measure.vars = c("reply_to.0.name", "reply_to.1.name", "reply_to.2.name", "reply_to.3.name", "reply_to.4.name", "reply_to.5.name"))
long <- na.omit(long) 
  
long %>% 
  gt_edges(name, value) %>% 
  gt_nodes() %>% 
  gt_collect() -> gt


library(visNetwork)
library(data.table)

nodes <- data.table(label=unique(c(long$name, long$value))) %>% distinct() %>% mutate(id=row_number(), shape="box")

from <- long %>% left_join(nodes %>% rename(name=label, from=id))
to <- long %>% left_join(nodes %>% rename(value=label, to=id))


edges <- data.frame(from=from$from, to=to$to)


visNetwork(nodes, edges, height = "700px", width = "100%")

