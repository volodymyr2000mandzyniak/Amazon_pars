require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

Capybara.default_driver = :selenium_chrome
Capybara.default_max_wait_time = 10

class JobScraper
  include Capybara::DSL

  def initialize(url)
    @url = url
  end

  def scrape_job_urls
    visit(@url)
    sleep(3)  
    job_urls = all('a.header-module_title__9-W3R').map { |job_link| job_link[:href] }
    puts "Found #{job_urls.size} job links."
    job_urls
  end

  def scrape_jobs_data(job_urls)
    job_urls.each_with_index do |job_url, index|
      visit(job_url)
      sleep(3)  

      if has_css?('h1.title') && has_css?('#apply-button')
        job_title = find('h1.title').text.strip
        apply_link = find('#apply-button')[:href]
        location = all('#job-detail-body .col-md-5 .association-content li').map(&:text).map(&:strip).first
        description = find('#job-detail-body .col-md-7 > div > div:nth-child(2) > p').text.strip

        print_job_data(index + 1, job_title, apply_link, location, description)
      else
        puts "-" * 100
        puts "Job Title or Apply button not found on the page for URL: #{job_url}"
        puts "-" * 100
      end
    end
  end

  def print_job_data(index, title, link, location, description)
    puts "-" * 100
    puts "Job ##{index}"
    puts "-" * 100
    puts "Job Title:".ljust(20) + title
    puts "Apply Link:".ljust(20) + link
    puts "Location:".ljust(20) + location
    puts "-" * 100
    puts "Description:".ljust(20) + "\n#{description}"
    puts "=" * 100
  end

  def close_browser
    Capybara.reset_sessions!
    Capybara.current_session.driver.quit
  end
end

