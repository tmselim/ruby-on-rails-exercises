# Smart Factory Ruby on Rails exercises

This set of exercises will lead you through building an app that allows a bicycle shop's employees to track orders for fulfilling custom bicycle orders.

## Development Setup

### Fork the project

Use the 'Fork' button on the upper right of the project's github page.

Later on, to update your fork, you'll need to do two things:

    $ git remote add upstream git@github.com:gosmartfactory/ruby-on-rails-exercises.git
    $ git fetch upstream

Only the second command will be required for future updates. Now, if you want to see what new branches are available to check out and merge from,

    $ git branch -r 

### Check out a local copy:

    $ git clone git@github.com:<your_github_username>/ruby-on-rails-exercises.git

### Install the dependencies

    $ cd ruby-on-rails-exercises
    $ bundle install

## Exercise Set #1

### Add a gem

Before writing any code, we would like to make a configuration change. Most projects we see use the [Haml](http://haml.info/) templating language, rather than Rails' default ERB. So, let's configure the app to use Haml.

Add the following line to `Gemfile`:

    gem 'haml-rails'

Now type `rails s` to start the server. You'll get an error, because the gem you just added isn't installed yet. Tell bundler to install the missing gems:

    $ bundle install

### Generate a scaffold

Our initial requirements are simply to allow creating and listing orders with a few fields for each order:

 * `customer_name`
 * `customer_email`
 * `description`
 * `price`
 * `paid_for_on` (the date that the bike was paid for).

Since this sounds like standard CRUD, use rails' scaffold generator to create an `Order` model and UI. You used the scaffold generator already if you followed the pre-class install instructions. For a review of how it works, run

    $ rails g scaffold
    
from the command line of your project directory.

### Migrate the DB

Now that the generator has defined a table, it's time to set up the database:

    $ rake db:migrate

If your server isn't already running, start it:

    $ rails s

Point your web browser to `http://localhost:3000/orders`, and create a few orders.

### Improve the style

They're pretty hard to read in the listing, aren't they? We've put some simple CSS together that should help with that, and stuck it in `examples/orders.css.scss`. Put those rules in an appropriate place so that Rails knows about them, then modify the orders index view so that the new CSS rules get used.

(No worries if you aren't familiar with CSS! Just ask and we'll give you a few hints about what you need to do.)

### Add validation rules

The default UI for entering the date that the order was paid for doesn't allow the field to be left blank, which is necessary in case the customer hasn't paid yet. Change it to a text input, so that it can be left blank until the order is paid for.

As the app stands now, it's possible to create orders that are missing vital information. Let's fix that -- make the customer name, customer email, description, and price required.

