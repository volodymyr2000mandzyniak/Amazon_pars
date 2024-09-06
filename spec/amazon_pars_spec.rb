# spec/amazon_pars_spec.rb

require 'rspec'
require 'capybara'
require 'selenium-webdriver'
require_relative '../lib/amazon_pars'

RSpec.describe AmazonPars::JobScraper do
  let(:url) { 'https://amazon.jobs/content/en/job-categories/administrative-support' }
  let(:scraper) { AmazonPars::JobScraper.new(url) }

  before do
    allow(scraper).to receive(:visit) # Mock visit method to avoid real network requests
    allow(scraper).to receive(:sleep) # Avoid delays in testing
  end

  describe '#scrape_job_urls' do
    it 'returns an array of job URLs' do
      # Mock elements to return a double object that responds to :[]
      mock_elements = [double('element', href: 'http://example.com/job1'), double('element', href: 'http://example.com/job2')]

      # Explicitly mock the [] method to return the href value
      allow(mock_elements[0]).to receive(:[]).with(:href).and_return('http://example.com/job1')
      allow(mock_elements[1]).to receive(:[]).with(:href).and_return('http://example.com/job2')

      allow(scraper).to receive(:all).and_return(mock_elements)

      job_urls = scraper.scrape_job_urls

      expect(job_urls).to eq(['http://example.com/job1', 'http://example.com/job2'])
      expect(scraper).to have_received(:visit).with(url)
    end
  end

  describe '#scrape_jobs_data' do
    let(:job_urls) { ['http://example.com/job1', 'http://example.com/job2'] }

    it 'scrapes job data from each job URL' do
      allow(scraper).to receive(:visit_job_page)

      scraper.scrape_jobs_data(job_urls)

      job_urls.each do |job_url|
        expect(scraper).to have_received(:visit_job_page).with(job_url, anything)
      end
    end
  end

  describe '#close_browser' do
    it 'resets Capybara sessions and quits the browser' do
      expect(Capybara).to receive(:reset_sessions!)
      expect(Capybara.current_session.driver).to receive(:quit)

      scraper.close_browser
    end
  end
end
