# Description:
#
# This file is written as an a self-contained R script so that it can be
# modified easily. The goal here is to scrape the results of primary elections
# from Politico.
#
# The general workflow for R code is to modify the script, save the changes,
# and then reload the functions in R with the command
#
#     source("politico.R")
#
# This makes it easy to modify the functions until they do what's needed.
#
# The 3 functions in this file were written in the order they appear.
#
# As you read, notice that none of the CSS selectors are particularly tricky.
# The Politico web page is well-organized and although the task seems large,
# it's not too hard once it's broken into smaller steps.
#
# Also make sure to try these functions out as you read.

library("rvest")


# Download the Politico website.
read_politico = function() {
  politico = "http://www.politico.com/2016-election/results/map/president"
  doc = read_html(politico)

  # Recall that the last line of a function is the return value, unless there's
  # an explicit return() statement.
  html_nodes(doc, ".timeline-group")
}


# Scrape just one state, say Colorado.
scrape_state = function(state) {
  # Extract the state's name.
  name = html_node(state, ".timeline-header h3 a")
  name = html_text(name, trim = TRUE)

  # Extract the results for each primary.
  repub = html_nodes(state, ".contains-republican")
  #
  # The scrape_primary() function is our way of saying "I'll deal with this
  # particular problem later". The details don't matter yet--we just assume
  # that scrape_primary() exists and returns the correct output.
  #
  # How would you know to make a scrape_primary() function? The key here is
  # that we want to do the same thing twice (for Republicans and Democrats).
  # Repeating the same thing is usually a sign you should write a function.
  # Moreover, scraping one primary is a complicated task in its own right,
  # which is another signal that it should be a separate function.
  #
  repub = scrape_primary(repub, "Republican")
  
  democ = html_nodes(state, ".contains-democrat")
  democ = scrape_primary(democ, "Democrat")

  out = rbind(repub, democ)
  out$state = name

  return(out)
}


# Now we can define the scrape_primary() function based on its assumed role
# above. We may have to tweak the code above slightly as we write this
# function, but that's just part of the development process.
#
# Scrape just one party's primaries within a state.
scrape_primary = function(primary, party) {
  results = html_table(html_nodes(primary, ".results-table"))
  delegates = html_text(html_nodes(primary, ".results-headings .pos-1"))

  # An if-statement checks whether the condition is true. If the condition is
  # true, the code inside the { } is evaluated. Otherwise, the code inside the
  # { } is skipped.
  #
  # In this case, we return nothing (NULL) immediately if no primary results
  # were found.
  if (length(results) == 0) {
    return(NULL)
  }

  # After passing the if-statement, we can safely assume some primary results
  # were found. This function only returns the first result, which would be a
  # major limitation if parties typically had multiple primaries within a
  # state.
  results = results[[1]]
  colnames(results) = c("candidate", "percent", "votes", "delegates")
  results$total = delegates
  results$party = party

  return(results)
}
