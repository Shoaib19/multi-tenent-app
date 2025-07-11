FROM ruby:3.4.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

# Set working directory
WORKDIR /app

# Cache bundle
COPY Gemfile Gemfile.lock ./
RUN bundle i

# Add app code
COPY . .

# Precompile assets (optional - if using sprockets/webpacker)
# RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rails db:create db:migrate && bundle exec rails server -b 0.0.0.0"]
