require 'spec_helper'
require 'image_size'
require 'pdf/reader'

module Capybara::Poltergeist
  describe Driver do
    before do
      @session = TestSessions::Poltergeist
      @driver = @session.driver
    end

    after { @driver.reset! }

    def session_url(path)
      server = @session.server
      "http://#{server.host}:#{server.port}#{path}"
    end

    after { @session.save_screenshot }

    it 'works' do
      @session.visit('/controlpanel/bz')

      @session.execute_script '$.fx.off = true'
      @session.click_on('Next')
      @session.should have_content('Random comment #22!')

      # Delete last comment:
      @session.find(:css, '#comment_1599 .btn.delete').click
      @session.should have_content 'Are you sure you want to delete this item'
      @session.find(:css, '#zoogle_dialog a.negative').click
      sleep 1
      @session.should have_content 'Unapproved 14'
      @session.should have_content 'Deletion worked'

      # Approve last comment:
      @session.within(:css, "#comment_1601") do
        @session.click_on "Approve comment"
      end
      sleep 1
      @session.should have_content 'Approval worked'
      @session.should have_content 'Unapproved 13'

      # @session.save_screenshot  # If you take a screenshot, then the click works
      @session.execute_script "console.log('**** Top of All button is at:', $('.all').offset().top)"
      @session.click_on 'All'
    end
  end
end
