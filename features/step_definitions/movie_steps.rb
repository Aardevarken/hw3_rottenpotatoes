# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{string2}/m
  page.body.should =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(/\s*,\s*/)
  ratings.each do |rating|
    step "I #{uncheck}check \"ratings_#{rating}\""
  end
end

When /^I (un)?check all ratings$/ do |uncheck|
  allRatings = ""
  Movie.all_ratings.each do |rating|
    allRatings + rating + ", "
  end
  step "I #{uncheck}check the following ratings: #{allRatings}"
end

Then /^I should (.*) the movies with the following ratings: (.*)/ do |seen, rating_list|
  ratings = rating_list.split(/\s*,\s*/)
  case seen
  when "not seen"
    movies = Movie.find_all_by_rating(Movie.all_ratings - ratings)
  else
    movies = Movie.find_all_by_rating(ratings)
  end
  movies.each do |movie|
    step "I should #{seen} \"#{movie.title}\""
  end
end

Then /^I should see all of the movies$/ do
  step "I should see the movies with the following ratings: #{Movie.all_ratings}"
end


