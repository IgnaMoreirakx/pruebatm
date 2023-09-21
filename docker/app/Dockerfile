FROM ruby:2.7.1

# Instala las dependencias del sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Instala Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Define el directorio de la aplicación y establece las variables de entorno
ARG secret_key_base
ENV RAILS_ROOT /var/www/app_name
ENV RAILS_MASTER_KEY=${secret_key_base}
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Copia los archivos de la aplicación y Gemfile
COPY Gemfile Gemfile.lock ./
COPY . .

# Instala las gemas de Ruby
RUN bundle install

# Instala las dependencias de JavaScript y compila los assets
RUN rails assets:precompile

# Expone el puerto 3000 y configura el comando para iniciar la aplicación
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
