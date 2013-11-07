# Smart Factory Ruby on Rails exercises

This set of exercises will lead you through building an app that allows a bicycle shop's employees to track orders for fulfilling custom bicycle orders.

## Exercise Set 7

Once a large number of frames are loaded into the system, it can be tricky to find the right one when entering an order. Let's update the order form so that it has two selects, one for the brand and one for the frame. Once a brand is selected, we'll use javascript to populate the frame select.

### Make the lists of Frames available

First, we're going to need a way to retrieve the list of frames for a given brand. Let's start with a route: add `get 'frames'` to `resources :brands`, similarly to how Orders are customized.

Now we'll work on the controller. The following method will return all of the frames for a brand:

```ruby
def frames
  @frames = Brand.find(params[:brand_id]).frames.order(:name)
  render '/frames/index'
end
```

The last line of that method says that, rather than looking in the normal place for the View, use the existing index in `/app/view/frames/`. This saves us from having to write another view that does the same thing as an existing one.

With all of that in place, assuming you have a brand 1 in the database and that there are some frames that belong to it, you should be able to visit `http://localhost:3000/brands/1/frames` in your browser and see the list of frames.

Handy, but that's not a very useful format for javascript to use. Add `.json` to the end of that URL, and you'll get a JSON representation of the same data.

We need to make one change to that JSON: right now, it returns the name of the frame and the brand id, but it doesn't return the frame's id (which we'll need to save on the Order). Open up `/app/views/frames/index.json.jbuilder` and add `:id` along with `:name` and `:brand_id`.

### Update the Order model

Since completing Exercise 5, we've been able to say things like `@brand.orders`. However, we didn't hook up the other end of that association, so we can't say `@order.brand`. Let's fix that by adding an association to the order model: `has_one :brand, through: :frame`. While we're in that file, we're going to want to be able to access brand_id for the Order form, so add the following method:

```ruby
def brand_id
  brand ? brand.id : nil
end
```

### Add brands to the Order form

Time to update the order form. First, we'll add the Haml to show the Brand. Above the existing Frame select, add:

```haml
.field
  = f.label :brand
  = collection_select :order, :brand_id, Brand.all.order(:name), :id, :name, {}, { size: 10, data: { select: :brand } }
```

Save the view, and load the order form in your browser. View source or use 'inspect element' to see what HTML is generated. The `data-select` attribute is going to come in handy soon.

Next, we'll change the Frame select. Currently, it selects a list of all Frames in the system. We want the form to just create enough HTML for our javascript to populate at the right time. Replace the existing collection_select with this:

```haml
%select{id: :order_frame_id, size: 10, name: 'order[frame_id]', data: { select: :frame } }
  %option Please select a brand
```

Almost done! All we need to do now is to get that Frame list populated when a Brand is selected.

### Javascript time!

Well, coffeescript time, technically. Place the following in `app/assets/javascripts/orders.js.coffee`:

```coffeescript
$ ->
  $('[data-select~=brand]').change (event) ->
    brand_id = $(event.target).val()
    $.get "/brands/#{brand_id}/frames.json", (data) ->
      options = ''
      if data.length == 0
        options = '<option>No frames for that brand</option>'
      else
        for frame in data
          options += "<option value='#{frame.id}'>#{frame.name}</option>"

      $('[data-select~=frame]').html(options)
```

Reload the form, and select a Brand that has one or more Frames. You should be able to pick the frame and save the page, and everything should work.

----

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

## Previous Exercises

### Exercise Set 1

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

### Allow blank 'paid' dates to be entered

The default UI for entering the date that the order was paid for doesn't allow the field to be left blank, which is necessary in case the customer hasn't paid yet. Change it to a text input, so that it can be left blank until the order is paid for.

### Add validation rules

As the app stands now, it's possible to create orders that are missing vital information. Let's fix that -- make the customer name, customer email, description, and price required.

### Exercise Set 2

1. If you try to load the root of the site, `http://localhost:3000/`, you just see the default Rails homepage. Replace that with a simple welcome screen, which we'll build upon later. Just have it say "Welcome to the Bike Shop Order Tracker" and link to the /orders page.
1. As we add more sections to the site, we'll want site navigation to allow users to get around. Go ahead and change the site layout so that every page links to the new homepage, as well as to the /orders page.
1. Time to make the homepage more useful. In addition to welcoming the user, alter the page so that it displays the number of orders that haven't been paid for yet.
1. Employees are complaining about having to click onto an order's `edit` page to set the paid-on date, and at having to type in the date since it's usually the same date that they're updating the record on. To make their lives easier, add a `Mark Paid` link next to any unpaid orders on the `/orders` listing. When the employee clicks the link and confirms that the order has been paid, the record should be updated accordingly.

### Exercise Set 3

### Add a field

The bike shop has decided that they'd like to start keeping track of when they finish assembling a bike. This will allow them to do useful things like generate a list of bikes that have been completed but not paid for.

First, we'll need to update the database by adding a column to store the new field. We'll do this by generating a migration. From the command line in your project:

`$ rails g migration AddCompletedDate`

That will create an empty migration in the `db/migrate` folder, with a name based on what you just entered in the generator. Open that file in your text editor and add the following line to create the column:

`add_column :orders, :completed_on, :datetime`

Now that we've written the instructions for creating the column, it's time to actually create it in the database. From the command line:

`$ rake db:migrate`

For more on migrations, see [the Migration guide](http://guides.rubyonrails.org/migrations.html).

### Allow the field to be saved to the database

Now the field is defined in the database, but we have no way to read or write it through the web. First, let's add it to the order form, which you may recall is located in `app/views/orders/_form.html.haml`. You can copy the input for the paid_on date and update the copy to refer to the new column.

At this point, we can submit a completion date to the server, but it won't be saved. Why not? Because it would be insecure for our controller to accept updates to any arbitrary field. (If you want to see the warning generated when we attempt to save an unauthorized field, submit your newly modified form and look for the "Unpermitted parameters" line in the server log.)

To let Rails know that it's OK to accept updates to the completed_on field, open up the Orders controller in your editor, and add the field to the list in the `order_params` method. For more on this topic, see [the ActionController guide](http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters).

Next, let's display the completion date when the order detail page is displayed. That's handled by the `show` template.

Finally, let's show the completion date on the orders index, and sort the orders so that unfinished orders show up first.

### Additional Challenges

1. Since an order is always entered into the system before it's completed, it's not necessary to display the completion date when creating a new order. Can you modify the new and edit forms so that they share as much as possible, but have this difference? The ActionView guide [has a helpful section](http://guides.rubyonrails.org/layouts_and_rendering.html#using-partials).
1. The shop manager is concerned that employees may enter future dates in the completion field, before an order is actually finished. She would like to prevent that, by requiring that the completion date always be equal to or earlier than today's date. Add a validation to enforce that rule. By now you should have a good idea where to look for a reference on the available options.
1. Add a count of unfinished orders on the homepage, so that it's clear how much work needs to be done. We did a similar exercise last time -- if you completed that exercise and your solution included a scope on the model, try using a class method this time, and vice versa.
1. Employees would like to be able to just click a single link to mark an order completed, rather than editing the order and entering the current date. Note that this task is similar to the 'mark paid' button from the last exercise set.

## Exercise Set 4

Instead of using only a free-form description field, the bicycle shop wants to systematically track the brand of bicycle for each order. We'll add a new model for bicycle brands, then create an association between brands and orders.

### Create the Brand model

Use Rails scaffolding to create a new brand model. For now, all brands need is a "name" attribute.

Hint: if you don't remember how to generate a scaffold, you can always get help at the command line:

    rails g scaffold

Look over the files the scaffold generated. Familiarize yourself with what just got added to your project.

The scaffold generates a new controller and new views for managing brands, but there are no links to it in your UI. Add a link to brands in the page header.

Create a few brands to make sure things are working.

### Create the order-brand association

We want to make it so that each order has a brand, and each brand has many orders.

To the order model (in `order.rb`), add:

    belongs_to :brand

...and in the brand model (`brand.rb`), add:

    has_many :orders

Now you have an association, but something is missing! Try it out using the Rails console:

    $ rails c
    Loading development environment (Rails 4.0.0)
    2.0.0p247 :001 > Order.first.brand

You'll get an error message. What's wrong? You added an assocation to your code, but not yet in the database. The orders table needs a brand_id column to make things work. (However, the brands table should not have an order_id column. Why not?)

Generate a new AddBrandToOrder migration with the following line:

    add_column :orders, :brand_id, :reference
    
The "reference" type just becomes an integer in the database, but declaring it as a reference lets Rails know our true intention.

Now the rails console experiment above should work.

[More info about Rails Associations](http://guides.rubyonrails.org/association_basics.html)

### Update the order form

Order can now have brands, but there's no way to select one in the UI.

Edit the order form (`app/views/orders/_form.html.haml`) to add a new text field for brand. How does that work? Answer: badly. (But do try it and see what happens.)

What we really want is a select box, not a free-form text field. Read about the Rails [collection_select](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-collection_select) helper, and use that to create a select box with the names of the various available brands.

You'll need to update the controller so the brand actually gets saved. Hint: look at exercise 3.

### Update the order index

Add a column to the orders index and show pages so that you can see the brand of each order.

Some previously created orders may not have brands. Make sure that doesn't blow things up!

### Challenges

* Make the brand a required field for orders. Should you require `brand` or `brand_id` on orders? Google around and read the debate!
* Some brands may go out of business and stop accepting orders. Add a boolean `active` flag to the brand model, then change the UI so it only shows active brands when editing an order.
* Oops! That's not quite good enough: an existing order may use an inactive brand — but we want to preserve that. Change the UI so it shows only active brands for new orders, but _all_ brands for existing orders.

## Exercise Set 5

Employees have pointed out that knowing the specific frame to be used when assembling a bike is more helpful than just knowing what company made the frame. We'll still keep track of the brand, since we need to be able to easily get a list of frames by brand when assessing if need parts.

### Generate a scaffold for frame

Frames are pretty simple: they have a name, and they know what Brand they belong to. Look back to previous exercises if you need a reminder about generating scaffolds.

### Add frames to the navigation

This is much the same as the task we did in Exercise Set 4, for Brands, and earlier for Orders.

### Change the associations

Now we have a way to record Frames, but we're still working with Brands when creating Orders. The first thing to do to fix that is to update the associations between Orders, Brands and Frames. 

Right now, our Order model has this association: `belongs_to :brand`. Brand has the reciprocal association `has_many :orders`. We're going to remove both of those, because we want Orders directly connected to Frames, not Brands. Once we have that association, we'll be able to indirectly connect Orders and Brands.

First, let's update the database so that the tables have the proper references. Generate a new migration with the following changes:

    remove_reference :orders, :brand
    add_reference :orders, :frame

Now, after running migrations, we can update the associations.

 * Order now `belongs_to :frame`
 * Brand now `has_many :frames`
 * Frame now `belongs_to :brand` and `has_many :orders`

You can test that the new associations work using the rails console, `rails c`.

### Update the views and controllers

OK, we've updated our models — but our views and and controllers are now broken.

Look through the order views, and make sure they all know that order now has a frame instead of a brand. Make `views/orders/show.html.haml` display both the brand _and_ the frame.

Make sure you've showing a drop-down list of frames instead of brands in `views/orders/_form.html.haml`. You'll also need to change the Order validation of brand_id to frame_id, and update the Order controller's order_params method to permit :frame_id rather than :brand_id.

Any other views need updating?

### Now the fun part

We would like to show all orders for a given brand. The relationship is indirect: brands have many frames, and each frame has many orders. However, we can ask Rails to roll that chain into a single relation and give it a name. To the Brand model, add:

    has_many :orders, through: :frames

Now you can ask a brand for all of its orders:

    brand = Brand.find(some_id)
    brand.orders

Use this to add a list of all orders for a given brand to `views/brands/show.html.haml`. Hint: look at one of the index views to see how to list the elements of a collection.

Once you have that working, change it so it only shows the paid but uncompleted orders for the brand. Hint: you can chain associations with named scopes.

See [the Association Guide](http://guides.rubyonrails.org/association_basics.html) for background and more detail on ActiveModel associations.

## Exercise Set 6

Our scaffolding generated some tests. I’ve updated them to work with the new fields we added, and also switched them from using Rails fixtures over to Factory Girl.

### Add some model tests

Add tests to verify that some of the existing features of the models work. Refer to `test/models/brand_test.rb` for reference.

To run your tests, use:

    bundle exec rake test

You may find the [http://guides.rubyonrails.org/testing.html](Rails testing) and [https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md](Factory Girl) guides useful.

### Add a test for a new feature

We’d like to make brands require a name — but don’t do it yet! We’re going to implement it using _test first programming._

* Run your tests and make sure they’re all passing.
* Write a test that asserts that name is a required field on brand. It isn’t (yet), so this test should fail!
* Run your tests to make sure that your new test fails as expected.
* Change your code to implement the new behavior.
* Run your tests again. They should pass!

---
