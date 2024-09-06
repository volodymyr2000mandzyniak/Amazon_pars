## AmazonPars

## Description.

`AmazonPars` is a Ruby gem designed to scrape job listings from the Amazon Jobs website.


## Requirements

- Ruby 3.2 or later
- `Capybara`.
- `Selenium WebDriver`.
- `chromedriver` for the Chrome browser


## Installation

To install the gem, add this line to your application's Gemfile:

```ruby
gem 'amazon_pars'

№№ Usage
## Installation
require 'amazon_pars'

# Initialize the scraper with the URL of the job category page
scraper = AmazonPars::JobScraper.new('https://amazon.jobs/content/en/job-categories/administrative-support')

# Scrape job URLs
job_urls = scraper.scrape_job_urls

# Scrape and display job details for each job
scraper.scrape_jobs_data(job_urls)

# Close the browser after scraping
scraper.close_browser
