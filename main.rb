require_relative 'lib/amazon_pars'

scraper = JobScraper.new('https://amazon.jobs/content/en/job-categories/administrative-support')
job_urls = scraper.scrape_job_urls
scraper.scrape_jobs_data(job_urls)
scraper.close_browser
