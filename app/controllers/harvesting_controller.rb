class HarvestingController < ApplicationController

  def index
  end

  def select #Harvest API data and selecting params
  	@user = User.new
  subdomain = 'safetycheckinc'
	username = 'gscannell@safetycheckinc.com'
	password = 'safetycheck'
	harvest = Harvest.hardy_client(subdomain: subdomain, username: username, password: password)
	@clients = harvest.clients.all
	@projects = harvest.projects.all
	@tasks = harvest.tasks.all
	#getting clients' names and ids in a collection
	client_ID_Table = []
	@clients.each do |c|
	client_ID_Table <<[
	{name: c['name'], id: c['id']},	
	]
	end
	#getting projects' id and corresponding client id in a collection
	project_ID_Table = []
	@projects.each do |c|
		project_ID_Table <<[
		{client_id: c['client_id'], project_id: c['id'] },
		]
	end
	#get task id associated with task name
	task_ID_Table = []
	@tasks.each do |c|
		task_ID_Table <<[
		{task_name: c['name'], task_id: c['id'] },
		]
	end
	#initializing active clients for selection
	@activeclients=[]
	@notactiveclients=[]
		@clients.each do |data|
			if data['active']==true
			@activeclients << data['name']
			else
			@notactiveclients << data['name']
			end
		end
	#initializing active tasks for selection	
	@activetasks=[]
	@notactivetasks=[]
		@tasks.each do |data|
			if data['deactivated']==false
			@activetasks << data['name']
			else
			@notactivetasks << data['name']
			end
		end
  end

  def show #showing the client time data 
  # @user = User.new
  # @user = User.find(params[:client, :task, :start_month, :start_day, :start_year, :end_month, :end_day, :end_year])
	#given user client param find associated client id (testing with param "Windward")
	subdomain = 'safetycheckinc'
	username = 'gscannell@safetycheckinc.com'
	password = 'safetycheck'
	harvest = Harvest.hardy_client(subdomain: subdomain, username: username, password: password)
	@clients = harvest.clients.all
	@projects = harvest.projects.all
	@tasks = harvest.tasks.all

	client_ID_Table = []
	@clients.each do |c|
		client_ID_Table <<[{name: c['name'], id: c['id']}]
	end
	#getting projects' id and corresponding client id in a collection
	project_ID_Table = []
	@projects.each do |c|
		project_ID_Table <<[{client_id: c['client_id'], project_id: c['id'] }]
	end
	#get task id associated with task name
	task_ID_Table = []
	@tasks.each do |c|
		task_ID_Table <<[{task_name: c['name'], task_id: c['id'] }]
	end

	@client_id = {}
	@client_id = client_ID_Table.select{|key, hash| key[:name] == params[:client]}
	@client_id = @client_id[0][0][:id] 
	#get project ids associated with cient id
	@project_ids = {}
	@project_ids = project_ID_Table.select{|key, hash| key[:client_id] == @client_id}
	@project_ids = [@project_ids[1][0][:project_id], @project_ids[0][0][:project_id]]
	#given user task param find assoiated task id (testing with param "inspection") 
	@task_id = {}
	@task_id = task_ID_Table.select{|key, hash| key[:task_name] == params[:task]}
	@task_id = @task_id[0][0][:task_id]
	#given user time params, get time parse for entry call
	@time_start = "#{params[:start_month]}/#{params[:start_day]}/#{params[:start_year]}" #"e.g. 11/22/2015"
	@time_end = "#{params[:end_month]}/#{params[:end_day]}/#{params[:end_year]}"         #"e.g. 11/23/2015"
	#get harvest entries for the two project id indices (field work and office work)
	office_entries = harvest.reports.time_by_project(Harvest::Project.new(id: @project_ids[0]), Time.parse(@time_start), Time.parse(@time_end))
	field_entries = harvest.reports.time_by_project(Harvest::Project.new(id: @project_ids[1]), Time.parse(@time_start), Time.parse(@time_end))
	 #intialize and get total entries and hours 
	@total_entries = 0
	@total_hours = 0
	office_entries.each do |data|
	  if data.task_id == @task_id
	     @total_hours += data.hours
	     @total_entries += 1
	  end
	end
	field_entries.each do |data|
	  if data.task_id == @task_id
	      @total_hours += data.hours
	    	@total_entries += 1
	  end
	end
  end
end
