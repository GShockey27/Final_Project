class HarvestingController < ApplicationController

  def index
  end

  def select #selecting the client params
  	subdomain = 'safetycheckinc'
	username = 'gscannell@safetycheckinc.com'
	password = 'voyager78'
	harvest = Harvest.hardy_client(subdomain: subdomain, username: username, password: password)
	@clients = harvest.clients.all
	@projects = harvest.projects.all
	@tasks = harvest.tasks.all
	@user = User.new
  end

  def show #showing the client time data
  	@client = User.find(params[:harvest_id])
  	@project = User.find(params[:harvest_id])
  	@task = User.find(params[:harvest_id])
  end

private

end
