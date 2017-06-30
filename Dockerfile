FROM ruby:2.4

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash

RUN apt-get update && apt-get install -y nodejs libmysqlclient-dev
RUN npm install -g yarn

RUN curl -sL https://kaigara.org/get | bash

RUN groupadd -r demo --gid=1000
RUN useradd -r -m -g demo -d /home/demo --uid=1000 demo

WORKDIR /home/demo

ENV BUNDLE_PATH=/bundle

ADD Gemfile /home/demo/Gemfile
ADD Gemfile.lock /home/demo/Gemfile.lock
ADD package.json /home/demo/package.json

RUN bundle install
RUN yarn

ADD . /home/demo

RUN chown -R demo:demo /home/demo /bundle
USER demo

EXPOSE 8080

CMD ["bundle", "exec", "rails", "server", "-p", "8080", "-b", "0.0.0.0"]
