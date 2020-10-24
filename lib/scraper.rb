require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    html_parsed = Nokogiri::HTML(html)

    student_array = []

    html_parsed.css('.student-card').each do |student|
      name = student.css('.student-name').text
      location = student.css('.student-location').text
      profile_url = student.css('a').attribute('href').value
      student_array << {name: name, location: location, profile_url: profile_url}
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    profile_html = open(profile_url)
    profile_html_parsed = Nokogiri::HTML(profile_html)

    student_hash = {}

    paths = profile_html_parsed.css('.social-icon-container').css('a').map do |link|
      link.attribute('href').value
    end

    paths.each do |path|
      if path.include?("twitter")
        student_hash[:twitter] = path
      elsif path.include?("linkedin")
        student_hash[:linkedin] = path
      elsif path.include?("github")
        student_hash[:github] = path
      else
        student_hash[:blog] = path
      end
    end
    student_hash[:profile_quote] = profile_html_parsed.css('.profile-quote').text
    student_hash[:bio] = profile_html_parsed.css('.description-holder p').text
    student_hash
  end

end

