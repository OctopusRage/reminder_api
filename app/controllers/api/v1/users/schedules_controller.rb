class Api::V1::Users::SchedulesController < ApplicationController
	before_action :authorize_user
	def index
		schedules = current_user.schedules.all
		render json: {
			status: 'success',
			data: schedules
		}, status: 200
	end

	def create
		schedule = current_user.schedules.new(schedule_params)
		if schedule.save
			render json: {
				status: 'success',
				data: schedule
			}, status: 201
		else
			render json: {
				status: 'fail',
				data: schedule.errors
			}, status: 422
		end
	end

	def update
		schedule = current_user.schedules.find(params[:id])
		if schedule.update(schedule_params)
			render json: {
				status: 'success',
				data: schedule
			}, status: 200
		else
			render json: {
				status: 'fail',
				data: schedule.errors
			}, status: 422
		end
	end

	def show
		schedule = current_user.schedules.find(params[:id])
		render json: {
			status: 'success',
			data: schedule
		}, status: 200
	end

	def destroy
		schedule = current_user.schedules.find(params[:id])
		if schedule.delete
			render json: {
				status: 'success'
			}, status: 204
		else
			render json: {
				status:'fail'
			}, status: 422
		end
	end

	private

		def schedule_params
			params.permit(:title, :started_at, :ended_at, :description, :location, :user_id, :status)
		end
end