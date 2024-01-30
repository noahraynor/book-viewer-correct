require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
  @paragraph = "happy birthday to you"
end

get "/" do
  @title = "Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number]
  # redirect "/" unless (1..@contents.size).cover? number
  @title = "Chapter #{number} #{@contents[number.to_i - 1]}"
  @chapter = File.read("data/chp#{params[:number]}.txt")
  erb :chapter
end

get "/search" do
  erb :search
end

get "/test/:name" do |name|
  @name = name
  erb :test
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    text = text.split("\n\n")
    start = -1
    text = text.map do |paragraph|
      start += 1
      "<a id='paragraph#{start}'</a><p>#{paragraph}</p>"
    end
    text.join("")
  end

  def searching(term)
    result = {}
    1.upto(12) do |chap_num|
      paragraphs = []
      chap_text = File.read("data/chp#{chap_num}.txt").split("\n\n")
      chap_text.each_with_index do |par_text, par_ind|
        paragraphs << [par_text, par_ind] if par_text.include?(term)
      end
      result[chap_num] = paragraphs unless paragraphs.empty?
    end
    result
  end

  def strongify(text, query)
    text.gsub(query, "<strong>#{query}</strong>")
  end

end

