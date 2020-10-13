require 'fileutils'

def run()
    puts "Time to create a new project!"
    puts "Which project would you like to create?"
    puts "\n"
    puts "Write number"

    # puts "Webshop [1]"
    puts "Random site [1]"

    answer = gets.chomp
    
    case answer
    # when "1"
    #     webshop()
    when "1"
        random_site()
    end
end

def random_site()
    puts "Random site selected\n"
    puts "Which path would you like to use? (Use . for current dir)"
    path = gets.chomp

    puts "Enter name for project"
    project_name = gets.chomp

    file_path = "#{path}/#{project_name}"
    FileUtils.mkdir_p file_path
    FileUtils.mkdir_p "#{path}/#{project_name}/server"
    FileUtils.mkdir_p "#{path}/#{project_name}/misc"

    ##Creating server.rb file

    server_rb = File.new("#{file_path}/server.rb", "w")
    server_rb.puts("require 'sinatra'")
    server_rb.close

    ##Creating files withing dir "server"
    
    path = "#{file_path}/server"
    
    gemfile = File.new("#{path}/Gemfile", "w")
    gemfile.puts("
source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'slim'
gem 'sqlite3'
gem 'rerun'
gem 'bcrypt'
gem 'pony'
gem 'dotenv'
gem 'stripe'                                        
    ")

    gemfile.close

    yml = File.new("#{path}/app.yml", "w")
    yml.close

    app_rb = File.new("#{path}/app.rb", "w")
    app_rb.puts("
class Site < Sinatra::Base
    Dotenv.load
    enable :sessions

    get '/' do

        slim :index
    end

end
    ")
    app_rb.close


    config_ru = File.new("#{path}/config.ru", "w")
    config_ru.puts("
require 'sinatra/base'
require 'bundler'
require 'json'

Bundler.require

require_relative 'app'

run Site
    ")

    config_ru.close

    ##Creating public folder

    public_path = "#{path}/public"
    
    FileUtils.mkdir_p public_path
    
    FileUtils.mkdir_p "#{public_path}/css"
    FileUtils.mkdir_p "#{public_path}/img"
    FileUtils.mkdir_p "#{public_path}/js"

    css_path = "#{public_path}/css"

    scss = File.new("#{css_path}/main.scss", "w")
    scss.puts("
    
body{
    margin: 0;
    top: 0;
}

.wrapper{
    width: 100vw;
    min-height: 100vh;
    height: fit-content;
}

    ")

    scss.close

    js_path = "#{public_path}/js"
    js = File.new("#{js_path}/main.js", "w")
    js.close

    view_path = "#{path}/views"

    FileUtils.mkdir_p view_path

    layout_slim = File.new("#{view_path}/layout.slim", "w")
    layout_slim.puts("
<!DOCTYPE html>
    html lang='en'
head
    meta charset='UTF-8'
    meta name='viewport' content='width=device-width, initial-scale=1.0'/
    title #{project_name}
    link rel='stylesheet' href='css/main.css'/
body
    == yield
script src='js/main.js'
== slim :html_templates
    ")
    layout_slim.close

    index_slim = File.new("#{view_path}/index.slim", "w")
    index_slim.close
    html_templates = File.new("#{view_path}/html_templates.slim", "w")
    html_templates.close
    FileUtils.mkdir_p "#{view_path}/partials"
end

run()