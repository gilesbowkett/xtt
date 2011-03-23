Getting Started in Development
==============================

    cp config/database.sample.yml config/database.yml
    rake gems:install
    rake db:create:all db:schema:load

Run the specs:

    rake spec

To use at http://localhost:3000/ :

* Add a user at http://localhost:3000/signup
* If you don't get a confirmation email (which you likely won't since you don't have the mail sending configured), check log/development.log for a copy of the confirmation email that would have been sent to you, copy and paste the activation url from it into the browser toolbar (should look like the following: http://tt.entp.com/activate/db61f839776898cedee72fcb9f87465d797e2e93 - of course, replace tt.entp.com with your dev server address.

Other Shit
==========

The railsmachine repo includes a bunch of instructions for getting up and running with Moonshine. Without Moonshine, I think only one of those files is actually necessary:

### config/initializers/custom.rb

    TT_HOST  = 'example.com'
    TT_EMAIL = 'admin@example.com'
    SIGNUPS_ENABLED = false

    ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update \
     :time => '%I:%M %p'

