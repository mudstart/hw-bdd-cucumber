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
  before = get_index_of_movie(e1)
  after = get_index_of_movie(e2)
  expect(before + 1 == after).to eq true
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  #byebug
  rating_list.split(',').each do |rating|
    rating.strip!
    if uncheck 
      step  "I uncheck \"ratings_#{rating}\""
    else
      step  "I check \"ratings_#{rating}\""
    end
  end
end

Then /I should( not)? see the movies with the following ratings: (.*)/ do |neg, rating_list|
  movies_on_page = []
  page.all('table#movies tr').each do |tr|
    next if tr.has_selector?('th')
    title = tr.all('td')[0].text
    rating = tr.all('td')[1].text
    movies_on_page.push({title: title, rating: rating})
  end
  rating_list.split(',').each do |rating|
    rating.strip!
    Movie.all.where(rating: rating).each do |movie|
      cur_movie = {title: movie.title, rating: rating}
      if neg and movies_on_page.include?(cur_movie)
        fail
      elsif !neg and not movies_on_page.include?(cur_movie)
        fail
      end
    end
  end

end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  fail "Unimplemented"
end
