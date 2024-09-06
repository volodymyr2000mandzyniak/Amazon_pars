# frozen_string_literal: true

require "amazon_pars/version"
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

Capybara.default_driver = :selenium_chrome
Capybara.default_max_wait_time = 10

# AmazonPars is the main module for the gem
module AmazonPars
  # JobScraper is responsible for scraping job listings from a given URL
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
        visit_job_page(job_url, index)
      end
    end

    def close_browser
      Capybara.reset_sessions!
      Capybara.current_session.driver.quit
    end

    private

    def visit_job_page(job_url, index)
      visit(job_url)
      sleep(3)

      if job_elements_present?
        extract_and_print_job_data(index)
      else
        puts_job_not_found(job_url)
      end
    end

    def job_elements_present?
      has_css?('h1.title') && has_css?('#apply-button')
    end

    def extract_and_print_job_data(index)
      job_title = find('h1.title').text.strip
      apply_link = find('#apply-button')[:href]
      location = extract_location
      description = find('#job-detail-body .col-md-7 > div > div:nth-child(2) > p').text.strip
      print_job_data(index + 1, job_title, apply_link, location, description)
    end

    def extract_location
      all('#job-detail-body .col-md-5 .association-content li').map(&:text).map(&:strip).first
    end

    def puts_job_not_found(job_url)
      puts '-' * 100
      puts "Job Title or Apply button not found on the page for URL: #{job_url}"
      puts '-' * 100
    end

    def print_job_data(index, title, link, location, description)
      puts '-' * 100
      puts "Job ##{index}"
      puts '-' * 100
      puts 'Job Title:'.ljust(20) + title
      puts 'Apply Link:'.ljust(20) + link
      puts 'Location:'.ljust(20) + location
      puts '-' * 100
      puts 'Description:'.ljust(20) + "\n#{description}"
      puts '=' * 100
    end
  end
end
