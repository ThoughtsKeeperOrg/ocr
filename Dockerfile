# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.6

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS builder
ARG BUNDLE_WITHOUT="development test"
ARG BUNDLE_PATH="/bundle"
ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
    BUNDLE_PATH=${BUNDLE_PATH}

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /ocr_app
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local path "${BUNDLE_PATH}" && \
    bundle config set --local without "${BUNDLE_WITHOUT}" && \
    bundle install --deployment --jobs 4 --retry 3

COPY . /ocr_app

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS runtime
ARG BUNDLE_WITHOUT="development test"
ARG BUNDLE_PATH="/bundle"
ENV KARAFKA_ENV="production" \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
    BUNDLE_PATH=${BUNDLE_PATH}

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  tesseract-ocr \
  tesseract-ocr-ukr \
  tesseract-ocr-deu \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /ocr_app
COPY --from=builder "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=builder /ocr_app /ocr_app

# Use the runtime stage as the final image
USER root

# Add a default command if you want. Uncomment and adapt as needed:
# CMD ["bundle", "exec", "karafka", "server"]
