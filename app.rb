require 'pry'
require 'sinatra'
require 'better_errors'
require 'sinatra/reloader'
require 'pg'

require './models/squad'
require './models/student'

set :conn, PG.connect( dbname: 'weekendlab' )

before do
  @conn = settings.conn
  Squad.conn = @conn
  Student.conn = @conn
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# SQUAD ROUTES

get '/' do
  redirect '/squads'
end

get '/squads' do                              #display all squads
  @squads = Squad.all
  erb :'squads/index'
end

get '/squads/new' do                          #display create squad page
  erb :'squads/add'
end

get '/squads/:id' do                          #display specific squad
  @squad = Squad.find params[:id].to_i 
  erb :'squads/show'
end

get '/squads/:id/edit' do                     #display squad edit
  @squad = Squad.find params[:id].to_i
  erb :'squads/edit'
end

post '/squads' do
  Squad.create params
  redirect '/squads'
end

put '/squads/:id' do
  s = Squad.find(params[:id].to_i)
  s.name = params[:name]
  s.mascot = params[:mascot]
  s.save
  redirect '/squads'
end

delete '/squads/:id' do
  Squad.find(params[:id].to_i).destroy
  redirect '/squads'
end

# STUDENT ROUTES

get '/squads/:squad_id/students' do                           #display all students from a squad
  @students = Squad.find(params[:squad_id].to_i).students
  erb :'students/index'
end

get '/squads/:squad_id/students/new' do                       #display create student page
  @squad_id = params[:squad_id].to_i
  erb :'students/add'
end

get '/squads/:squad_id/students/:student_id' do                       #display specific student
  @student = Student.find params[:squad_id].to_i

  erb :'students/show'
end

get '/squads/:squad_id/students/:student_id/edit' do          #display student edit
  @student = Student.find(params[:id].to_i, params[:squad_id].to_i).students
  @student = student[0]
  erb :'students/edit'
end

post '/squads/:squad_id/students' do                          #create new student
  Student.create params
  redirect "/squads/#{params[:squad_id].to_i}"
end

put '/squads/:squad_id/students/:student_id' do               #update student info
  Student.edit params
  redirect "/squads/#{params[:squad_id].to_i}"
end

delete '/squads/:squad_id/students/:student_id' do            #destroy student
  
  redirect "/squads/#{params[:squad_id].to_i}"
end
