# syntax=docker/dockerfile:1
# check=error=true

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set production environment
ENV KARAFKA_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development test"

RUN apt-get update -qq && apt-get install -y \
  build-essential tesseract-ocr

RUN mkdir /ocr_app

WORKDIR /ocr_app

COPY Gemfile Gemfile.lock ./

RUN bundle install --deployment

COPY . /ocr_app
